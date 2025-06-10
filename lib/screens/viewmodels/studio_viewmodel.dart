import 'package:flutter/foundation.dart';
import '../../models/studio_model.dart';
import '../../services/database_service.dart';

class StudioViewModel extends ChangeNotifier {
  final DatabaseService _databaseService;
  List<StudioModel> _studios = [];
  bool _isLoading = false;
  String? _error;

  StudioViewModel(this._databaseService);

  List<StudioModel> get studios => _studios;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchStudios() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final studios = await _databaseService.getStudios();
      _studios = studios;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> searchStudios(String query) async {
    if (query.isEmpty) {
      await fetchStudios();
      return;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final studios = await _databaseService.searchStudios(query);
      _studios = studios;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleFavorite(String studioId) async {
    try {
      final studio = _studios.firstWhere((s) => s.id == studioId);
      final updatedStudio = studio.copyWith(isFavorite: !studio.isFavorite);
      await _databaseService.updateStudio(updatedStudio);
      
      final index = _studios.indexWhere((s) => s.id == studioId);
      if (index != -1) {
        _studios[index] = updatedStudio;
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
} 