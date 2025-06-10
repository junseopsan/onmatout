import 'package:flutter/material.dart';
import '../models/record_model.dart';
import '../services/database_service.dart';

class RecordViewModel extends ChangeNotifier {
  final DatabaseService _databaseService;
  List<RecordModel> _records = [];
  bool _isLoading = false;
  String? _errorMessage;

  RecordViewModel(this._databaseService);

  List<RecordModel> get records => _records;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchRecords() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _records = await _databaseService.getRecords();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addRecord(RecordModel record) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await _databaseService.insertRecord(record);
      await fetchRecords();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateRecord(RecordModel record) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await _databaseService.updateRecord(record);
      await fetchRecords();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteRecord(int recordId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await _databaseService.deleteRecord(recordId);
      await fetchRecords();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
} 