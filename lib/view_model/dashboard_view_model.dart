import 'dart:async';

import 'package:flutter/material.dart';
import 'package:race_tracking_app_g5/models/dashboard_row.dart';
import 'package:race_tracking_app_g5/models/participant.dart';
import 'package:race_tracking_app_g5/models/segment_time.dart';
import 'package:race_tracking_app_g5/providers/participant_provider.dart';
import 'package:race_tracking_app_g5/providers/segment_tracking_provider.dart';
import 'package:race_tracking_app_g5/view_model/dashboard_row_builder.dart';

class DashboardViewModel extends ChangeNotifier {
  final ParticipantProvider participantProvider;
  final SegmentTrackingProvider segmentTrackingProvider;
  final DashboardRowBuilder rowBuilder;

  List<Participant> _participantList = [];
  List<SegmentTime> _segmentTimeList = [];
  List<DashboardRow> dashboardRows = [];

  StreamSubscription<List<Participant>>? _participantSubscription;
  StreamSubscription<List<SegmentTime>>? _segmentSubscription;

  DashboardViewModel({
    required this.participantProvider,
    required this.segmentTrackingProvider,
    required this.rowBuilder,
  }) {
    _participantSubscription = participantProvider.stream.listen(
      _onParticipantsUpdated,
    );
    _segmentSubscription = segmentTrackingProvider.segmentsStream.listen(
      _onSegmentsUpdated,
    );
  }

  void _onParticipantsUpdated(List<Participant> participants) {
    _participantList = participants;
    _rebuildRows();
  }

  void _onSegmentsUpdated(List<SegmentTime> segmentTimes) {
    _segmentTimeList = segmentTimes;
    _rebuildRows();
  }

  void _rebuildRows() {
    dashboardRows = rowBuilder.buildRows(
      participants: _participantList,
      segmentTimes: _segmentTimeList,
    );
    notifyListeners();
  }

  @override
  void dispose() {
    _participantSubscription?.cancel();
    _segmentSubscription?.cancel();
    super.dispose();
  }
}
