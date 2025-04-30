import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:race_tracking_app_g5/models/participant.dart';
import 'package:race_tracking_app_g5/models/segment_time.dart';
import 'package:race_tracking_app_g5/screens/race/widgets/race_clock_timer.dart';
import 'package:race_tracking_app_g5/screens/segment_tracking/widgets/participant_grid_card.dart';
import 'package:race_tracking_app_g5/screens/segment_tracking/widgets/segment_tabbar.dart';

class SegmentTrackingScreen extends StatefulWidget {
  const SegmentTrackingScreen({super.key});

  @override
  State<SegmentTrackingScreen> createState() => _SegmentTrackingScreenState();
}

class _SegmentTrackingScreenState extends State<SegmentTrackingScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  final List<Segment> _segments = Segment.values;
  Segment _currentSegment = Segment.swimming;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _segments.length, vsync: this);

    _tabController?.addListener(() {
      if (!(_tabController?.indexIsChanging ?? true)) {
        setState(() {
          _currentSegment = _segments[_tabController?.index ?? 0];
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final participants = Provider.of<List<Participant>>(context);

    Widget participantCard = GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.2,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
      ),
      itemCount: participants.length,
      itemBuilder: (context, index) {
        final participant = participants[index];
        return ParticipantGridCard(
          name: participant.name,
          bibNumber: participant.bibNumber,
          segment: _currentSegment,
          id: participant.id,
        );
      },
    );
    return Scaffold(
      appBar: AppBar(title: const Text('Segment Tracking')),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const RaceClockLive(),
                const SizedBox(height: 20),
                SegmentTabbar(
                  segments: _segments,
                  tabController: _tabController!,
                ),
                const SizedBox(height: 20),
                participantCard,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
