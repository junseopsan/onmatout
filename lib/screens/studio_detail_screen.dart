import 'package:flutter/material.dart';
import '../models/studio_model.dart';

class StudioDetailScreen extends StatelessWidget {
  final StudioModel studio;

  static const String addressLabel = '주소';
  static const String phoneLabel = '전화번호';
  static const String openHoursLabel = '운영시간';
  static const String descriptionLabel = '설명';
  static const String locationLabel = '위치';

  const StudioDetailScreen({Key? key, required this.studio}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(studio.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (studio.imageUrl.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  studio.imageUrl,
                  width: double.infinity,
                  height: 180,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: double.infinity,
                    height: 180,
                    color: Colors.grey[200],
                    child: const Icon(Icons.image_not_supported, size: 48),
                  ),
                ),
              ),
            const SizedBox(height: 16),
            Text('$addressLabel: ${studio.address}', style: const TextStyle(fontSize: 15)),
            const SizedBox(height: 8),
            Text('$phoneLabel: ${studio.phone}', style: const TextStyle(fontSize: 15)),
            const SizedBox(height: 8),
            Text('$openHoursLabel: ${studio.openHours}', style: const TextStyle(fontSize: 15)),
            const SizedBox(height: 8),
            Text('$locationLabel: (${studio.latitude}, ${studio.longitude})', style: const TextStyle(fontSize: 15)),
            const SizedBox(height: 16),
            if (studio.description.isNotEmpty)
              Text('$descriptionLabel\n${studio.description}', style: const TextStyle(fontSize: 15)),
          ],
        ),
      ),
    );
  }
} 