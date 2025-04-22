import 'package:race_tracking_app_g5/models/participant.dart';

enum RaceStatus { notStarted, started, finished }

class Race {
  final RaceStatus raceStatus;
  //timestamp in milliseconds
  final int startTime;
  final List<Participant> participants = [];

  Race({required this.raceStatus, required this.startTime});
}
