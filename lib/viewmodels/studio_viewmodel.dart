import 'package:flutter/material.dart';
import '../models/studio_model.dart';
import '../services/database_service.dart';

class StudioViewModel extends ChangeNotifier {
  final DatabaseService _databaseService;
  List<StudioModel> _studios = [];
  List<StudioModel> _filteredStudios = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _searchQuery = '';

  StudioViewModel(this._databaseService);

  List<StudioModel> get studios => _filteredStudios;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;

  Future<void> fetchStudios() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _studios = await _databaseService.getStudios();
      _filteredStudios = _studios;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void searchStudios(String query) {
    _searchQuery = query;
    _filteredStudios = _studios.where((studio) =>
      studio.name.contains(query) ||
      studio.address.contains(query)
    ).toList();
    notifyListeners();
  }

  StudioModel? getStudioById(String id) {
    try {
      return _studios.firstWhere((s) => s.id.toString() == id);
    } catch (e) {
      return null;
    }
  }
} 