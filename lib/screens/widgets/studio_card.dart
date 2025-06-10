import 'package:flutter/material.dart';
import '../../models/studio_model.dart';

class StudioCard extends StatelessWidget {
  final StudioModel studio;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteTap;

  const StudioCard({
    Key? key,
    required this.studio,
    this.onTap,
    this.onFavoriteTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 요가원 이미지
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: studio.images.isNotEmpty
                    ? Image.network(
                        studio.images[0],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[300],
                            child: const Icon(Icons.image, size: 48),
                          );
                        },
                      )
                    : Container(
                        color: Colors.grey[300],
                        child: const Icon(Icons.image, size: 48),
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 요가원 이름과 즐겨찾기 버튼
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          studio.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          studio.isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: studio.isFavorite ? Colors.red : null,
                        ),
                        onPressed: onFavoriteTap,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // 평점과 리뷰 수
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber[700], size: 20),
                      const SizedBox(width: 4),
                      Text(
                        studio.rating.toStringAsFixed(1),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '(${studio.reviewCount})',
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // 주소
                  Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.grey[600], size: 20),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          studio.address,
                          style: TextStyle(
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  // 영업 시간
                  Row(
                    children: [
                      Icon(Icons.access_time, color: Colors.grey[600], size: 20),
                      const SizedBox(width: 4),
                      Text(
                        _getCurrentHours(studio.hours),
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: studio.isOpen ? Colors.green[100] : Colors.red[100],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          studio.isOpen ? '영업중' : '영업종료',
                          style: TextStyle(
                            color: studio.isOpen ? Colors.green[800] : Colors.red[800],
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  // 거리
                  Row(
                    children: [
                      Icon(Icons.directions_walk, color: Colors.grey[600], size: 20),
                      const SizedBox(width: 4),
                      Text(
                        studio.distance != null ? '${studio.distance!.toStringAsFixed(1)}km' : '거리 정보 없음',
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getCurrentHours(Map<String, String> hours) {
    final now = DateTime.now();
    final days = ['월', '화', '수', '목', '금', '토', '일'];
    final currentDay = days[now.weekday - 1];
    return hours[currentDay] ?? '휴무';
  }
} 