import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/asana_viewmodel.dart';
import 'asana_detail_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

class AsanaListScreen extends StatefulWidget {
  const AsanaListScreen({super.key});

  @override
  State<AsanaListScreen> createState() => _AsanaListScreenState();
}

class _AsanaListScreenState extends State<AsanaListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AsanaViewModel>().fetchAllAsanas();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('아사나 목록'),
      ),
      body: Consumer<AsanaViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (viewModel.error.isNotEmpty) {
            return Center(
              child: Text(
                viewModel.error,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          return ListView.builder(
            itemCount: viewModel.filteredAsanas.length,
            itemBuilder: (context, index) {
              final asana = viewModel.filteredAsanas[index];
              return ListTile(
                key: ValueKey(asana.id),
                leading: CircleAvatar(
                  backgroundColor: Colors.grey[200],
                  radius: 24,
                  child: ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: asana.imageUrl,
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        period: Duration(milliseconds: 1800),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => const Icon(Icons.image_not_supported, size: 24, color: Colors.grey),
                    ),
                  ),
                ),
                title: Text(asana.name),
                subtitle: Text(asana.category),
                trailing: IconButton(
                  icon: Icon(
                    asana.isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: asana.isFavorite ? Colors.red : null,
                  ),
                  onPressed: () => viewModel.toggleFavorite(asana.id),
                ),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AsanaDetailScreen(
                      asana: asana,
                      asanaId: asana.id,
                      asanaImageNumber: asana.imageNumber,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
} 