import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/journal_viewmodel.dart';
import '../../viewmodels/asana_viewmodel.dart';
import '../../models/journal_model.dart';
import '../../models/asana_model.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../widgets/common/error_view.dart';
import 'edit_journal_screen.dart';

class JournalDetailScreen extends StatelessWidget {
  final JournalModel journal;

  const JournalDetailScreen({
    super.key,
    required this.journal,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(journal.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditJournalScreen(journal: journal),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('일지 삭제'),
                  content: const Text('이 일지를 삭제하시겠습니까?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('취소'),
                    ),
                    TextButton(
                      onPressed: () {
                        context.read<JournalViewModel>().deleteJournal(journal.id);
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: const Text('삭제'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              journal.title,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            Text(
              '작성일: ${journal.createdAt.toString()}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Text(
              '내용',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(journal.content),
            const SizedBox(height: 16),
            Text(
              '수련한 아사나',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: journal.practicedAsanas.length,
              itemBuilder: (context, index) {
                final asana = journal.practicedAsanas[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(asana.imageUrl),
                  ),
                  title: Text(asana.name),
                  subtitle: Text('${asana.duration}초'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
} 