import 'package:flutter/foundation.dart';
import 'asana_model.dart';

@immutable
class RoutineModel {
  final String id;
  final String userId;
  final String name;
  final String description;
  final List<RoutineStep> steps;
  final bool isDefault;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const RoutineModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.description,
    required this.steps,
    this.isDefault = false,
    required this.createdAt,
    this.updatedAt,
  });

  RoutineModel copyWith({
    String? id,
    String? userId,
    String? name,
    String? description,
    List<RoutineStep>? steps,
    bool? isDefault,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return RoutineModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      description: description ?? this.description,
      steps: steps ?? this.steps,
      isDefault: isDefault ?? this.isDefault,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'description': description,
      'is_default': isDefault,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  factory RoutineModel.fromJson(Map<String, dynamic> json) {
    return RoutineModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      steps: (json['steps'] as List)
          .map((e) => RoutineStep.fromJson(e))
          .toList(),
      isDefault: json['is_default'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RoutineModel &&
        other.id == id &&
        other.userId == userId &&
        other.name == name &&
        other.description == description &&
        listEquals(other.steps, steps) &&
        other.isDefault == isDefault &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      userId,
      name,
      description,
      steps,
      isDefault,
      createdAt,
      updatedAt,
    );
  }
}

@immutable
class RoutineStep {
  final String id;
  final String asanaId;
  final String asanaName;
  final String asanaImageUrl;
  final int duration; // 초 단위
  final String? notes;

  const RoutineStep({
    required this.id,
    required this.asanaId,
    required this.asanaName,
    required this.asanaImageUrl,
    required this.duration,
    this.notes,
  });

  RoutineStep copyWith({
    String? id,
    String? asanaId,
    String? asanaName,
    String? asanaImageUrl,
    int? duration,
    String? notes,
  }) {
    return RoutineStep(
      id: id ?? this.id,
      asanaId: asanaId ?? this.asanaId,
      asanaName: asanaName ?? this.asanaName,
      asanaImageUrl: asanaImageUrl ?? this.asanaImageUrl,
      duration: duration ?? this.duration,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'asana_id': asanaId,
      'asana_name': asanaName,
      'asana_image_url': asanaImageUrl,
      'duration': duration,
      'notes': notes,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RoutineStep &&
        other.id == id &&
        other.asanaId == asanaId &&
        other.asanaName == asanaName &&
        other.asanaImageUrl == asanaImageUrl &&
        other.duration == duration &&
        other.notes == notes;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      asanaId,
      asanaName,
      asanaImageUrl,
      duration,
      notes,
    );
  }

  factory RoutineStep.fromJson(Map<String, dynamic> json) {
    return RoutineStep(
      id: json['id'] as String,
      asanaId: json['asana_id'] as String,
      asanaName: json['asana_name'] as String,
      asanaImageUrl: json['asana_image_url'] as String,
      duration: json['duration'] as int,
      notes: json['notes'] as String?,
    );
  }
} 