enum RaceStatus { notStarted, started, finished }

extension RaceStatusExtension on RaceStatus {
  String get label {
    switch (this) {
      case RaceStatus.notStarted:
        return 'Not Started';
      case RaceStatus.started:
        return 'Started';
      case RaceStatus.finished:
        return 'Finished';
    }
  }
}

class Race {
  RaceStatus raceStatus = RaceStatus.notStarted;
  //timestamp in milliseconds
  final int startTime;

  Race({required this.raceStatus, required this.startTime});

  factory Race.fromMap(Map<String, dynamic> map) {
    return Race(
      raceStatus: _statusFromString(map['raceStatus']),
      startTime: map['startTime'] ?? 0,
    );
  }

  static RaceStatus _statusFromString(String status) {
    switch (status) {
      case 'notStarted':
        return RaceStatus.notStarted;
      case 'started':
        return RaceStatus.started;
      case 'finished':
        return RaceStatus.finished;
      default:
        return RaceStatus.notStarted; // fallback
    }
  }
}
