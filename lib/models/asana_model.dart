import 'package:flutter/foundation.dart';
import '../utils/proficiency_level.dart';

@immutable
class AsanaModel {
  final String id;
  final String name;
  final String sanskritName;
  final String sanskritNameKr;
  final String imageUrl;
  final String description;
  final ProficiencyLevel difficulty;
  final String category;
  final String effects;
  final String story;
  final int duration;
  final bool isFavorite;
  final String imageNumber;

  const AsanaModel({
    required this.id,
    required this.name,
    required this.sanskritName,
    required this.sanskritNameKr,
    required this.imageUrl,
    required this.description,
    required this.difficulty,
    required this.category,
    required this.effects,
    required this.story,
    required this.duration,
    this.isFavorite = false,
    required this.imageNumber,
  });

  AsanaModel copyWith({
    String? id,
    String? name,
    String? sanskritName,
    String? sanskritNameKr,
    String? imageUrl,
    String? description,
    ProficiencyLevel? difficulty,
    String? category,
    String? effects,
    String? story,
    int? duration,
    bool? isFavorite,
    String? imageNumber,
  }) {
    return AsanaModel(
      id: id ?? this.id,
      name: name ?? this.name,
      sanskritName: sanskritName ?? this.sanskritName,
      sanskritNameKr: sanskritNameKr ?? this.sanskritNameKr,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
      difficulty: difficulty ?? this.difficulty,
      category: category ?? this.category,
      effects: effects ?? this.effects,
      story: story ?? this.story,
      duration: duration ?? this.duration,
      isFavorite: isFavorite ?? this.isFavorite,
      imageNumber: imageNumber ?? this.imageNumber,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'sanskritName': sanskritName,
      'sanskritNameKr': sanskritNameKr,
      'imageUrl': imageUrl,
      'description': description,
      'difficulty': difficulty.toString(),
      'category': category,
      'effects': effects,
      'story': story,
      'duration': duration,
      'isFavorite': isFavorite,
      'image_number': imageNumber,
    };
  }

  factory AsanaModel.fromJson(Map<String, dynamic> json) {
    return AsanaModel(
      id: json['id'] as String,
      name: json['name'] as String,
      sanskritName: json['sanskritName'] as String,
      sanskritNameKr: json['sanskritNameKr'] as String,
      imageUrl: json['imageUrl'] as String,
      description: json['description'] as String,
      difficulty: ProficiencyLevel.values.firstWhere(
        (e) => e.toString() == json['difficulty'],
      ),
      category: json['category'] as String,
      effects: json['effects'] as String,
      story: json['story'] as String,
      duration: json['duration'] as int,
      isFavorite: json['isFavorite'] as bool? ?? false,
      imageNumber: json['image_number'] as String? ?? '001',
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AsanaModel &&
        other.id == id &&
        other.name == name &&
        other.sanskritName == sanskritName &&
        other.sanskritNameKr == sanskritNameKr &&
        other.imageUrl == imageUrl &&
        other.description == description &&
        other.difficulty == difficulty &&
        other.category == category &&
        other.effects == effects &&
        other.story == story &&
        other.duration == duration &&
        other.isFavorite == isFavorite &&
        other.imageNumber == imageNumber;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      name,
      sanskritName,
      sanskritNameKr,
      imageUrl,
      description,
      difficulty,
      category,
      effects,
      story,
      duration,
      isFavorite,
      imageNumber,
    );
  }
} 