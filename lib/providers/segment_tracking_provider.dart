import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:race_tracking_app_g5/models/segment_time.dart';

class SegmentTrackingProvider extends ChangeNotifier {
  final _ref = FirebaseDatabase.instance.ref('segments');

  Stream<List<SegmentTime>> get segmentsStream {
    return _ref.onValue.map((evt) {
      final data = evt.snapshot.value as Map<dynamic, dynamic>?;
      if (data == null) return [];
      return data.values
          .map((v) => SegmentTime.fromMap(Map<String, dynamic>.from(v)))
          .toList();
    });
  }

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

  Future<void> clearAllSegments() async {
    await _ref.remove();
  }
}
