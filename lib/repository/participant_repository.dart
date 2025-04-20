import 'package:race_tracking_app_g5/models/participant.dart';

abstract class ParticipantRepository {
  Future<List<Participant>> getAllParticipants();
  Future<Participant> getParticipantById(String id);
  Future<Participant> addParticipant(String name, int bibNumber);
  Future<void> updateParticipant(String name, int bibNumber, String id);
  Future<void> deleteParticipant(String id);
}
