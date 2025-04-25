import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:race_tracking_app_g5/models/participant.dart';

class ParticipantProvider extends ChangeNotifier {
  final _ref = FirebaseDatabase.instance.ref('participant');

  Stream<List<Participant>> get stream {
    return _ref.onValue.map((event) {
      final data = event.snapshot.value as Map?;
      if (data == null) return [];
      final participants =
          data.entries.map((e) {
            return Participant.fromMap(
              Map<String, dynamic>.from(e.value),
              e.key,
            );
          }).toList();
      // Sort participants by bib number
      participants.sort((a, b) => a.bibNumber.compareTo(b.bibNumber));
      return participants;
    });
  }

  Future<void> addParticipant(String name, int bibNumber) async {
    final newRef = _ref.push();
    await newRef.set({'name': name, 'bibNumber': bibNumber});
  }

  Future<void> deleteParticipant(String id) async {
    await _ref.child(id).remove();
  }

  Future<void> updateParticipant(String id, String name, int bibNumber) async {
    await _ref.child(id).update({'name': name, 'bibNumber': bibNumber});
  }
}
