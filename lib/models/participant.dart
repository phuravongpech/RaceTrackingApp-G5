class Participant {
  final String id;
  final String name;
  final int bibNumber;

  Participant({required this.id, required this.name, required this.bibNumber});

  factory Participant.fromJson(String id, Map<String, dynamic> json) {
    return Participant(
      id: id,
      name: json['name'] as String,
      bibNumber: json['bibNumber'] as int,
    );
  }
}
