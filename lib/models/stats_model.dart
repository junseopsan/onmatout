import 'package:meta/meta.dart';

@immutable
class StatsModel {
  final int totalCount; // 누적 수련 횟수
  final int streakCount; // 연속 수련 일수
  final Map<String, int> emotionStats; // 감정별 횟수
  final Map<String, int> energyStats; // 에너지별 횟수

  const StatsModel({
    required this.totalCount,
    required this.streakCount,
    required this.emotionStats,
    required this.energyStats,
  });

  factory StatsModel.fromJson(Map<String, dynamic> json) {
    return StatsModel(
      totalCount: json['total_count'] as int? ?? 0,
      streakCount: json['streak_count'] as int? ?? 0,
      emotionStats: Map<String, int>.from(json['emotion_stats'] ?? {}),
      energyStats: Map<String, int>.from(json['energy_stats'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_count': totalCount,
      'streak_count': streakCount,
      'emotion_stats': emotionStats,
      'energy_stats': energyStats,
    };
  }
} 