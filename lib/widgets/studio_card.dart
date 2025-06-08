import 'package:flutter/material.dart';
import '../models/studio_model.dart';

class StudioCard extends StatelessWidget {
  final StudioModel studio;
  final VoidCallback? onTap;

  static const String addressLabel = '주소';
  static const String phoneLabel = '전화번호';

  const StudioCard({
    Key? key,
    required this.studio,
    this.onTap,
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
              child: studio.imageUrl.isNotEmpty
                  ? Image.network(
                      studio.imageUrl,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 80,
                        height: 80,
                        color: Colors.grey[200],
                        child: const Icon(Icons.image_not_supported),
                      ),
                    )
                  : Container(
                      width: 80,
                      height: 80,
                      color: Colors.grey[200],
                      child: const Icon(Icons.image_not_supported),
                    ),
            ),
            const SizedBox(width: 16),
            // 정보
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    studio.name,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text('$addressLabel: ${studio.address}', style: const TextStyle(fontSize: 13)),
                  if (studio.phone.isNotEmpty)
                    Text('$phoneLabel: ${studio.phone}', style: const TextStyle(fontSize: 13)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
} 