import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/asana_model.dart';
import '../models/record_model.dart';
import '../models/studio_model.dart';

class DatabaseService {
  final SupabaseClient _supabase;

  DatabaseService(this._supabase);

  Future<List<JournalModel>> fetchAllJournals() async {
    final response = await _supabase
        .from('journals')
        .select('*, asanas:journal_asanas(*)')
        .order('date', ascending: false);

    return (response as List<dynamic>)
        .map((json) => JournalModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<JournalModel?> fetchJournalById(String id) async {
    final response = await _supabase
        .from('journals')
        .select('*, asanas:journal_asanas(*)')
        .eq('id', id)
        .single();

    if (response == null) return null;
    return JournalModel.fromJson(response as Map<String, dynamic>);
  }

  Future<void> addJournal(JournalModel journal) async {
    final journalData = journal.toJson();
    final asanas = journalData.remove('asanas') as List<dynamic>?;

    final response = await _supabase
        .from('journals')
        .insert(journalData)
        .select()
        .single();

    if (asanas != null) {
      for (final asana in asanas) {
        await _supabase.from('journal_asanas').insert({
          'journal_id': response['id'],
          'asana_id': asana['id'],
        });
      }
    }
  }

  Future<void> updateJournal(JournalModel journal) async {
    final journalData = journal.toJson();
    final asanas = journalData.remove('asanas') as List<dynamic>?;

    await _supabase
        .from('journals')
        .update(journalData)
        .eq('id', journal.id);

    if (asanas != null) {
      await _supabase
          .from('journal_asanas')
          .delete()
          .eq('journal_id', journal.id);

      for (final asana in asanas) {
        await _supabase.from('journal_asanas').insert({
          'journal_id': journal.id,
          'asana_id': asana['id'],
        });
      }
    }
  }

  Future<void> deleteJournal(String journalId) async {
    await _supabase
        .from('journal_asanas')
        .delete()
        .eq('journal_id', journalId);

    await _supabase
        .from('journals')
        .delete()
        .eq('id', journalId);
  }

  Future<List<AsanaModel>> fetchAllAsanas() async {
    final response = await _supabase
        .from('asanas')
        .select()
        .order('name', ascending: true);

    return (response as List<dynamic>)
        .map((json) => AsanaModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<AsanaModel?> fetchAsanaById(String id) async {
    final response = await _supabase
        .from('asanas')
        .select()
        .eq('id', id)
        .single();

    if (response == null) return null;
    return AsanaModel.fromJson(response as Map<String, dynamic>);
  }

  Future<void> toggleFavorite(String asanaId) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return;

    final response = await _supabase
        .from('user_favorites')
        .select()
        .eq('user_id', userId)
        .eq('asana_id', asanaId)
        .maybeSingle();

    if (response == null) {
      await _supabase.from('user_favorites').insert({
        'user_id': userId,
        'asana_id': asanaId,
      });
    } else {
      await _supabase
          .from('user_favorites')
          .delete()
          .eq('user_id', userId)
          .eq('asana_id', asanaId);
    }
  }

  Future<List<AsanaModel>> fetchFavoriteAsanas() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return [];

    final response = await _supabase
        .from('user_favorites')
        .select('asanas(*)')
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return (response as List<dynamic>)
        .map((json) => AsanaModel.fromJson((json['asanas'] as Map<String, dynamic>)))
        .toList();
  }

  Future<List<RoutineModel>> fetchAllRoutines() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return [];

    final response = await _supabase
        .from('routines')
        .select('*, steps:routine_steps(*)')
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return (response as List<dynamic>)
        .map((json) => RoutineModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<void> addRoutine(RoutineModel routine) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return;

    final routineData = routine.toJson();
    routineData['user_id'] = userId;

    final response = await _supabase
        .from('routines')
        .insert(routineData)
        .select()
        .single();

    for (final step in routine.steps) {
      await _supabase.from('routine_steps').insert({
        'routine_id': response['id'],
        'asana_id': step.asanaId,
        'asana_name': step.asanaName,
        'asana_image_url': step.asanaImageUrl,
        'duration': step.duration,
        'notes': step.notes,
      });
    }
  }

  Future<void> updateRoutine(RoutineModel routine) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return;

    final routineData = routine.toJson();
    routineData['user_id'] = userId;

    await _supabase
        .from('routines')
        .update(routineData)
        .eq('id', routine.id)
        .eq('user_id', userId);

    await _supabase
        .from('routine_steps')
        .delete()
        .eq('routine_id', routine.id);

    for (final step in routine.steps) {
      await _supabase.from('routine_steps').insert({
        'routine_id': routine.id,
        'asana_id': step.asanaId,
        'asana_name': step.asanaName,
        'asana_image_url': step.asanaImageUrl,
        'duration': step.duration,
        'notes': step.notes,
      });
    }
  }

  Future<void> deleteRoutine(String routineId) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return;

    await _supabase
        .from('routine_steps')
        .delete()
        .eq('routine_id', routineId);

    await _supabase
        .from('routines')
        .delete()
        .eq('id', routineId)
        .eq('user_id', userId);
  }

  Future<RoutineModel?> fetchRoutineById(String id) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return null;

    final response = await _supabase
        .from('routines')
        .select('*, steps:routine_steps(*)')
        .eq('id', id)
        .eq('user_id', userId)
        .single();

    if (response == null) return null;
    return RoutineModel.fromJson(response as Map<String, dynamic>);
  }
} 