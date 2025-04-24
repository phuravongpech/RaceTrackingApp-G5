import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:race_tracking_app_g5/models/race.dart';

class RaceProvider {
  final _ref = FirebaseDatabase.instance.ref('race');

  Stream<Race?> get raceStream {
    return _ref.onValue.map((event) {
      final data = event.snapshot.value;
      print('Raw race data: $data'); // 👈 Add this
      if (data != null && data is Map) {
        return Race.fromMap(Map<String, dynamic>.from(data));
      } else {
        return null;
      }
    });
  }

  Future<void> startRace() async {
    await _ref.update({
      'raceStatus': 'started',
      'startTime': DateTime.now().millisecondsSinceEpoch,
    });
  }

  Future<void> finishRace() async {
    await _ref.update({'raceStatus': 'finished'});
  }

  Future<void> restartRace() async {
    await _ref.update({'raceStatus': 'notStarted', 'startTime': 0});
  }
}
