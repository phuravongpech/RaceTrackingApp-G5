import 'package:race_tracking_app_g5/models/participant.dart';

class ParticipantDto {
  final String? id;
  final String name;
  final int bibNumber;

  ParticipantDto({this.id, required this.name, required this.bibNumber});

  factory ParticipantDto.fromJson(Map<String, dynamic> json) {
    return ParticipantDto(
      id: json['id'],
      name: json['name'] ?? '',
      bibNumber: json['bibNumber'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'bibNumber': bibNumber};
  }

  Participant toModel() {
    return Participant(id: id ?? '', name: name, bibNumber: bibNumber);
  }
}
