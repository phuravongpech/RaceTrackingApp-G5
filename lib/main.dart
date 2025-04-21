import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:race_tracking_app_g5/firebase_options.dart';
import 'package:race_tracking_app_g5/providers/participant_provider.dart';
import 'package:race_tracking_app_g5/repository/firebase_participant_repository.dart';
import 'package:race_tracking_app_g5/repository/participant_repository.dart';
import 'package:race_tracking_app_g5/screens/participant/participant_screen.dart';
import 'package:race_tracking_app_g5/screens/race/race_screen.dart';
import 'package:race_tracking_app_g5/theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final participantRepository = RealtimeParticipantRepository();

  runApp(MyApp(participantRepository: participantRepository));
}

class MyApp extends StatelessWidget {
  final ParticipantRepository participantRepository;

  const MyApp({super.key, required this.participantRepository});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ParticipantProvider(participantRepository),
        ),
        // ChangeNotifierProvider(
        //   create: (context) => RaceProvider(raceRepo),
        // ),
      ],
      child: MaterialApp(
        home: HomeScreen(),
        debugShowCheckedModeBanner: false,
        theme: appTheme,
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [const RaceScreen(), const ParticipantScreen()];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Participant',
          ),
        ],
      ),
    );
  }
}
