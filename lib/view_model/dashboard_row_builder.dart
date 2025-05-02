import 'package:race_tracking_app_g5/models/dashboard_row.dart';
import 'package:race_tracking_app_g5/models/participant.dart';
import 'package:race_tracking_app_g5/models/segment_time.dart';

class DashboardRowBuilder {
  List<DashboardRow> buildRows({
    required List<Participant> participants,
    required List<SegmentTime> segmentTimes,
  }) {
    final Map<String, Map<Segment, SegmentTime>> participantRecord = {};

    for (var record in segmentTimes) {
      final id = record.participantId;
      participantRecord.putIfAbsent(id, () => {})[record.segment] = record;
    }

    return participants.map((participant) {
      final segmentMap = participantRecord[participant.id] ?? {};

      return DashboardRow(
        participant: participant,
        swimmingSegment: segmentMap[Segment.swimming],
        cyclingSegment: segmentMap[Segment.cycling],
        runningSegment: segmentMap[Segment.running],
      );
    }).toList();
  }
}