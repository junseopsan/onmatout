import 'package:meta/meta.dart';
import 'asana_model.dart';

@immutable
class RecordModel {
  final String id;
  final String userId;
  final DateTime date;
  final List<AsanaModel> asanas;
  final String emotion;
  final String energy;
  final String focus;
  final String memo;
  final DateTime createdAt;
  final DateTime updatedAt;

  const RecordModel({
    required this.id,
    required this.userId,
    required this.date,
    required this.asanas,
    required this.emotion,
    required this.energy,
    required this.focus,
    required this.memo,
    required this.createdAt,
    required this.updatedAt,
  });

  factory RecordModel.fromJson(Map<String, dynamic> json) {
    return RecordModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      date: DateTime.parse(json['date'] as String),
      asanas: (json['asanas'] as List<dynamic>? ?? [])
          .map((a) => AsanaModel.fromJson(a as Map<String, dynamic>))
          .toList(),
      emotion: json['emotion'] as String? ?? '',
      energy: json['energy'] as String? ?? '',
      focus: json['focus'] as String? ?? '',
      memo: json['memo'] as String? ?? '',
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'date': date.toIso8601String(),
      'asanas': asanas.map((a) => a.toJson()).toList(),
      'emotion': emotion,
      'energy': energy,
      'focus': focus,
      'memo': memo,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
} 