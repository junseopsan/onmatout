import 'package:flutter/foundation.dart';
import '../models/journal_model.dart';
import '../services/database_service.dart';

class JournalViewModel extends ChangeNotifier {
  final DatabaseService _databaseService;

  JournalViewModel(this._databaseService);

  bool _isLoading = false;
  String _error = '';
  List<JournalModel> _journals = [];

  bool get isLoading => _isLoading;
  String get error => _error;
  List<JournalModel> get journals => _journals;

  Future<void> fetchAllJournals() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      _journals = await _databaseService.fetchAllJournals();
    } catch (e) {
      _error = '일지를 불러오는데 실패했습니다.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<JournalModel?> getJournalById(String id) async {
    try {
      return await _databaseService.fetchJournalById(id);
    } catch (e) {
      _error = '일지를 불러오는데 실패했습니다.';
      notifyListeners();
      return null;
    }
  }

  Future<void> addJournal(JournalModel journal) async {
    try {
      await _databaseService.addJournal(journal);
      await fetchAllJournals();
    } catch (e) {
      _error = '일지를 저장하는데 실패했습니다.';
      notifyListeners();
    }
  }

  Future<void> updateJournal(JournalModel journal) async {
    try {
      await _databaseService.updateJournal(journal);
      await fetchAllJournals();
    } catch (e) {
      _error = '일지를 수정하는데 실패했습니다.';
      notifyListeners();
    }
  }

  Future<void> deleteJournal(String id) async {
    try {
      await _databaseService.deleteJournal(id);
      await fetchAllJournals();
    } catch (e) {
      _error = '일지를 삭제하는데 실패했습니다.';
      notifyListeners();
    }
  }
} 