class Message {
  final String id;
  final String text;
  final String? audienceLabel; // ej: "Mamá"
  final String ownerId;

  final DateTime createdAt;
  final DateTime updatedAt;

  Message({
    required this.id,
    required this.text,
    required this.ownerId,
    this.audienceLabel,
    required this.createdAt,
    required this.updatedAt,
  });

  Message copyWith({String? text, String? audienceLabel, DateTime? updatedAt}) {
    return Message(
      id: id,
      text: text ?? this.text,
      ownerId: ownerId,
      audienceLabel: audienceLabel ?? this.audienceLabel,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'ownerId': ownerId,
      'audienceLabel': audienceLabel,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      id: map['id'],
      text: map['text'],
      ownerId: map['ownerId'],
      audienceLabel: map['audienceLabel'],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }
}
