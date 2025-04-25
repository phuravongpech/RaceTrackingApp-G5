import 'package:firebase_database/firebase_database.dart';
import 'package:race_tracking_app_g5/models/segment_time.dart';

class SegmentTrackingProvider {
  final _ref = FirebaseDatabase.instance.ref('segments');

  Future<void> recordSegmentTime(
    String participantId,
    Segment segment,
    int raceStartTime,
  ) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final elapsedTimeInSeconds = now - raceStartTime;

    final segmentRef = _ref.push();
    await segmentRef.set({
      'participantId': participantId,
      'segment': segment.label,
      'elapsedTimeInSeconds': elapsedTimeInSeconds, // Time since race start
    });
  }
}
