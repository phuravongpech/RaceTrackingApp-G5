class Participant {
  final String id;
  final String name;
  final int bibNumber;

  Participant({required this.id, required this.name, required this.bibNumber});

  factory Participant.fromMap(Map<String, dynamic> map, String id) {
    return Participant(
      id: id,
      name: map['name'] ?? '',
      bibNumber: map['bibNumber'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {'name': name, 'bibNumber': bibNumber};
  }
}
