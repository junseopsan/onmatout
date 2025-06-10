import 'package:flutter/foundation.dart';
import '../utils/proficiency_level.dart';

@immutable
class AsanaModel {
  final String id;
  final String sanskritNameKr;
  final String sanskritNameEn;
  final String level;
  final String effectPoint;
  final String effect;
  final String story;
  final String storyPoint;
  final String categoryNameEn;
  final String imageNumber;
  final String asanaMeaning;
  final bool isFavorite;

  const AsanaModel({
    required this.id,
    required this.sanskritNameKr,
    required this.sanskritNameEn,
    required this.level,
    required this.effectPoint,
    required this.effect,
    required this.story,
    required this.storyPoint,
    required this.categoryNameEn,
    required this.imageNumber,
    required this.asanaMeaning,
    this.isFavorite = false,
  });

  factory AsanaModel.fromJson(Map<String, dynamic> json) {
    return AsanaModel(
      id: json['id'] ?? '',
      sanskritNameKr: json['sanskrit_name_kr'] ?? '',
      sanskritNameEn: json['sanskrit_name_en'] ?? '',
      level: json['level'] ?? '',
      effectPoint: json['effect_point'] ?? '',
      effect: json['effect'] ?? '',
      story: json['story'] ?? '',
      storyPoint: json['story_point'] ?? '',
      categoryNameEn: json['category_name_en'] ?? '',
      imageNumber: json['image_number'] ?? '',
      asanaMeaning: json['asana_meaning'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sanskrit_name_kr': sanskritNameKr,
      'sanskrit_name_en': sanskritNameEn,
      'level': level,
      'effect_point': effectPoint,
      'effect': effect,
      'story': story,
      'story_point': storyPoint,
      'category_name_en': categoryNameEn,
      'image_number': imageNumber,
      'asana_meaning': asanaMeaning,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AsanaModel &&
        other.id == id &&
        other.sanskritNameKr == sanskritNameKr &&
        other.sanskritNameEn == sanskritNameEn &&
        other.level == level &&
        other.effectPoint == effectPoint &&
        other.effect == effect &&
        other.story == story &&
        other.storyPoint == storyPoint &&
        other.categoryNameEn == categoryNameEn &&
        other.imageNumber == imageNumber &&
        other.asanaMeaning == asanaMeaning &&
        other.isFavorite == isFavorite;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      sanskritNameKr,
      sanskritNameEn,
      level,
      effectPoint,
      effect,
      story,
      storyPoint,
      categoryNameEn,
      imageNumber,
      asanaMeaning,
      isFavorite,
    );
  }
} 