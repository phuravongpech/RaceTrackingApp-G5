import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:race_tracking_app_g5/models/participant.dart';
import 'package:race_tracking_app_g5/models/race.dart';
import 'package:race_tracking_app_g5/providers/race_provider.dart';
import 'package:race_tracking_app_g5/providers/segment_tracking_provider.dart';
import 'package:race_tracking_app_g5/screens/participant/widgets/participant_list_view.dart';
import 'package:race_tracking_app_g5/screens/race/widgets/race_clock_timer.dart';
import 'package:race_tracking_app_g5/theme/theme.dart';
import 'package:race_tracking_app_g5/utils/dialog_util.dart';
import 'package:race_tracking_app_g5/utils/snack_bar_util.dart';
import 'package:race_tracking_app_g5/widgets/button/rt_button.dart';

class RaceScreen extends StatelessWidget {
  const RaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //race is for accessing the race object in provider
    final race = Provider.of<Race?>(context);
    //race provider is for accessing the methods inside that provider
    //listen is false cuz we are only calling methods no need to rebuild
    final raceProvider = Provider.of<RaceProvider>(context, listen: false);

    //same goes here as we only want the list of participants
    final participants = Provider.of<List<Participant>>(context);

    final segmentProvider = Provider.of<SegmentTrackingProvider>(
      context,
      listen: false,
    );
    final screenHeight = MediaQuery.of(context).size.height;

    Future<void> handleRaceAction(RaceStatus status) async {
      switch (status) {
        case RaceStatus.notStarted:
          if (participants.isEmpty) {
            SnackBarUtil.show(
              context,
              message: "No current participants",
              isError: true,
            );
            return;
          }

          raceProvider.startRace();
          break;
        case RaceStatus.started:
          final shouldFinish = await DialogUtil.showConfirmationDialog(
            context: context,
            title: 'Finish Race',
            message: 'Are you sure you want to finish the race?',
            confirmText: 'Finish',
            confirmColor: RTColors.primary,
          );
          if (shouldFinish) {
            raceProvider.finishRace();
          }

          break;
        case RaceStatus.finished:
          break;
      }
    }

    Future<void> handleRestart() async {
      final shouldRestart = await DialogUtil.showConfirmationDialog(
        context: context,
        title: 'Restart Race',
        message: 'Are you sure you want to restart the race?',
        confirmText: 'Restart',
      );
      if (shouldRestart) {
        raceProvider.restartRace();
        segmentProvider.clearAllSegments();
        SnackBarUtil.show(
          context,
          message: "Race restarted, Race data cleared",
        );
      }
    }

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
        handleRaceAction(race.raceStatus);
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Race'),
        actions: [
          IconButton(
            onPressed: handleRestart,
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
              Center(
                child: Text(
                  DateTime.fromMillisecondsSinceEpoch(
                    race!.startTime,
                  ).toString(),
                  style: Theme.of(
                    context,
                  ).textTheme.headlineSmall?.copyWith(color: RTColors.black),
                ),
              ),
              const SizedBox(height: 20),
              const Center(child: RaceClockLive()),
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
