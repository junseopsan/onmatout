import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:onmatout/services/database_service.dart';
import 'package:onmatout/models/asana_model.dart';
import 'package:onmatout/models/journal_model.dart';
import 'package:onmatout/models/routine_model.dart';
import 'database_service_test.mocks.dart';

@GenerateMocks([SupabaseClient])
void main() {
  late DatabaseService databaseService;
  late MockSupabaseClient mockSupabaseClient;

  setUp(() {
    mockSupabaseClient = MockSupabaseClient();
    databaseService = DatabaseService(mockSupabaseClient);
  });

  group('DatabaseService - Asana', () {
    test('fetchAllAsanas는 모든 아사나를 가져옵니다', () async {
      final mockAsanas = [
        {
          'id': '1',
          'sanskrit_name_kr': '아사나1',
          'sanskrit_name_en': 'Asana1',
          'asana_type': 'standing',
          'level': 1,
          'effect_point': '효과1',
          'effect': '효과설명1',
          'story': '스토리1',
          'story_point': '스토리포인트1',
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        },
        {
          'id': '2',
          'sanskrit_name_kr': '아사나2',
          'sanskrit_name_en': 'Asana2',
          'asana_type': 'sitting',
          'level': 2,
          'effect_point': '효과2',
          'effect': '효과설명2',
          'story': '스토리2',
          'story_point': '스토리포인트2',
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        },
      ];

      when(mockSupabaseClient.from('asanas').select().order('name', ascending: true))
          .thenAnswer((_) async => mockAsanas as dynamic);

      final result = await databaseService.fetchAllAsanas();

      expect(result.length, 2);
      expect(result[0].id, '1');
      expect(result[1].id, '2');
    });

    test('fetchAsanaById는 특정 ID의 아사나를 가져옵니다', () async {
      final mockAsana = {
        'id': '1',
        'sanskrit_name_kr': '아사나1',
        'sanskrit_name_en': 'Asana1',
        'asana_type': 'standing',
        'level': 1,
        'effect_point': '효과1',
        'effect': '효과설명1',
        'story': '스토리1',
        'story_point': '스토리포인트1',
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      };

      when(mockSupabaseClient.from('asanas').select().eq('id', '1').single())
          .thenAnswer((_) async => mockAsana as dynamic);

      final result = await databaseService.fetchAsanaById('1');

      expect(result?.id, '1');
      expect(result?.sanskritNameKr, '아사나1');
    });

    test('toggleFavorite는 즐겨찾기를 토글합니다', () async {
      when(mockSupabaseClient.auth.currentUser).thenReturn(
        User(
          id: 'user1',
          appMetadata: {},
          userMetadata: {},
          aud: '',
          createdAt: DateTime.now().toIso8601String(),
        ),
      );

      when(mockSupabaseClient.from('user_favorites').select().eq('user_id', 'user1').eq('asana_id', '1').single())
          .thenAnswer((_) async => null as dynamic);

      when(mockSupabaseClient.from('user_favorites').insert({
        'user_id': 'user1',
        'asana_id': '1',
      })).thenAnswer((_) async => {} as dynamic);

      await databaseService.toggleFavorite('1');

      verify(mockSupabaseClient.from('user_favorites').insert({
        'user_id': 'user1',
        'asana_id': '1',
      })).called(1);
    });

    test('fetchFavoriteAsanas는 즐겨찾기한 아사나를 가져옵니다', () async {
      when(mockSupabaseClient.auth.currentUser).thenReturn(
        User(
          id: 'user1',
          appMetadata: {},
          userMetadata: {},
          aud: '',
          createdAt: DateTime.now().toIso8601String(),
        ),
      );

      final mockFavorites = [
        {
          'asanas': {
            'id': '1',
            'sanskrit_name_kr': '아사나1',
            'sanskrit_name_en': 'Asana1',
            'asana_type': 'standing',
            'level': 1,
            'effect_point': '효과1',
            'effect': '효과설명1',
            'story': '스토리1',
            'story_point': '스토리포인트1',
            'created_at': DateTime.now().toIso8601String(),
            'updated_at': DateTime.now().toIso8601String(),
          }
        }
      ];

      when(mockSupabaseClient.from('user_favorites').select('asanas(*)').eq('user_id', 'user1').order('created_at', ascending: false))
          .thenAnswer((_) async => mockFavorites as dynamic);

      final result = await databaseService.fetchFavoriteAsanas();

      expect(result.length, 1);
      expect(result[0].id, '1');
    });
  });

  group('DatabaseService - Journal', () {
    test('fetchAllJournals는 모든 일지를 가져옵니다', () async {
      final mockJournals = [
        {
          'id': '1',
          'title': '일지1',
          'content': '내용1',
          'practiced_asanas': [],
          'created_at': DateTime.now().toIso8601String(),
        }
      ];

      when(mockSupabaseClient.from('journals').select('*, asanas:journal_asanas(*)').order('date', ascending: false))
          .thenAnswer((_) async => mockJournals as dynamic);

      final result = await databaseService.fetchAllJournals();

      expect(result.length, 1);
      expect(result[0].id, '1');
    });

    test('fetchJournalById는 특정 ID의 일지를 가져옵니다', () async {
      final mockJournal = {
        'id': '1',
        'title': '일지1',
        'content': '내용1',
        'practiced_asanas': [],
        'created_at': DateTime.now().toIso8601String(),
      };

      when(mockSupabaseClient.from('journals').select('*, asanas:journal_asanas(*)').eq('id', '1').single())
          .thenAnswer((_) async => mockJournal as dynamic);

      final result = await databaseService.fetchJournalById('1');

      expect(result?.id, '1');
      expect(result?.title, '일지1');
    });

    test('addJournal은 새로운 일지를 추가합니다', () async {
      final journal = JournalModel(
        id: '1',
        title: '일지1',
        content: '내용1',
        practicedAsanas: [],
        createdAt: DateTime.now(),
      );

      when(mockSupabaseClient.from('journals').insert(anyNamed('data')).select().single())
          .thenAnswer((_) async => {'id': '1'} as dynamic);

      await databaseService.addJournal(journal);

      verify(mockSupabaseClient.from('journals').insert(anyNamed('data'))).called(1);
    });

    test('updateJournal은 일지를 수정합니다', () async {
      final journal = JournalModel(
        id: '1',
        title: '일지1',
        content: '내용1',
        practicedAsanas: [],
        createdAt: DateTime.now(),
      );

      when(mockSupabaseClient.from('journals').update(anyNamed('data')).eq('id', '1'))
          .thenAnswer((_) async => {} as dynamic);

      await databaseService.updateJournal(journal);

      verify(mockSupabaseClient.from('journals').update(anyNamed('data')).eq('id', '1')).called(1);
    });

    test('deleteJournal은 일지를 삭제합니다', () async {
      when(mockSupabaseClient.from('journal_asanas').delete().eq('journal_id', '1'))
          .thenAnswer((_) async => {} as dynamic);

      when(mockSupabaseClient.from('journals').delete().eq('id', '1'))
          .thenAnswer((_) async => {} as dynamic);

      await databaseService.deleteJournal('1');

      verify(mockSupabaseClient.from('journal_asanas').delete().eq('journal_id', '1')).called(1);
      verify(mockSupabaseClient.from('journals').delete().eq('id', '1')).called(1);
    });
  });

  group('DatabaseService - Routine', () {
    test('fetchAllRoutines는 모든 루틴을 가져옵니다', () async {
      when(mockSupabaseClient.auth.currentUser).thenReturn(
        User(
          id: 'user1',
          appMetadata: {},
          userMetadata: {},
          aud: '',
          createdAt: DateTime.now().toIso8601String(),
        ),
      );

      final mockRoutines = [
        {
          'id': '1',
          'user_id': 'user1',
          'name': '루틴1',
          'description': '설명1',
          'steps': [],
          'is_default': false,
          'created_at': DateTime.now().toIso8601String(),
        }
      ];

      when(mockSupabaseClient.from('routines').select('*, steps:routine_steps(*)').eq('user_id', 'user1').order('created_at', ascending: false))
          .thenAnswer((_) async => mockRoutines as dynamic);

      final result = await databaseService.fetchAllRoutines();

      expect(result.length, 1);
      expect(result[0].id, '1');
    });

    test('fetchRoutineById는 특정 ID의 루틴을 가져옵니다', () async {
      when(mockSupabaseClient.auth.currentUser).thenReturn(
        User(
          id: 'user1',
          appMetadata: {},
          userMetadata: {},
          aud: '',
          createdAt: DateTime.now().toIso8601String(),
        ),
      );

      final mockRoutine = {
        'id': '1',
        'user_id': 'user1',
        'name': '루틴1',
        'description': '설명1',
        'steps': [],
        'is_default': false,
        'created_at': DateTime.now().toIso8601String(),
      };

      when(mockSupabaseClient.from('routines').select('*, steps:routine_steps(*)').eq('id', '1').eq('user_id', 'user1').single())
          .thenAnswer((_) async => mockRoutine as dynamic);

      final result = await databaseService.fetchRoutineById('1');

      expect(result?.id, '1');
      expect(result?.name, '루틴1');
    });

    test('addRoutine은 새로운 루틴을 추가합니다', () async {
      when(mockSupabaseClient.auth.currentUser).thenReturn(
        User(
          id: 'user1',
          appMetadata: {},
          userMetadata: {},
          aud: '',
          createdAt: DateTime.now().toIso8601String(),
        ),
      );

      final routine = RoutineModel(
        id: '1',
        userId: 'user1',
        name: '루틴1',
        description: '설명1',
        steps: [],
        isDefault: false,
        createdAt: DateTime.now(),
      );

      when(mockSupabaseClient.from('routines').insert(anyNamed('data')).select().single())
          .thenAnswer((_) async => {'id': '1'} as dynamic);

      await databaseService.addRoutine(routine);

      verify(mockSupabaseClient.from('routines').insert(anyNamed('data'))).called(1);
    });

    test('updateRoutine은 루틴을 수정합니다', () async {
      when(mockSupabaseClient.auth.currentUser).thenReturn(
        User(
          id: 'user1',
          appMetadata: {},
          userMetadata: {},
          aud: '',
          createdAt: DateTime.now().toIso8601String(),
        ),
      );

      final routine = RoutineModel(
        id: '1',
        userId: 'user1',
        name: '루틴1',
        description: '설명1',
        steps: [],
        isDefault: false,
        createdAt: DateTime.now(),
      );

      when(mockSupabaseClient.from('routines').update(anyNamed('data')).eq('id', '1').eq('user_id', 'user1'))
          .thenAnswer((_) async => {} as dynamic);

      await databaseService.updateRoutine(routine);

      verify(mockSupabaseClient.from('routines').update(anyNamed('data')).eq('id', '1').eq('user_id', 'user1')).called(1);
    });

    test('deleteRoutine은 루틴을 삭제합니다', () async {
      when(mockSupabaseClient.auth.currentUser).thenReturn(
        User(
          id: 'user1',
          appMetadata: {},
          userMetadata: {},
          aud: '',
          createdAt: DateTime.now().toIso8601String(),
        ),
      );

      when(mockSupabaseClient.from('routine_steps').delete().eq('routine_id', '1'))
          .thenAnswer((_) async => {} as dynamic);

      when(mockSupabaseClient.from('routines').delete().eq('id', '1').eq('user_id', 'user1'))
          .thenAnswer((_) async => {} as dynamic);

      await databaseService.deleteRoutine('1');

      verify(mockSupabaseClient.from('routine_steps').delete().eq('routine_id', '1')).called(1);
      verify(mockSupabaseClient.from('routines').delete().eq('id', '1').eq('user_id', 'user1')).called(1);
    });
  });
} 