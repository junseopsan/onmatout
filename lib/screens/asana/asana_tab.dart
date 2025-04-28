import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AsanaTab extends StatefulWidget {
  const AsanaTab({super.key});

  @override
  State<AsanaTab> createState() => _AsanaTabState();
}

class _AsanaTabState extends State<AsanaTab> {
  List<Map<String, dynamic>> _categories = [];
  List<Map<String, dynamic>> _asanas = [];
  String? _selectedPosture = '전체';
  String? _selectedMovement = '전체';
  bool _loading = true;

  // 허용된 자세 유형 목록
  final List<String> _allowedPostures = [
    '전체',
    '누운',
    '서서',
    '앉은',
    '암밸런스',
    '도립',
    '몸통',
    '네발'
  ];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final supabase = Supabase.instance.client;
      final catRes = await supabase.from('asanacategory').select('posture_type_ko, movement_type_ko, category_name_en, category_name_ko');
      final asanaRes = await supabase.from('asanas').select('sanskrit_name_kr, sanskrit_name_en, category_name_en, level');
      setState(() {
        _categories = List<Map<String, dynamic>>.from(catRes);
        _asanas = List<Map<String, dynamic>>.from(asanaRes);
        _loading = false;
      });
    } catch (e) {
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

    // 1차 필터: 허용된 자세 유형만 표시
    final postures = _allowedPostures;

    // 2차 필터: 동작 유형 (누운/서서/앉은 자세에 대해서만 표시)
    final filteredMovements = () {
      if (_selectedPosture == null || _selectedPosture == '전체') {
        return <String>[];
      }
      
      // 누운/서서/앉은 자세에 대해서만 동작 유형 표시
      if (['누운', '서서', '앉은'].contains(_selectedPosture)) {
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
      if (_selectedPosture == null || _selectedPosture == '전체') {
        return _asanas;
      }
      if (_selectedMovement == null || _selectedMovement == '전체') {
        final categoryEns = _categories
            .where((c) => c['posture_type_ko'] == _selectedPosture)
            .map((c) => c['category_name_en'])
            .toSet();
        return _asanas.where((a) => categoryEns.contains(a['category_name_en'])).toList();
      }
      // posture+movement 모두 선택
      final categoryEns = _categories
          .where((c) =>
              c['posture_type_ko'] == _selectedPosture &&
              c['movement_type_ko'] == _selectedMovement)
          .map((c) => c['category_name_en'])
          .toSet();
      return _asanas.where((a) => categoryEns.contains(a['category_name_en'])).toList();
    }();

    return Scaffold(
      appBar: AppBar(title: const Text('아사나')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1차 필터: 자세 유형
            const Text('자세 유형', style: TextStyle(fontWeight: FontWeight.bold)),
            Wrap(
              spacing: 8,
              children: postures.map((posture) {
                return ChoiceChip(
                  label: Text(posture),
                  selected: _selectedPosture == posture,
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
            // 2차 필터: 동작 유형 (누운/서서/앉은 자세에 대해서만 표시)
            if (['누운', '서서', '앉은'].contains(_selectedPosture)) ...[
              const Text('동작 유형', style: TextStyle(fontWeight: FontWeight.bold)),
              Wrap(
                spacing: 8,
                children: movementChips.map((movement) {
                  return ChoiceChip(
                    label: Text(movement),
                    selected: _selectedMovement == movement,
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
                        final imagePath = 'assets/asana/${asana['sanskrit_name_en']}.png';
                        return GestureDetector(
                          onTap: () {
                            // TODO: 상세화면 이동
                          },
                          child: Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // 썸네일 이미지
                                  Expanded(
                                    child: Image.asset(
                                      imagePath,
                                      fit: BoxFit.contain,
                                      errorBuilder: (context, error, stackTrace) =>
                                          const Icon(Icons.image_not_supported, size: 64, color: Colors.grey),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    asana['sanskrit_name_kr'] ?? '',
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    asana['sanskrit_name_en'] ?? '',
                                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: List.generate(
                                      asana['level'] ?? 1,
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