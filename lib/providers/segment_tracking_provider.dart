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

  /// Removes the last recorded segment time for a specific participant.
  /// It fetches all segment times, filters them by the given participant ID,
  /// sorts them in descending order of elapsed time, and removes the most recent one.
  Future<void> undoLastSegment(String participantId) async {
    final snapshot = await _ref.get();

    if (snapshot.exists) {
      final data = Map<String, dynamic>.from(snapshot.value as Map);
      final entries =
          data.entries
              .map(
                (e) => MapEntry(
                  e.key,
                  SegmentTime.fromMap(Map<String, dynamic>.from(e.value)),
                ),
              )
              .where((entry) => entry.value.participantId == participantId)
              .toList();
      if (entries.isEmpty) return;
      entries.sort(
        (a, b) => b.value.elapsedTimeInSeconds.compareTo(
          a.value.elapsedTimeInSeconds,
        ),
      );

      await _ref.child(entries.first.key).remove();
    }
  }
}
