import 'dart:convert';

// '\$createdAt': createdAt?.millisecondsSinceEpoch,
//       '\$id': id,
class Chat {
  final String userId;
  final String name;
  DateTime? createdAt;
  String? id;
  final String message;
  Chat({
    required this.userId,
    required this.name,
    this.createdAt,
    this.id,
    required this.message,
  });

  Chat copyWith({
    String? userId,
    String? name,
    DateTime? createdAt,
    String? id,
    String? message,
  }) {
    return Chat(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      id: id ?? this.id,
      message: message ?? this.message,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
      'message': message,
    };
  }

  factory Chat.fromMap(Map<String, dynamic> map) {
    return Chat(
      userId: map['userId'] ?? '',
      name: map['name'] ?? '',
      // createdAt: map['\$createdAt'] != null
      //     ? DateTime.fromMillisecondsSinceEpoch(map['\$createdAt'])
      //     : null,
      id: map['\$id'] ?? '',
      message: map['message'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Chat.fromJson(String source) => Chat.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Chat(userId: $userId, name: $name, createdAt: $createdAt, id: $id, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Chat &&
        other.userId == userId &&
        other.name == name &&
        other.createdAt == createdAt &&
        other.id == id &&
        other.message == message;
  }

  @override
  int get hashCode {
    return userId.hashCode ^
        name.hashCode ^
        createdAt.hashCode ^
        id.hashCode ^
        message.hashCode;
  }
}
