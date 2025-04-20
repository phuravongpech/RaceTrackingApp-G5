import 'dart:convert';
import 'package:logger/logger.dart';
import 'package:race_tracking_app_g5/dto/participant_dto.dart';
import 'package:race_tracking_app_g5/models/participant.dart';
import 'package:race_tracking_app_g5/repository/firebase_service.dart';
import 'package:race_tracking_app_g5/repository/participant_repository.dart';

class FirebaseParticipantRepository implements ParticipantRepository {
  final FirebaseService firebaseService;
  final String endpoint = 'participant';
  final Logger logger = Logger();

  FirebaseParticipantRepository({required this.firebaseService});

  @override
  Future<List<Participant>> getAllParticipants() async {
    try {
      final response = await firebaseService.get(endpoint);

      if (response.statusCode == 200) {
        final Map<String, dynamic>? data = json.decode(response.body);
        if (data == null) return [];

        final List<Participant> participants = [];
        data.forEach((key, value) {
          final dto = ParticipantDto.fromJson({'id': key, ...value});
          participants.add(dto.toModel());
        });

        return participants;
      } else {
        throw Exception('Failed to load participants: ${response.statusCode}');
      }
    } catch (e) {
      logger.e("Error loading participants: $e");
      throw Exception('Failed to load participants: $e');
    }
  }

  @override
  Future<Participant> addParticipant(String name, int bibNumber) async {
    try {
      final dto = ParticipantDto(name: name, bibNumber: bibNumber);
      final response = await firebaseService.post(endpoint, dto.toJson());

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final generatedId = responseData['name'];

        return Participant(id: generatedId, name: name, bibNumber: bibNumber);
      } else {
        throw Exception('Failed to add participant: ${response.statusCode}');
      }
    } catch (e) {
      logger.e("Error adding participant: $e");
      throw Exception('Failed to add participant: $e');
    }
  }

  @override
  Future<void> deleteParticipant(String id) async {
    try {
      final response = await firebaseService.delete(endpoint, id);

      if (response.statusCode != 200) {
        throw Exception('Failed to delete participant: ${response.statusCode}');
      }
    } catch (e) {
      logger.e("Error deleting participant: $e");
      throw Exception('Failed to delete participant: $e');
    }
  }

  @override
  Future<Participant> getParticipantById(String id) async {
    try {
      final response = await firebaseService.get(endpoint, id: id);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        // Check if the participant exists
        if (responseData == null) {
          throw Exception('Participant not found with ID: $id');
        }

        final dto = ParticipantDto.fromJson({'id': id, ...responseData});
        return dto.toModel();
      } else {
        throw Exception('Failed to get participant: ${response.statusCode}');
      }
    } catch (e) {
      logger.e("Error getting participant: $e");
      throw Exception('Failed to get participant: $e');
    }
  }

  @override
  Future<void> updateParticipant(String name, int bibNumber, String id) async {
    try {
      final dto = ParticipantDto(id: id, name: name, bibNumber: bibNumber);
      final response = await firebaseService.put(endpoint, id, dto.toJson());

      if (response.statusCode != 200) {
        throw Exception('Failed to update participant: ${response.statusCode}');
      }
    } catch (e) {
      logger.e("Error updating participant: $e");
      throw Exception('Failed to update participant: $e');
    }
  }
}
