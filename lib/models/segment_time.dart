import 'package:race_tracking_app_g5/models/participant.dart';

enum Segment { swimming, cycling, running }

class SegmentTime {
  final Segment segment;
  final Participant participant;
  final String elapsedTimeInSeconds;
  // example: 753sec  = 12 mins 33 secs

  SegmentTime({
    required this.segment,
    required this.participant,
    required this.elapsedTimeInSeconds,
  });
}
