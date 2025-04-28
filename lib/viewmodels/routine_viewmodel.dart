import 'package:flutter/material.dart';
import '../models/routine_model.dart';
import '../services/database_service.dart';

class RoutineViewModel extends ChangeNotifier {
  final DatabaseService _databaseService;
  List<RoutineModel> _routines = [];
  bool _isLoading = false;
  String? _error;

  RoutineViewModel(this._databaseService);

  List<RoutineModel> get routines => _routines;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchAllRoutines() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _routines = await _databaseService.fetchAllRoutines();
    } catch (e) {
      _error = '루틴 목록을 불러오는 중 오류가 발생했습니다.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addRoutine(RoutineModel routine) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _databaseService.addRoutine(routine);
      await fetchAllRoutines();
    } catch (e) {
      _error = '루틴을 추가하는 중 오류가 발생했습니다.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateRoutine(RoutineModel routine) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _databaseService.updateRoutine(routine);
      await fetchAllRoutines();
    } catch (e) {
      _error = '루틴을 수정하는 중 오류가 발생했습니다.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteRoutine(String routineId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _databaseService.deleteRoutine(routineId);
      await fetchAllRoutines();
    } catch (e) {
      _error = '루틴을 삭제하는 중 오류가 발생했습니다.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<RoutineModel?> fetchRoutineById(String id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final routine = await _databaseService.fetchRoutineById(id);
      return routine;
    } catch (e) {
      _error = '루틴을 불러오는 중 오류가 발생했습니다.';
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addStep(String routineId, RoutineStep step) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final routine = await _databaseService.fetchRoutineById(routineId);
      if (routine == null) {
        _error = '루틴을 찾을 수 없습니다.';
        return;
      }

      final updatedRoutine = routine.copyWith(
        steps: [...routine.steps, step],
      );

      await _databaseService.updateRoutine(updatedRoutine);
      await fetchAllRoutines();
    } catch (e) {
      _error = '루틴에 단계를 추가하는 중 오류가 발생했습니다.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateStep(String routineId, RoutineStep step) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final routine = await _databaseService.fetchRoutineById(routineId);
      if (routine == null) {
        _error = '루틴을 찾을 수 없습니다.';
        return;
      }

      final updatedRoutine = routine.copyWith(
        steps: routine.steps.map((s) => s.id == step.id ? step : s).toList(),
      );

      await _databaseService.updateRoutine(updatedRoutine);
      await fetchAllRoutines();
    } catch (e) {
      _error = '루틴의 단계를 수정하는 중 오류가 발생했습니다.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> reorderSteps(String routineId, int oldIndex, int newIndex) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final routine = await _databaseService.fetchRoutineById(routineId);
      if (routine == null) {
        _error = '루틴을 찾을 수 없습니다.';
        return;
      }

      final steps = List<RoutineStep>.from(routine.steps);
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final step = steps.removeAt(oldIndex);
      steps.insert(newIndex, step);

      final updatedRoutine = routine.copyWith(steps: steps);

      await _databaseService.updateRoutine(updatedRoutine);
      await fetchAllRoutines();
    } catch (e) {
      _error = '루틴의 단계 순서를 변경하는 중 오류가 발생했습니다.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<RoutineModel> getDefaultRoutines() {
    return _routines.where((routine) => routine.isDefault).toList();
  }

  List<RoutineModel> getCustomRoutines() {
    return _routines.where((routine) => !routine.isDefault).toList();
  }

  int getStepCount(String routineId) {
    final routine = _routines.firstWhere((r) => r.id == routineId);
    return routine.steps.length;
  }

  int getTotalDuration(String routineId) {
    final routine = _routines.firstWhere((r) => r.id == routineId);
    return routine.steps.fold(0, (sum, step) => sum + step.duration);
  }

  RoutineModel? getDefaultRoutine() {
    try {
      return _routines.firstWhere((routine) => routine.isDefault);
    } catch (e) {
      return null;
    }
  }

  Future<void> setDefaultRoutine(String routineId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // 현재 기본 루틴을 찾아 isDefault를 false로 설정
      final currentDefault = _routines.where((r) => r.isDefault).toList();
      for (final routine in currentDefault) {
        final updatedRoutine = routine.copyWith(isDefault: false);
        await _databaseService.updateRoutine(updatedRoutine);
      }

      // 새로운 기본 루틴을 찾아 isDefault를 true로 설정
      final newDefault = _routines.firstWhere((r) => r.id == routineId);
      final updatedRoutine = newDefault.copyWith(isDefault: true);
      await _databaseService.updateRoutine(updatedRoutine);

      await fetchAllRoutines();
    } catch (e) {
      _error = '기본 루틴을 설정하는 중 오류가 발생했습니다.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<RoutineModel> searchRoutines(String query) {
    if (query.isEmpty) return _routines;
    
    final lowercaseQuery = query.toLowerCase();
    return _routines.where((routine) {
      return routine.name.toLowerCase().contains(lowercaseQuery) ||
             routine.description.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }

  Future<void> duplicateRoutine(String routineId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final routine = _routines.firstWhere((r) => r.id == routineId);
      final newRoutine = RoutineModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: routine.userId,
        name: '${routine.name} (복사본)',
        description: routine.description,
        steps: routine.steps,
        isDefault: false,
        createdAt: DateTime.now(),
      );

      await _databaseService.addRoutine(newRoutine);
      await fetchAllRoutines();
    } catch (e) {
      _error = '루틴을 복제하는 중 오류가 발생했습니다.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteStep(String routineId, String stepId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final routine = await _databaseService.fetchRoutineById(routineId);
      if (routine == null) {
        _error = '루틴을 찾을 수 없습니다.';
        return;
      }

      final updatedRoutine = routine.copyWith(
        steps: routine.steps.where((step) => step.id != stepId).toList(),
      );

      await _databaseService.updateRoutine(updatedRoutine);
      await fetchAllRoutines();
    } catch (e) {
      _error = '루틴의 단계를 삭제하는 중 오류가 발생했습니다.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  RoutineStep? getStepById(String routineId, String stepId) {
    try {
      final routine = _routines.firstWhere((r) => r.id == routineId);
      return routine.steps.firstWhere((step) => step.id == stepId);
    } catch (e) {
      return null;
    }
  }

  int? getStepIndex(String routineId, String stepId) {
    try {
      final routine = _routines.firstWhere((r) => r.id == routineId);
      return routine.steps.indexWhere((step) => step.id == stepId);
    } catch (e) {
      return null;
    }
  }

  int getStepCountByAsana(String routineId, String asanaId) {
    try {
      final routine = _routines.firstWhere((r) => r.id == routineId);
      return routine.steps.where((step) => step.asanaId == asanaId).length;
    } catch (e) {
      return 0;
    }
  }

  int getTotalDurationByAsana(String routineId, String asanaId) {
    try {
      final routine = _routines.firstWhere((r) => r.id == routineId);
      return routine.steps
          .where((step) => step.asanaId == asanaId)
          .fold(0, (sum, step) => sum + step.duration);
    } catch (e) {
      return 0;
    }
  }

  List<String> getAsanaIds(String routineId) {
    try {
      final routine = _routines.firstWhere((r) => r.id == routineId);
      return routine.steps.map((step) => step.asanaId).toList();
    } catch (e) {
      return [];
    }
  }

  List<String> getUniqueAsanaIds(String routineId) {
    try {
      final routine = _routines.firstWhere((r) => r.id == routineId);
      return routine.steps.map((step) => step.asanaId).toSet().toList();
    } catch (e) {
      return [];
    }
  }

  int getAsanaCount(String routineId) {
    try {
      final routine = _routines.firstWhere((r) => r.id == routineId);
      return routine.steps.map((step) => step.asanaId).toSet().length;
    } catch (e) {
      return 0;
    }
  }

  int getAsanaDuration(String routineId, String asanaId) {
    try {
      final routine = _routines.firstWhere((r) => r.id == routineId);
      return routine.steps
          .where((step) => step.asanaId == asanaId)
          .fold(0, (sum, step) => sum + step.duration);
    } catch (e) {
      return 0;
    }
  }

  List<RoutineStep> getAsanaSteps(String routineId, String asanaId) {
    try {
      final routine = _routines.firstWhere((r) => r.id == routineId);
      return routine.steps.where((step) => step.asanaId == asanaId).toList();
    } catch (e) {
      return [];
    }
  }

  int getAsanaStepCount(String routineId, String asanaId) {
    try {
      final routine = _routines.firstWhere((r) => r.id == routineId);
      return routine.steps.where((step) => step.asanaId == asanaId).length;
    } catch (e) {
      return 0;
    }
  }

  int? getAsanaStepIndex(String routineId, String stepId) {
    try {
      final routine = _routines.firstWhere((r) => r.id == routineId);
      return routine.steps.indexWhere((step) => step.id == stepId);
    } catch (e) {
      return null;
    }
  }

  int getAsanaStepDuration(String routineId, String asanaId, String stepId) {
    try {
      final routine = _routines.firstWhere((r) => r.id == routineId);
      final step = routine.steps.firstWhere((step) => step.id == stepId && step.asanaId == asanaId);
      return step.duration;
    } catch (e) {
      return 0;
    }
  }

  String? getAsanaStepNotes(String routineId, String asanaId, String stepId) {
    try {
      final routine = _routines.firstWhere((r) => r.id == routineId);
      final step = routine.steps.firstWhere((step) => step.id == stepId && step.asanaId == asanaId);
      return step.notes;
    } catch (e) {
      return null;
    }
  }

  String getAsanaStepImageUrl(String routineId, String asanaId, String stepId) {
    try {
      final routine = _routines.firstWhere((r) => r.id == routineId);
      final step = routine.steps.firstWhere((step) => step.id == stepId && step.asanaId == asanaId);
      return step.asanaImageUrl;
    } catch (e) {
      return '';
    }
  }

  String getAsanaStepName(String routineId, String asanaId, String stepId) {
    try {
      final routine = _routines.firstWhere((r) => r.id == routineId);
      final step = routine.steps.firstWhere((step) => step.id == stepId && step.asanaId == asanaId);
      return step.asanaName;
    } catch (e) {
      return '';
    }
  }

  RoutineStep? getAsanaStepById(String routineId, String asanaId, String stepId) {
    try {
      final routine = _routines.firstWhere((r) => r.id == routineId);
      return routine.steps.firstWhere((step) => step.id == stepId && step.asanaId == asanaId);
    } catch (e) {
      return null;
    }
  }

  RoutineStep? getAsanaStepByIndex(String routineId, String asanaId, int index) {
    try {
      final routine = _routines.firstWhere((r) => r.id == routineId);
      final asanaSteps = routine.steps.where((step) => step.asanaId == asanaId).toList();
      return asanaSteps[index];
    } catch (e) {
      return null;
    }
  }

  int getAsanaStepCountByIndex(String routineId, String asanaId) {
    try {
      final routine = _routines.firstWhere((r) => r.id == routineId);
      return routine.steps.where((step) => step.asanaId == asanaId).length;
    } catch (e) {
      return 0;
    }
  }

  int getAsanaStepDurationByIndex(String routineId, String asanaId, int index) {
    try {
      final routine = _routines.firstWhere((r) => r.id == routineId);
      final asanaSteps = routine.steps.where((step) => step.asanaId == asanaId).toList();
      return asanaSteps[index].duration;
    } catch (e) {
      return 0;
    }
  }

  String? getAsanaStepNotesByIndex(String routineId, String asanaId, int index) {
    try {
      final routine = _routines.firstWhere((r) => r.id == routineId);
      final asanaSteps = routine.steps.where((step) => step.asanaId == asanaId).toList();
      return asanaSteps[index].notes;
    } catch (e) {
      return null;
    }
  }

  String getAsanaStepImageUrlByIndex(String routineId, String asanaId, int index) {
    try {
      final routine = _routines.firstWhere((r) => r.id == routineId);
      final asanaSteps = routine.steps.where((step) => step.asanaId == asanaId).toList();
      return asanaSteps[index].asanaImageUrl;
    } catch (e) {
      return '';
    }
  }

  String getAsanaStepNameByIndex(String routineId, String asanaId, int index) {
    try {
      final routine = _routines.firstWhere((r) => r.id == routineId);
      final asanaSteps = routine.steps.where((step) => step.asanaId == asanaId).toList();
      return asanaSteps[index].asanaName;
    } catch (e) {
      return '';
    }
  }

  RoutineStep? getAsanaStepByIdByIndex(String routineId, String asanaId, int index) {
    try {
      final routine = _routines.firstWhere((r) => r.id == routineId);
      final asanaSteps = routine.steps.where((step) => step.asanaId == asanaId).toList();
      return asanaSteps[index];
    } catch (e) {
      return null;
    }
  }
} 