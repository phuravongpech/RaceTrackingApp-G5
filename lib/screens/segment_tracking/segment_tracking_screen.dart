import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:race_tracking_app_g5/models/participant.dart';
import 'package:race_tracking_app_g5/models/segment_time.dart';
import 'package:race_tracking_app_g5/screens/race/widgets/race_clock_timer.dart';
import 'package:race_tracking_app_g5/screens/segment_tracking/widgets/participant_grid_card.dart';
import 'package:race_tracking_app_g5/theme/theme.dart';

class SegmentTrackingScreen extends StatefulWidget {
  const SegmentTrackingScreen({super.key});

  @override
  State<SegmentTrackingScreen> createState() => _SegmentTrackingScreenState();
}

class _SegmentTrackingScreenState extends State<SegmentTrackingScreen> {
  Segment _currentSegment = Segment.swimming;

  @override
  Widget build(BuildContext context) {
    final participants = Provider.of<List<Participant>>(context);

    Widget filterDropdown = Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: RTColors.backgroundAccent,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: RTColors.textSecondary.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Text(
            'Current Segment:',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: RTColors.textSecondary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<Segment>(
                value: _currentSegment,
                isExpanded: true,
                icon: const Icon(Icons.arrow_drop_down),
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(color: RTColors.textPrimary),
                items:
                    Segment.values.map((segment) {
                      return DropdownMenuItem(
                        value: segment,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: RTColors.backgroundAccent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            segment.label,
                            style: TextStyle(
                              color: RTColors.primary,
                              fontSize: 25,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                onChanged: (Segment? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _currentSegment = newValue;
                    });
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );

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
                filterDropdown,
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
