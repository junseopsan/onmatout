import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/asana_viewmodel.dart';
import '../../models/asana_model.dart';
import '../../models/proficiency_level.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../widgets/common/error_view.dart';

class AsanaDetailScreen extends StatelessWidget {
  final AsanaModel asana;

  const AsanaDetailScreen({
    super.key,
    required this.asana,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(asana.name),
        actions: [
          IconButton(
            icon: Icon(
              asana.isFavorite ? Icons.favorite : Icons.favorite_border,
              color: asana.isFavorite ? Colors.red : null,
            ),
            onPressed: () => context.read<AsanaViewModel>().toggleFavorite(asana.id),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.network(
              asana.imageUrl,
              height: 300,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    asana.name,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '카테고리: ${asana.category}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '효과',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(asana.effects),
                  const SizedBox(height: 16),
                  Text(
                    '설명',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(asana.description),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
} 