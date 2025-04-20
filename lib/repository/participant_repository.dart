import 'package:logger/logger.dart';
import 'package:race_tracking_app_g5/models/participant.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

abstract class ParticipantRepository {
  Future<List<Participant>> getAllParticipants();
  Future<Participant> getParticipantById(String id);
  Future<Participant> addParticipant(String name, int bibNumber);
  Future<void> updateParticipant(String name, int bibNumber, String id);
  Future<void> deleteParticipant(String id);
}

class FirebaseParticipantRepository implements ParticipantRepository {
  static const String baseUrl =
      'https://vong-690e4-default-rtdb.asia-southeast1.firebasedatabase.app/';
  static const String endpoint = 'participant';
  static const String url = '$baseUrl/$endpoint.json';
  @override
  Future<List<Participant>> getAllParticipants() async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<Participant> participants = [];
        final Map<String, dynamic> data = json.decode(response.body);
        data.forEach((key, value) {
          participants.add(Participant.fromJson(key, value));
        });
        return participants;
      } else {
        throw Exception('Failed to load participants');
      }
    } catch (e) {
      throw Exception('Failed to load participants: $e');
    }
  }

  @override
  Future<Participant> addParticipant(String name, int bibNumber) async {
    try {
      final newParticipant = {'name': name, 'bibNumber': bibNumber};
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(newParticipant),
      );
      if (response.statusCode == 200) {
        Logger().d('Participant added successfully with ID: ${response.body}');
      } else {
        throw Exception('Failed to add participant');
      }

      final newId = json.decode(response.body)['name'];
      return Participant(id: newId, name: name, bibNumber: bibNumber);
    } catch (e) {
      throw Exception('Failed to add participant: $e');
    }
  }

  @override
  Future<void> deleteParticipant(String id) async {
    try {
      final deleteUrl = '$baseUrl/$endpoint/$id.json';
      final response = await http.delete(
        Uri.parse(deleteUrl),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        Logger().d('Participant deleted successfully: ${response.body}');
      } else {
        throw Exception('Failed to delete participant');
      }
    } catch (e) {
      throw Exception('Failed to delete participant: $e');
    }
  }

  @override
  Future<Participant> getParticipantById(String id) {
    // TODO: implement getParticipantById
    throw UnimplementedError();
  }

  @override
  Future<void> updateParticipant(String name, int bibNumber, String id) async {
    try {
      final editedParticipant = {'name': name, 'bibNumber': bibNumber};
      final putUrl = '$baseUrl/$endpoint/$id.json';
      final response = await http.put(
        Uri.parse(putUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(editedParticipant),
      );
      if (response.statusCode == 200) {
        Logger().d('Participant updated successfully: ${response.body}');
      } else {
        throw Exception('Failed to update participant');
      }
    } catch (e) {
      throw Exception('Failed to edit participant: $e');
    }
  }
}
