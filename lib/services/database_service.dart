import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/studio_model.dart';
import '../models/asana_model.dart';
import '../models/record_model.dart';
import '../models/stats_model.dart';

class DatabaseService {
  final SupabaseClient _supabase;

  DatabaseService(this._supabase);

  // Supabase 관련 메서드
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

  Future<void> deleteAsana(String id) async {
    await _supabase
        .from('asanas')
        .delete()
        .eq('id', id);
  }

  Future<void> deleteUserData(String userId) async {
    await _supabase
        .from('asanas')
        .delete()
        .eq('user_id', userId);
  }

  // Studio 관련 메서드
  Future<List<StudioModel>> getStudios() async {
    final response = await _supabase
        .from('studios')
        .select('*, studio_images(*), studio_hours(*)')
        .order('name');

    return (response as List<dynamic>)
        .map((json) => StudioModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<List<StudioModel>> searchStudios(String query) async {
    final response = await _supabase
        .from('studios')
        .select('*, studio_images(*), studio_hours(*)')
        .or('name.ilike.%$query%,address.ilike.%$query%')
        .order('name');

    return (response as List<dynamic>)
        .map((json) => StudioModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<void> insertStudio(StudioModel studio) async {
    await _supabase.from('studios').insert(studio.toJson());
  }

  Future<void> updateStudio(StudioModel studio) async {
    await _supabase
        .from('studios')
        .update(studio.toJson())
        .eq('id', studio.id);
  }

  Future<void> deleteStudio(int id) async {
    await _supabase
        .from('studios')
        .delete()
        .eq('id', id);
  }

  // Record 관련 메서드
  Future<List<RecordModel>> getRecords() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return [];

    final response = await _supabase
        .from('records')
        .select('*, record_asanas(*, asanas(*))')
        .eq('user_id', userId)
        .order('date', ascending: false);

    return (response as List<dynamic>)
        .map((json) => RecordModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<void> insertRecord(RecordModel record) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return;

    final recordData = {
      ...record.toJson(),
      'user_id': userId,
    };

    await _supabase.from('records').insert(recordData);
  }

  Future<void> updateRecord(RecordModel record) async {
    await _supabase
        .from('records')
        .update(record.toJson())
        .eq('id', record.id);
  }

  Future<void> deleteRecord(int id) async {
    await _supabase
        .from('records')
        .delete()
        .eq('id', id);
  }

  // Stats 관련 메서드
  Future<StatsModel> fetchStats() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) throw Exception('사용자가 로그인되어 있지 않습니다.');

    final response = await _supabase
        .from('users')
        .select('streak_count, total_practice_days')
        .eq('id', userId)
        .single();

    return StatsModel.fromJson(response as Map<String, dynamic>);
  }
}