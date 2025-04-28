class StatsModel {
  final String userId;
  final int totalPracticeDays;
  final int consecutiveDays;
  final int totalDuration;
  final Map<String, int> asanaCounts;
  final Map<String, int> moodCounts;
  final List<DailyStats> dailyStats;
  final DateTime lastUpdated;

  StatsModel({
    required this.userId,
    required this.totalPracticeDays,
    required this.consecutiveDays,
    required this.totalDuration,
    required this.asanaCounts,
    required this.moodCounts,
    required this.dailyStats,
    required this.lastUpdated,
  });

  factory StatsModel.fromJson(Map<String, dynamic> json) {
    return StatsModel(
      userId: json['user_id'] as String,
      totalPracticeDays: json['total_practice_days'] as int,
      consecutiveDays: json['consecutive_days'] as int,
      totalDuration: json['total_duration'] as int,
      asanaCounts: Map<String, int>.from(json['asana_counts'] ?? {}),
      moodCounts: Map<String, int>.from(json['mood_counts'] ?? {}),
      dailyStats: (json['daily_stats'] as List)
          .map((e) => DailyStats.fromJson(e as Map<String, dynamic>))
          .toList(),
      lastUpdated: DateTime.parse(json['last_updated'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'total_practice_days': totalPracticeDays,
      'consecutive_days': consecutiveDays,
      'total_duration': totalDuration,
      'asana_counts': asanaCounts,
      'mood_counts': moodCounts,
      'daily_stats': dailyStats.map((e) => e.toJson()).toList(),
      'last_updated': lastUpdated.toIso8601String(),
    };
  }

  StatsModel copyWith({
    String? userId,
    int? totalPracticeDays,
    int? consecutiveDays,
    int? totalDuration,
    Map<String, int>? asanaCounts,
    Map<String, int>? moodCounts,
    List<DailyStats>? dailyStats,
    DateTime? lastUpdated,
  }) {
    return StatsModel(
      userId: userId ?? this.userId,
      totalPracticeDays: totalPracticeDays ?? this.totalPracticeDays,
      consecutiveDays: consecutiveDays ?? this.consecutiveDays,
      totalDuration: totalDuration ?? this.totalDuration,
      asanaCounts: asanaCounts ?? this.asanaCounts,
      moodCounts: moodCounts ?? this.moodCounts,
      dailyStats: dailyStats ?? this.dailyStats,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}

class DailyStats {
  final DateTime date;
  final int duration;
  final int asanaCount;
  final String? mood;
  final List<String> asanaIds;

  DailyStats({
    required this.date,
    required this.duration,
    required this.asanaCount,
    this.mood,
    required this.asanaIds,
  });

  factory DailyStats.fromJson(Map<String, dynamic> json) {
    return DailyStats(
      date: DateTime.parse(json['date'] as String),
      duration: json['duration'] as int,
      asanaCount: json['asana_count'] as int,
      mood: json['mood'] as String?,
      asanaIds: List<String>.from(json['asana_ids'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'duration': duration,
      'asana_count': asanaCount,
      'mood': mood,
      'asana_ids': asanaIds,
    };
  }

  DailyStats copyWith({
    DateTime? date,
    int? duration,
    int? asanaCount,
    String? mood,
    List<String>? asanaIds,
  }) {
    return DailyStats(
      date: date ?? this.date,
      duration: duration ?? this.duration,
      asanaCount: asanaCount ?? this.asanaCount,
      mood: mood ?? this.mood,
      asanaIds: asanaIds ?? this.asanaIds,
    );
  }
} 