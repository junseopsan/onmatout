import 'package:flutter/foundation.dart';
import 'asana_model.dart';

@immutable
class JournalModel {
  final String id;
  final String title;
  final String content;
  final List<AsanaModel> practicedAsanas;
  final DateTime createdAt;

  const JournalModel({
    required this.id,
    required this.title,
    required this.content,
    required this.practicedAsanas,
    required this.createdAt,
  });

  JournalModel copyWith({
    String? id,
    String? title,
    String? content,
    List<AsanaModel>? practicedAsanas,
    DateTime? createdAt,
  }) {
    return JournalModel(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      practicedAsanas: practicedAsanas ?? this.practicedAsanas,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'practiced_asanas': practicedAsanas.map((e) => e.toJson()).toList(),
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory JournalModel.fromJson(Map<String, dynamic> json) {
    return JournalModel(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      practicedAsanas: (json['practiced_asanas'] as List)
          .map((e) => AsanaModel.fromJson(e))
          .toList(),
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is JournalModel &&
        other.id == id &&
        other.title == title &&
        other.content == content &&
        listEquals(other.practicedAsanas, practicedAsanas) &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      title,
      content,
      practicedAsanas,
      createdAt,
    );
  }
} 