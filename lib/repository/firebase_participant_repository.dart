import 'package:firebase_database/firebase_database.dart';
import 'package:logger/logger.dart';
import 'package:race_tracking_app_g5/dto/participant_dto.dart';
import 'package:race_tracking_app_g5/models/participant.dart';
import 'package:race_tracking_app_g5/repository/participant_repository.dart';

class RealtimeParticipantRepository implements ParticipantRepository {
  final DatabaseReference _database = FirebaseDatabase.instance.ref(
    'participant',
  );
  final Logger logger = Logger();

  @override
  Stream<List<Participant>> getParticipantsStream() {
    return _database.onValue.map((event) {
      final Map<dynamic, dynamic>? data = event.snapshot.value as Map?;
      if (data == null) return [];

      final List<Participant> participants = [];
      data.forEach((key, value) {
        final Map<String, dynamic> participantData = Map<String, dynamic>.from(
          value,
        );
        final dto = ParticipantDto.fromJson({'id': key, ...participantData});
        participants.add(dto.toModel());
      });

      return participants;
    });
  }

  @override
  Future<List<Participant>> getAllParticipants() async {
    try {
      final snapshot = await _database.get();

      if (!snapshot.exists || snapshot.value == null) {
        return [];
      }

      final Map<dynamic, dynamic> data =
          snapshot.value as Map<dynamic, dynamic>;
      final List<Participant> participants = [];

      data.forEach((key, value) {
        final Map<String, dynamic> participantData = Map<String, dynamic>.from(
          value,
        );
        final dto = ParticipantDto.fromJson({'id': key, ...participantData});
        participants.add(dto.toModel());
      });

      return participants;
    } catch (e) {
      logger.e("Error fetching participants: $e");
      throw Exception('Failed to load participants: $e');
    }
  }

  @override
  Future<Participant> addParticipant(String name, int bibNumber) async {
    try {
      final dto = ParticipantDto(name: name, bibNumber: bibNumber);
      final newRef = _database.push();
      await newRef.set(dto.toJson());

      return Participant(id: newRef.key!, name: name, bibNumber: bibNumber);
    } catch (e) {
      logger.e("Error adding participant: $e");
      throw Exception('Failed to add participant: $e');
    }
  }

  @override
  Future<void> deleteParticipant(String id) async {
    try {
      await _database.child(id).remove();
    } catch (e) {
      logger.e("Error deleting participant: $e");
      throw Exception('Failed to delete participant: $e');
    }
  }

  @override
  Future<Participant> getParticipantById(String id) async {
    try {
      final snapshot = await _database.child(id).get();

      if (!snapshot.exists || snapshot.value == null) {
        throw Exception('Participant not found with ID: $id');
      }

      final data = snapshot.value as Map<dynamic, dynamic>;
      final dto = ParticipantDto.fromJson({
        'id': id,
        ...Map<String, dynamic>.from(data),
      });

      return dto.toModel();
    } catch (e) {
      logger.e("Error getting participant: $e");
      throw Exception('Failed to get participant: $e');
    }
  }

  @override
  Future<void> updateParticipant(String name, int bibNumber, String id) async {
    try {
      final dto = ParticipantDto(name: name, bibNumber: bibNumber);
      await _database.child(id).update(dto.toJson());
    } catch (e) {
      logger.e("Error updating participant: $e");
      throw Exception('Failed to update participant: $e');
    }
  }
}
