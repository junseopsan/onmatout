import 'package:flutter/material.dart';
import '../models/asana_model.dart';

class AsanaCard extends StatelessWidget {
  final AsanaModel asana;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteToggle;

  static const String categoryLabel = '카테고리';
  static const String difficultyLabel = '난이도';

  const AsanaCard({
    Key? key,
    required this.asana,
    this.onTap,
    this.onFavoriteToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: InkWell(
        onTap: onTap,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 이미지
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                'https://storage.googleapis.com/onmatout-images/${asana.imageNumber}.jpg',
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 80,
                  height: 80,
                  color: Colors.grey[200],
                  child: const Icon(Icons.image_not_supported),
                ),
              ),
            ),
            const SizedBox(width: 16),
            // 정보
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    asana.sanskritNameKr,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    asana.sanskritNameEn,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text('$categoryLabel: ${asana.categoryNameEn}', style: const TextStyle(fontSize: 12)),
                      const SizedBox(width: 8),
                      Text('$difficultyLabel: ${asana.level}', style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
            // 즐겨찾기 버튼
            IconButton(
              icon: Icon(
                asana.isFavorite ? Icons.star : Icons.star_border,
                color: asana.isFavorite ? Colors.amber : Colors.grey,
              ),
              onPressed: onFavoriteToggle,
            ),
          ],
        ),
      ),
    );
  }
} 