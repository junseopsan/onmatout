import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:http/http.dart' as http;
import '../../models/asana_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AsanaDetailScreen extends StatefulWidget {
  final AsanaModel asana;
  final String asanaId;
  final String asanaImageNumber;

  const AsanaDetailScreen({
    required this.asana,
    required this.asanaId,
    required this.asanaImageNumber,
    Key? key,
  }) : super(key: key);

  @override
  State<AsanaDetailScreen> createState() => _AsanaDetailScreenState();
}

class _AsanaDetailScreenState extends State<AsanaDetailScreen> {
  int _current = 0;
  String? _categoryNameKo;

  @override
  void initState() {
    super.initState();
    _fetchCategoryNameKo();
  }

  Future<void> _fetchCategoryNameKo() async {
    final supabase = Supabase.instance.client;
    final res = await supabase
        .from('asanacategory')
        .select('category_name_ko')
        .eq('category_name_en', widget.asana.categoryNameEn)
        .maybeSingle();
    setState(() {
      _categoryNameKo = res != null ? res['category_name_ko'] as String? : null;
    });
  }

  List<String> getImageUrls() {
    // 최대 5장까지 시도, 실제로 존재하지 않는 이미지는 errorBuilder에서 처리
    return List.generate(5, (i) {
      final imgNum = (i + 1).toString().padLeft(3, '0');
      return 'https://ueoytttgsjquapkaerwk.supabase.co/storage/v1/object/public/asanas-images/${widget.asanaImageNumber}/$imgNum.jpg';
    });
  }

  Future<List<String>> getValidImageUrls(List<String> urls) async {
    final results = await Future.wait(
      urls.map((url) async {
        final response = await http.head(Uri.parse(url));
        return response.statusCode == 200 ? url : null;
      }),
    );
    return results.whereType<String>().toList();
  }

  @override
  Widget build(BuildContext context) {
    final imageUrls = getImageUrls();
    // 난이도 enum을 별 개수로 변환 (예시: 1~3)
    int level = int.tryParse(widget.asana.level) ?? 1;

    return FutureBuilder<List<String>>(
      future: getValidImageUrls(imageUrls),
      builder: (context, snapshot) {
        final validUrls = snapshot.data ?? [];
        return Scaffold(
          backgroundColor: const Color(0xFF1A1A1A),
          appBar: AppBar(
            backgroundColor: const Color(0xFF2A2A2A),
            title: Text(
              widget.asana.sanskritNameKr,
              style: const TextStyle(color: Colors.white),
            ),
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (validUrls.isNotEmpty) ...[
                  if (validUrls.length == 1) ...[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: CachedNetworkImage(
                        imageUrl: validUrls.first,
                        height: 220,
                        fit: BoxFit.contain,
                        placeholder: (context, url) => Shimmer.fromColors(
                          baseColor: Colors.grey[800]!,
                          highlightColor: Colors.grey[700]!,
                          child: Container(
                            color: Colors.grey[800],
                            height: 220,
                            width: double.infinity,
                          ),
                        ),
                        errorWidget: (context, url, error) => const Icon(Icons.image_not_supported, size: 64, color: Colors.grey),
                      ),
                    ),
                  ] else ...[
                    FlutterCarousel(
                      items: validUrls.map((url) {
                        return Builder(
                          builder: (BuildContext context) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: CachedNetworkImage(
                                imageUrl: url,
                                height: 220,
                                fit: BoxFit.contain,
                                placeholder: (context, url) => Shimmer.fromColors(
                                  baseColor: Colors.grey[800]!,
                                  highlightColor: Colors.grey[700]!,
                                  child: Container(
                                    color: Colors.grey[800],
                                    height: 220,
                                    width: double.infinity,
                                  ),
                                ),
                                errorWidget: (context, url, error) => const Icon(Icons.image_not_supported, size: 64, color: Colors.grey),
                              ),
                            );
                          },
                        );
                      }).toList(),
                      options: CarouselOptions(
                        height: 300,
                        viewportFraction: 1.0,
                        enableInfiniteScroll: true,
                        autoPlay: true,
                        autoPlayInterval: const Duration(seconds: 3),
                        autoPlayAnimationDuration: const Duration(milliseconds: 800),
                        autoPlayCurve: Curves.fastOutSlowIn,
                        enlargeCenterPage: true,
                        showIndicator: false,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _current = index;
                          });
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(validUrls.length, (index) {
                        return Container(
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _current == index ? Colors.red : Colors.grey[600],
                          ),
                        );
                      }),
                    ),
                  ],
                ],
                const SizedBox(height: 20),
                // 이름, 카테고리, 레벨
                Text(
                  widget.asana.sanskritNameKr,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: Colors.white,
                  ),
                ),
                Text(
                  widget.asana.sanskritNameEn,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                // 의미(해석) 박스
                if (widget.asana.asanaMeaning.trim().isNotEmpty)
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2A2A2A),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: widget.asana.asanaMeaning
                                .split('+')
                                .map((s) => Text(
                                      s.trim(),
                                      style: const TextStyle(
                                        fontSize: 15,
                                        color: Colors.greenAccent,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ))
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _categoryNameKo ?? widget.asana.categoryNameEn,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 12),
                    ...List.generate(
                      level,
                      (i) => const Icon(Icons.star, color: Colors.amber, size: 18),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // 효과/포인트
                if (widget.asana.effect.isNotEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2A2A2A),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      widget.asana.effect,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
} 