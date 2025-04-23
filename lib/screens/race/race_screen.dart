import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:race_tracking_app_g5/models/participant.dart';
import 'package:race_tracking_app_g5/screens/participant/widgets/participant_list_view.dart';
import 'package:race_tracking_app_g5/screens/race/widgets/race_flip_clock.dart';
import 'package:race_tracking_app_g5/theme/theme.dart';
import 'package:race_tracking_app_g5/utils/date_time_util.dart';
import 'package:race_tracking_app_g5/widgets/button/rt_button.dart';

class RaceScreen extends StatelessWidget {
  const RaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final participants = Provider.of<List<Participant>>(context);
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(title: const Text('Race')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              // Race info section
              Center(
                child: Text(
                  DateTimeUtil.formatDate(DateTime.now()),
                  style: Theme.of(
                    context,
                  ).textTheme.headlineSmall?.copyWith(color: RTColors.black),
                ),
              ),
              const SizedBox(height: 20),
              const Center(child: RaceFlipClock()),
              const SizedBox(height: 20),
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.circle),
                    const SizedBox(width: 8),
                    Text(
                      'Status : Started',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              RtButton(
                text: 'Start',
                onPressed: () {},
                type: RtButtonType.primary,
                fullWidth: false,
              ),
              const SizedBox(height: 20),

              SizedBox(
                height: screenHeight * 0.4, // 40% of screen height
                child: ParticipantListView(
                  participants: participants,
                  showToggle: true,
                  toggleTitle: 'Race Participants',
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
