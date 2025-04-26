import 'package:race_tracking_app_g5/models/participant.dart';
import 'package:race_tracking_app_g5/models/segment_time.dart';

class DashboardRow {
  final Participant participant;
  final SegmentTime? swimmingSegment;
  final SegmentTime? cyclingSegment;
  final SegmentTime? runningSegment;

  DashboardRow({
    required this.participant,
    this.swimmingSegment,
    this.cyclingSegment,
    this.runningSegment,
  });
}
