import 'package:flutter/foundation.dart';
import '../../models/asana_model.dart';
import '../../models/record_model.dart';
import '../../services/database_service.dart';

class RecordViewModel extends ChangeNotifier {
  final DatabaseService _databaseService;
  List<AsanaModel> _selectedAsanas = [];
  DateTime _practiceDate = DateTime.now();
  int _practiceDuration = 0;
  String _memo = '';
  List<RecordModel> _records = [];
  bool _isLoading = false;
  String? _error;

  RecordViewModel(this._databaseService);

  List<AsanaModel> get selectedAsanas => _selectedAsanas;
  DateTime get practiceDate => _practiceDate;
  int get practiceDuration => _practiceDuration;
  String get memo => _memo;
  List<RecordModel> get records => _records;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void addAsana(AsanaModel asana) {
    _selectedAsanas.add(asana);
    notifyListeners();
  }

  void removeAsana(AsanaModel asana) {
    _selectedAsanas.remove(asana);
    notifyListeners();
  }

  void setPracticeDate(DateTime date) {
    _practiceDate = date;
    notifyListeners();
  }

  void setPracticeDuration(int minutes) {
    _practiceDuration = minutes;
    notifyListeners();
  }

  void setMemo(String text) {
    _memo = text;
    notifyListeners();
  }

  void clear() {
    _selectedAsanas = [];
    _practiceDate = DateTime.now();
    _practiceDuration = 0;
    _memo = '';
    notifyListeners();
  }

  Future<void> saveRecord() async {
    // TODO: 수련 기록을 저장하는 로직 구현
    // 1. 선택된 아사나 목록
    // 2. 수련 날짜
    // 3. 수련 시간
    // 4. 메모
    // 5. 사용자 ID
    clear();
  }

  Future<void> fetchRecords() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final records = await _databaseService.getRecords();
      _records = records;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addRecord(RecordModel record) async {
    try {
      await _databaseService.insertRecord(record);
      await fetchRecords();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> updateRecord(RecordModel record) async {
    try {
      await _databaseService.updateRecord(record);
      await fetchRecords();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> deleteRecord(int id) async {
    try {
      await _databaseService.deleteRecord(id);
      await fetchRecords();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
} 