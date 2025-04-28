import 'package:flutter/foundation.dart';
import '../models/asana_model.dart';
import '../services/database_service.dart';

class AsanaViewModel extends ChangeNotifier {
  final DatabaseService _databaseService;
  List<AsanaModel> _asanas = [];
  List<AsanaModel> _filteredAsanas = [];
  String _searchQuery = '';
  String _selectedCategory = '';
  String _selectedDifficulty = '';
  bool _isLoading = false;
  String _error = '';

  AsanaViewModel(this._databaseService);

  List<AsanaModel> get asanas => _asanas;
  List<AsanaModel> get filteredAsanas => _filteredAsanas;
  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;
  String get selectedDifficulty => _selectedDifficulty;
  bool get isLoading => _isLoading;
  String get error => _error;

  Future<void> fetchAllAsanas() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      _asanas = await _databaseService.fetchAllAsanas();
      _filteredAsanas = _asanas;
    } catch (e) {
      _error = '아사나 목록을 불러오는데 실패했습니다.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<AsanaModel?> getAsanaById(String id) async {
    return await _databaseService.fetchAsanaById(id);
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  void setSelectedCategory(String category) {
    _selectedCategory = category;
    _applyFilters();
  }

  void setSelectedDifficulty(String difficulty) {
    _selectedDifficulty = difficulty;
    _applyFilters();
  }

  void _applyFilters() {
    _filteredAsanas = _asanas.where((asana) {
      final matchesSearch = asana.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          asana.sanskritName.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory = _selectedCategory.isEmpty || asana.category == _selectedCategory;
      final matchesDifficulty = _selectedDifficulty.isEmpty || asana.difficulty.toString() == _selectedDifficulty;
      return matchesSearch && matchesCategory && matchesDifficulty;
    }).toList();
    notifyListeners();
  }

  void resetFilters() {
    _searchQuery = '';
    _selectedCategory = '';
    _selectedDifficulty = '';
    _filteredAsanas = _asanas;
    notifyListeners();
  }

  Future<void> toggleFavorite(String asanaId) async {
    await _databaseService.toggleFavorite(asanaId);
    await fetchAllAsanas();
  }

  Future<List<AsanaModel>> fetchFavoriteAsanas() async {
    return await _databaseService.fetchFavoriteAsanas();
  }
} 