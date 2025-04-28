import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/asana_viewmodel.dart';
import 'asana_detail_screen.dart';

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
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(asana.imageUrl),
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
                    builder: (context) => AsanaDetailScreen(asana: asana),
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