import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:onmatout/models/asana_model.dart';
import 'package:onmatout/screens/asana/asana_detail_screen.dart';
import '../../models/asana_model.dart';
import '../../utils/proficiency_level.dart';

class AsanaScreen extends StatefulWidget {
  const AsanaScreen({super.key});

  @override
  State<AsanaScreen> createState() => _AsanaScreenState();
}

class _AsanaScreenState extends State<AsanaScreen> {
  List<Map<String, dynamic>> _categories = [];
  List<Map<String, dynamic>> _asanas = [];
  String? _selectedPosture = '전체';
  String? _selectedMovement = '전체';
  bool _loading = true;
  String _searchQuery = '';

  // 자세 유형 목록 (데이터 로드 후 업데이트)
  List<String> _postures = ['전체'];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final supabase = Supabase.instance.client;
      final catRes = await supabase.from('asanacategory').select('posture_type_ko, movement_type_ko, category_name_en, category_name_ko');
      final asanaRes = await supabase.from('asanas').select('id, sanskrit_name_kr, sanskrit_name_en, category_name_en, level, image_number, effect, story, asana_meaning');
      
      print('카테고리 데이터: $catRes');
      
      setState(() {
        _categories = List<Map<String, dynamic>>.from(catRes);
        _asanas = List<Map<String, dynamic>>.from(asanaRes);
        // 자세 유형 목록 업데이트 (중복 제거 및 정렬)
        final uniquePostures = _categories
            .map((c) => c['posture_type_ko'] as String)
            .toSet()
            .toList()
          ..sort();
        _postures = ['전체', ...uniquePostures];
        print('자세 유형 목록: $_postures');
        _loading = false;
      });
    } catch (e) {
      print('데이터 로드 에러: $e');
      setState(() {
        _loading = false;
      });
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('에러'),
          content: Text('데이터를 불러오는 중 오류가 발생했습니다: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    // 1차 필터: 자세 유형
    final postures = _postures;

    // 2차 필터: 동작 유형 (누운/선/앉은 자세에 대해서만 표시)
    final filteredMovements = () {
      if (_selectedPosture == null || _selectedPosture == '전체') {
        return <String>[];
      }
      
      // 누운/선/앉은 자세에 대해서만 동작 유형 표시
      if (['누운', '선', '앉은'].contains(_selectedPosture)) {
        return _categories
            .where((c) => c['posture_type_ko'] == _selectedPosture)
            .map((c) => c['movement_type_ko'] as String)
            .toSet()
            .toList();
      }
      return <String>[];
    }();
    
    final movementChips = ['전체', ...filteredMovements];

    // 아사나 필터링
    final filteredAsanas = () {
      List<Map<String, dynamic>> result;
      if (_selectedPosture == null || _selectedPosture == '전체') {
        result = _asanas;
      } else if (_selectedMovement == null || _selectedMovement == '전체') {
        final categoryEns = _categories
            .where((c) => c['posture_type_ko'] == _selectedPosture)
            .map((c) => c['category_name_en'])
            .toSet();
        result = _asanas.where((a) => categoryEns.contains(a['category_name_en'])).toList();
      } else {
        final categoryEns = _categories
            .where((c) =>
                c['posture_type_ko'] == _selectedPosture &&
                c['movement_type_ko'] == _selectedMovement)
            .map((c) => c['category_name_en'])
            .toSet();
        result = _asanas.where((a) => categoryEns.contains(a['category_name_en'])).toList();
      }
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        result = result.where((a) =>
          (a['sanskrit_name_kr'] ?? '').toString().toLowerCase().contains(q) ||
          (a['sanskrit_name_en'] ?? '').toString().toLowerCase().contains(q)
        ).toList();
      }
      return result;
    }();

    return Scaffold(
      backgroundColor: const Color(0xFF181A20),
      appBar: AppBar(
        backgroundColor: const Color(0xFF181A20),
        elevation: 0,
        title: const Text('아사나', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 검색 입력창
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextField(
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: '아사나 이름(한글/영어) 검색',
                  hintStyle: const TextStyle(color: Colors.white54),
                  prefixIcon: const Icon(Icons.search, color: Colors.white54),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.white24),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.white24),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                  fillColor: const Color(0xFF23252B),
                  filled: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value.trim();
                  });
                },
              ),
            ),
            // 1차 필터: 자세 유형
            const Text('자세 유형', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
            Wrap(
              spacing: 8,
              children: postures.map((posture) {
                return ChoiceChip(
                  label: Text(posture, style: TextStyle(color: _selectedPosture == posture ? Colors.black : Colors.white)),
                  selected: _selectedPosture == posture,
                  selectedColor: Colors.white,
                  backgroundColor: const Color(0xFF23252B),
                  onSelected: (_) {
                    setState(() {
                      _selectedPosture = posture;
                      _selectedMovement = '전체';
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            // 2차 필터: 동작 유형 (누운/선/앉은 자세에 대해서만 표시)
            if (['누운', '선', '앉은'].contains(_selectedPosture)) ...[
              const Text('동작 유형', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
              Wrap(
                spacing: 8,
                children: movementChips.map((movement) {
                  return ChoiceChip(
                    label: Text(movement, style: TextStyle(color: _selectedMovement == movement ? Colors.black : Colors.white)),
                    selected: _selectedMovement == movement,
                    selectedColor: Colors.white,
                    backgroundColor: const Color(0xFF23252B),
                    onSelected: (_) {
                      setState(() {
                        _selectedMovement = movement;
                      });
                    },
                  );
                }).toList(),
              ),
            ],
            const SizedBox(height: 16),
            // 아사나 리스트
            Expanded(
              child: filteredAsanas.isEmpty
                  ? const Center(child: Text('해당 조건의 아사나가 없습니다.'))
                  : GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.75,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: filteredAsanas.length,
                      itemBuilder: (context, idx) {
                        final asana = filteredAsanas[idx];
                        final asanaId = (asana['id'] ?? '001').toString().padLeft(3, '0');
                        final asanaImageNumber = (asana['image_number'] ?? '001').toString().padLeft(3, '0');
                        // final thumbnailUrl = 'https://ueoytttgsjquapkaerwk.supabase.co/storage/v1/object/public/asanas-images/thumbnail/$asanaImageNumber.jpg';
                        final thumbnailUrl = 'https://ueoytttgsjquapkaerwk.supabase.co/storage/v1/object/public/asanas-images/thumbnail/0001.png';
                        return GestureDetector(
                          onTap: () {
                            final asanaModel = AsanaModel(
                              id: asana['id'] ?? '',
                              sanskritNameKr: asana['sanskrit_name_kr'] ?? '',
                              sanskritNameEn: asana['sanskrit_name_en'] ?? '',
                              level: asana['level'] ?? '',
                              effectPoint: asana['effect_point'] ?? '',
                              effect: asana['effect'] ?? '',
                              story: asana['story'] ?? '',
                              storyPoint: asana['story_point'] ?? '',
                              categoryNameEn: asana['category_name_en'] ?? '',
                              imageNumber: asanaImageNumber,
                              asanaMeaning: asana['asana_meaning'] ?? '',
                            );
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => AsanaDetailScreen(
                                  asana: asanaModel,
                                  asanaId: asanaId,
                                  asanaImageNumber: asanaImageNumber,
                                ),
                              ),
                            );
                          },
                          child: Card(
                            color: const Color(0xFFF5F5F7).withOpacity(0.95),
                            elevation: 2,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // 썸네일 네트워크 이미지 (thumbnail 폴더)
                                  Expanded(
                                    child: Image.network(
                                      thumbnailUrl,
                                      fit: BoxFit.contain,
                                      errorBuilder: (context, error, stackTrace) =>
                                          const Icon(Icons.image_not_supported, size: 64, color: Colors.grey),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    asana['sanskrit_name_kr'] ?? '',
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    asana['sanskrit_name_en'] ?? '',
                                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: List.generate(
                                      int.tryParse(asana['level']?.toString() ?? '1') ?? 1,
                                      (i) => const Icon(Icons.star, size: 16, color: Colors.amber),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
} 