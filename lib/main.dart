import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:race_tracking_app_g5/firebase_options.dart';
import 'package:race_tracking_app_g5/models/participant.dart';
import 'package:race_tracking_app_g5/models/race.dart';
import 'package:race_tracking_app_g5/models/segment_time.dart';
import 'package:race_tracking_app_g5/providers/participant_provider.dart';
import 'package:race_tracking_app_g5/providers/race_provider.dart';
import 'package:race_tracking_app_g5/providers/segment_tracking_provider.dart';
import 'package:race_tracking_app_g5/screens/dashboard/dashboard_screen.dart';
import 'package:race_tracking_app_g5/screens/participant/participant_screen.dart';
import 'package:race_tracking_app_g5/screens/race/race_screen.dart';
import 'package:race_tracking_app_g5/screens/segment_tracking/segment_tracking_screen.dart';
import 'package:race_tracking_app_g5/theme/theme.dart';
import 'package:race_tracking_app_g5/view_model/dashboard_row_builder.dart';
import 'package:race_tracking_app_g5/view_model/dashboard_view_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const RaceScreen(),
    const SegmentTrackingScreen(),
    const ParticipantScreen(),
    const DashboardScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        //race providers
        Provider<RaceProvider>(create: (_) => RaceProvider()),
        StreamProvider<Race?>(
          create: (context) => context.read<RaceProvider>().raceStream,
          initialData: Race(
            raceStatus: RaceStatus.notStarted,
            startTime: 0,
            endTime: 0,
          ),
          catchError: (_, __) => null,
        ),

        //participant providers
        ChangeNotifierProvider<ParticipantProvider>(
          create: (_) => ParticipantProvider(),
        ),
        StreamProvider<List<Participant>>(
          create: (context) {
            final participantProvider = Provider.of<ParticipantProvider>(
              context,
              listen: false,
            );
            return participantProvider.stream;
          },
          initialData: [],
          catchError: (_, __) => [],
        ),

        //segment providers
        ChangeNotifierProvider<SegmentTrackingProvider>(
          create: (_) => SegmentTrackingProvider(),
        ),
        StreamProvider<List<SegmentTime>>(
          create: (ctx) => ctx.read<SegmentTrackingProvider>().segmentsStream,
          initialData: [],
        ),

        //dashboard view
        ChangeNotifierProvider(
          create:
              (context) => DashboardViewModel(
                participantProvider: context.read<ParticipantProvider>(),
                segmentTrackingProvider:
                    context.read<SegmentTrackingProvider>(),
                rowBuilder: DashboardRowBuilder(),
              ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: appTheme,
        home: Scaffold(
          body: IndexedStack(index: _selectedIndex, children: _screens),

          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.run_circle_outlined, size: 30),
                label: 'Race',
              ),
              BottomNavigationBarItem(icon: Icon(Icons.flag), label: 'Segment'),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Participant',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.leaderboard_outlined),
                label: 'Dashboard',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
