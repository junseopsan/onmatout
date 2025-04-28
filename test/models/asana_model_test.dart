import 'package:flutter_test/flutter_test.dart';
import 'package:onmatout/models/asana_model.dart';
import 'package:onmatout/models/proficiency_level.dart';

void main() {
  group('AsanaModel', () {
    test('should create AsanaModel from json', () {
      final json = {
        'id': '1',
        'name': 'Test Asana',
        'sanskritName': 'Test Sanskrit',
        'imageUrl': 'test.jpg',
        'description': 'Test Description',
        'difficulty': 'beginner',
        'category': 'Test Category',
        'effects': 'Test Effects',
        'story': 'Test Story',
        'duration': 60,
        'isFavorite': false,
      };

      final asana = AsanaModel.fromJson(json);

      expect(asana.id, '1');
      expect(asana.name, 'Test Asana');
      expect(asana.sanskritName, 'Test Sanskrit');
      expect(asana.imageUrl, 'test.jpg');
      expect(asana.description, 'Test Description');
      expect(asana.difficulty, ProficiencyLevel.beginner);
      expect(asana.category, 'Test Category');
      expect(asana.effects, 'Test Effects');
      expect(asana.story, 'Test Story');
      expect(asana.duration, 60);
      expect(asana.isFavorite, false);
    });

    test('should convert AsanaModel to json', () {
      final asana = AsanaModel(
        id: '1',
        name: 'Test Asana',
        sanskritName: 'Test Sanskrit',
        imageUrl: 'test.jpg',
        description: 'Test Description',
        difficulty: ProficiencyLevel.beginner,
        category: 'Test Category',
        effects: 'Test Effects',
        story: 'Test Story',
        duration: 60,
        isFavorite: false,
      );

      final json = asana.toJson();

      expect(json['id'], '1');
      expect(json['name'], 'Test Asana');
      expect(json['sanskritName'], 'Test Sanskrit');
      expect(json['imageUrl'], 'test.jpg');
      expect(json['description'], 'Test Description');
      expect(json['difficulty'], 'beginner');
      expect(json['category'], 'Test Category');
      expect(json['effects'], 'Test Effects');
      expect(json['story'], 'Test Story');
      expect(json['duration'], 60);
      expect(json['isFavorite'], false);
    });

    test('should create copy of AsanaModel with new values', () {
      final original = AsanaModel(
        id: '1',
        name: 'Test Asana',
        sanskritName: 'Test Sanskrit',
        sanskritNameKr: 'Test Sanskrit Kr',
        imageUrl: 'test.jpg',
        description: 'Test Description',
        difficulty: ProficiencyLevel.beginner,
        category: 'Test Category',
        effects: 'Test Effects',
        story: 'Test Story',
        duration: 60,
        isFavorite: false,
      );

      final copy = original.copyWith(
        name: 'New Name',
        isFavorite: true,
      );

      expect(copy.id, original.id);
      expect(copy.name, 'New Name');
      expect(copy.sanskritName, original.sanskritName);
      expect(copy.imageUrl, original.imageUrl);
      expect(copy.description, original.description);
      expect(copy.difficulty, original.difficulty);
      expect(copy.category, original.category);
      expect(copy.effects, original.effects);
      expect(copy.story, original.story);
      expect(copy.duration, original.duration);
      expect(copy.isFavorite, true);
    });
  });
} 