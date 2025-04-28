import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/journal_viewmodel.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../widgets/common/error_view.dart';
import 'journal_detail_screen.dart';
import 'edit_journal_screen.dart';

class JournalListScreen extends StatefulWidget {
  const JournalListScreen({super.key});

  @override
  State<JournalListScreen> createState() => _JournalListScreenState();
}

class _JournalListScreenState extends State<JournalListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<JournalViewModel>().fetchAllJournals();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('일지 목록'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const EditJournalScreen(),
              ),
            ),
          ),
        ],
      ),
      body: Consumer<JournalViewModel>(
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
            itemCount: viewModel.journals.length,
            itemBuilder: (context, index) {
              final journal = viewModel.journals[index];
              return ListTile(
                title: Text(journal.title),
                subtitle: Text(journal.createdAt.toString()),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => JournalDetailScreen(journal: journal),
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