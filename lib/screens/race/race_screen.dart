import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:race_tracking_app_g5/models/participant.dart';
import 'package:race_tracking_app_g5/models/race.dart';
import 'package:race_tracking_app_g5/providers/race_provider.dart';
import 'package:race_tracking_app_g5/screens/participant/widgets/participant_list_view.dart';
import 'package:race_tracking_app_g5/screens/race/widgets/race_flip_clock.dart';
import 'package:race_tracking_app_g5/theme/theme.dart';
import 'package:race_tracking_app_g5/utils/date_time_util.dart';
import 'package:race_tracking_app_g5/widgets/button/rt_button.dart';

class RaceScreen extends StatelessWidget {
  const RaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //race is for accessing the race object in provider
    final race = Provider.of<Race?>(context);
    print('Race received: $race');
    //race provider is for accessing the methods inside that provider
    //listen is false cuz we are only calling methods no need to rebuild
    final raceProvider = Provider.of<RaceProvider>(context, listen: false);

    //same goes here as we only want the list of participants
    final participants = Provider.of<List<Participant>>(context);
    final screenHeight = MediaQuery.of(context).size.height;

    Widget button = RtButton(
      text: () {
        if (race == null) return 'Loading...';
        switch (race.raceStatus) {
          case RaceStatus.notStarted:
            return 'Start';
          case RaceStatus.started:
            return 'In Progress';
          case RaceStatus.finished:
            return 'Finished';
        }
      }(),
      onPressed: () {
        if (race == null) return;

        switch (race.raceStatus) {
          case RaceStatus.notStarted:
            raceProvider.startRace();
            break;
          case RaceStatus.started:
            raceProvider.finishRace();
          case RaceStatus.finished:
            break;
        }
      },
      type: () {
        if (race == null) return RtButtonType.primary;
        switch (race.raceStatus) {
          case RaceStatus.notStarted:
            return RtButtonType.primary;
          case RaceStatus.started:
            return RtButtonType.secondary;
          case RaceStatus.finished:
            return RtButtonType.disabled;
        }
      }(),
      fullWidth: false,
    );

    Color getStatusColor(RaceStatus? status) {
      if (status == null) {
        return RTColors.textSecondary; // Default to secondary color (grey)
      }

      switch (status) {
        case RaceStatus.notStarted:
          return RTColors.textSecondary; // Grey color
        case RaceStatus.started:
          return RTColors.primary; // Green or active color
        case RaceStatus.finished:
          return RTColors.textSecondary; // Blue color for finished
      }
    }

    void showRestartRaceDialog(BuildContext context) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Restart Race'),
            content: const Text('Are you sure you want to restart the race?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Provider.of<RaceProvider>(
                    context,
                    listen: false,
                  ).restartRace();
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: RTColors.error,
                ),
                child: const Text('Restart'),
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Race'),
        actions: [
          IconButton(
            onPressed: () {
              showRestartRaceDialog(context);
            },
            icon: Icon(
              Icons.settings_backup_restore_rounded,
              size: 40,
              color: RTColors.tertiary,
            ),
          ),
          SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              // Center(
              //   child: Text(
              //     DateTimeUtil.formatDate(DateTime.now()),
              //     style: Theme.of(
              //       context,
              //     ).textTheme.headlineSmall?.copyWith(color: RTColors.black),
              //   ),
              // ),
              const SizedBox(height: 20),
              const Center(child: RaceFlipClock()),
              const SizedBox(height: 20),
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.circle, color: getStatusColor(race?.raceStatus)),
                    const SizedBox(width: 8),
                    Text(
                      'Status : ${race != null ? race.raceStatus.label : 'Unknown'}',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: getStatusColor(race?.raceStatus),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              button,
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
