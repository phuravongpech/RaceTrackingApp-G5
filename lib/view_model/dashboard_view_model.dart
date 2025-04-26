import 'dart:async';

import 'package:flutter/material.dart';
import 'package:race_tracking_app_g5/models/dashboard_row.dart';
import 'package:race_tracking_app_g5/models/participant.dart';
import 'package:race_tracking_app_g5/models/segment_time.dart';
import 'package:race_tracking_app_g5/providers/participant_provider.dart';
import 'package:race_tracking_app_g5/providers/segment_tracking_provider.dart';

class DashboardViewModel extends ChangeNotifier {
  final ParticipantProvider participantProvider;
  final SegmentTrackingProvider segmentTrackingProvider;

  List<Participant> participantList = [];
  List<SegmentTime> segmentTimeList = [];

  // subscription to stream to listen to updates from realtime db
  StreamSubscription<List<Participant>>? participantSubscription;
  StreamSubscription<List<SegmentTime>>? segmentSubscription;

  //store the rows
  List<DashboardRow> dashboardRows = [];

  DashboardViewModel({
    required this.participantProvider,
    required this.segmentTrackingProvider,
  }) {
    // start listening to participants
    participantSubscription = participantProvider.stream.listen(
      _onParticipantUpdate,
    );

    // start listening to segment times
    segmentSubscription = segmentTrackingProvider.segmentsStream.listen(
      _onSegmentUpdate,
    );
  }

  /// Called whenever the participant list changes.
  void _onParticipantUpdate(List<Participant> updatedParticipants) {
    participantList = updatedParticipants;
    _rebuildDashboardRows();
  }

  /// Called whenever the segmenttime list changes.
  void _onSegmentUpdate(List<SegmentTime> updatedSegmentTimes) {
    segmentTimeList = updatedSegmentTimes;
    _rebuildDashboardRows();
  }

  void _rebuildDashboardRows() {
    final Map<String, Map<Segment, SegmentTime>> participantRecord = {};

    //building a map of part record in each {partId, {segment : SegmentTime}}
    for (var record in segmentTimeList) {
      final id = record.participantId;
      participantRecord.putIfAbsent(id, () => {})[record.segment] = record;
    }

    //for each part, they have a dashboard row,
    //
    dashboardRows =
        participantList.map((participant) {
          final Map<Segment, SegmentTime> eachSegmentRecord =
              participantRecord[participant.id] ?? {};

          return DashboardRow(
            participant: participant,
            swimmingSegment: eachSegmentRecord[Segment.swimming],
            cyclingSegment: eachSegmentRecord[Segment.cycling],
            runningSegment: eachSegmentRecord[Segment.running],
          );
        }).toList();

    notifyListeners();
  }
}
