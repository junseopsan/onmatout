import 'package:flutter/foundation.dart';
import '../utils/proficiency_level.dart';
import 'package:meta/meta.dart';

@immutable
class AsanaModel {
  final String id;
  final String nameKo;
  final String nameEn;
  final String description;
  final String effect;
  final String imageUrl;
  final String category;
  final String difficulty;
  final bool isFavorite;

  const AsanaModel({
    required this.id,
    required this.nameKo,
    required this.nameEn,
    required this.description,
    required this.effect,
    required this.imageUrl,
    required this.category,
    required this.difficulty,
    this.isFavorite = false,
  });

  factory AsanaModel.fromJson(Map<String, dynamic> json) {
    return AsanaModel(
      id: json['id'] as String,
      nameKo: json['name_ko'] as String,
      nameEn: json['name_en'] as String,
      description: json['description'] as String,
      effect: json['effect'] as String,
      imageUrl: json['image_url'] as String,
      category: json['category'] as String,
      difficulty: json['difficulty'] as String,
      isFavorite: json['is_favorite'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name_ko': nameKo,
      'name_en': nameEn,
      'description': description,
      'effect': effect,
      'image_url': imageUrl,
      'category': category,
      'difficulty': difficulty,
      'is_favorite': isFavorite,
    };
  }

  AsanaModel copyWith({
    bool? isFavorite,
  }) {
    return AsanaModel(
      id: id,
      nameKo: nameKo,
      nameEn: nameEn,
      description: description,
      effect: effect,
      imageUrl: imageUrl,
      category: category,
      difficulty: difficulty,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AsanaModel &&
        other.id == id &&
        other.nameKo == nameKo &&
        other.nameEn == nameEn &&
        other.description == description &&
        other.effect == effect &&
        other.imageUrl == imageUrl &&
        other.category == category &&
        other.difficulty == difficulty &&
        other.isFavorite == isFavorite;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      nameKo,
      nameEn,
      description,
      effect,
      imageUrl,
      category,
      difficulty,
      isFavorite,
    );
  }
} 