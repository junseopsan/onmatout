import 'package:flutter/foundation.dart';
import '../models/journal_model.dart';
import '../services/database_service.dart';

class StatsViewModel extends ChangeNotifier {
  final DatabaseService _databaseService;

  StatsViewModel(this._databaseService);

  bool _isLoading = false;
  String _error = '';
  List<double> _practiceTimeData = [];
  Map<String, int> _practicedAsanasData = {};
  int _totalPracticeDays = 0;
  int _totalPracticeTime = 0;

  bool get isLoading => _isLoading;
  String get error => _error;
  List<double> get practiceTimeData => _practiceTimeData;
  Map<String, int> get practicedAsanasData => _practicedAsanasData;
  int get totalPracticeDays => _totalPracticeDays;
  int get totalPracticeTime => _totalPracticeTime;

  Future<void> fetchStats() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final journals = await _databaseService.fetchAllJournals();

      // 수련 시간 데이터
      _practiceTimeData = List.generate(7, (index) {
        final date = DateTime.now().subtract(Duration(days: 6 - index));
        final journal = journals.firstWhere(
          (j) => j.createdAt.year == date.year &&
              j.createdAt.month == date.month &&
              j.createdAt.day == date.day,
          orElse: () => JournalModel(
            id: '',
            title: '',
            content: '',
            practicedAsanas: [],
            createdAt: date,
          ),
        );
        return journal.practicedAsanas.fold<double>(
          0,
          (sum, asana) => sum + asana.duration,
        );
      });

      // 수련한 아사나 데이터
      _practicedAsanasData = {};
      for (final journal in journals) {
        for (final asana in journal.practicedAsanas) {
          _practicedAsanasData[asana.name] =
              (_practicedAsanasData[asana.name] ?? 0) + 1;
        }
      }

      // 총 수련 일수
      _totalPracticeDays = journals.length;

      // 총 수련 시간
      _totalPracticeTime = journals.fold<int>(
        0,
        (sum, journal) =>
            sum +
            journal.practicedAsanas.fold<int>(
              0,
              (sum, asana) => sum + asana.duration,
            ),
      );
    } catch (e) {
      _error = '통계를 불러오는데 실패했습니다.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
} 