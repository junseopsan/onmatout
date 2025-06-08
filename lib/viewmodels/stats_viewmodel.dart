import 'package:flutter/material.dart';
import '../models/stats_model.dart';
import '../services/database_service.dart';

class StatsViewModel extends ChangeNotifier {
  final DatabaseService _databaseService;
  StatsModel? _stats;
  bool _isLoading = false;
  String? _errorMessage;

  StatsViewModel(this._databaseService);

  StatsModel? get stats => _stats;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchStats() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _stats = await _databaseService.fetchStats();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
} 