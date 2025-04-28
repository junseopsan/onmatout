class UserModel {
  final String id;
  final String email;
  final String name;
  final String? profileImageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int consecutiveDays;
  final int totalPracticeDays;
  final List<String> favoriteAsanas;
  final Map<String, int> badges;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    this.profileImageUrl,
    required this.createdAt,
    required this.updatedAt,
    this.consecutiveDays = 0,
    this.totalPracticeDays = 0,
    this.favoriteAsanas = const [],
    this.badges = const {},
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      profileImageUrl: json['profile_image_url'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      consecutiveDays: json['consecutive_days'] as int? ?? 0,
      totalPracticeDays: json['total_practice_days'] as int? ?? 0,
      favoriteAsanas: List<String>.from(json['favorite_asanas'] ?? []),
      badges: Map<String, int>.from(json['badges'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'profile_image_url': profileImageUrl,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'consecutive_days': consecutiveDays,
      'total_practice_days': totalPracticeDays,
      'favorite_asanas': favoriteAsanas,
      'badges': badges,
    };
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? profileImageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? consecutiveDays,
    int? totalPracticeDays,
    List<String>? favoriteAsanas,
    Map<String, int>? badges,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      consecutiveDays: consecutiveDays ?? this.consecutiveDays,
      totalPracticeDays: totalPracticeDays ?? this.totalPracticeDays,
      favoriteAsanas: favoriteAsanas ?? this.favoriteAsanas,
      badges: badges ?? this.badges,
    );
  }
} 