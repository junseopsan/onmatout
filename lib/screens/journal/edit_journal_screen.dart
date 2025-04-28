import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/journal_model.dart';
import '../../models/asana_model.dart';
import '../../viewmodels/journal_viewmodel.dart';
import '../../viewmodels/asana_viewmodel.dart';

class EditJournalScreen extends StatefulWidget {
  final JournalModel? journal;

  const EditJournalScreen({
    super.key,
    this.journal,
  });

  @override
  State<EditJournalScreen> createState() => _EditJournalScreenState();
}

class _EditJournalScreenState extends State<EditJournalScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _selectedAsanas = <AsanaModel>[];

  @override
  void initState() {
    super.initState();
    if (widget.journal != null) {
      _titleController.text = widget.journal!.title;
      _contentController.text = widget.journal!.content;
      _selectedAsanas.addAll(widget.journal!.practicedAsanas);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _saveJournal() {
    if (!_formKey.currentState!.validate()) return;

    final journal = JournalModel(
      id: widget.journal?.id ?? DateTime.now().toString(),
      title: _titleController.text,
      content: _contentController.text,
      practicedAsanas: _selectedAsanas,
      createdAt: widget.journal?.createdAt ?? DateTime.now(),
    );

    if (widget.journal == null) {
      context.read<JournalViewModel>().addJournal(journal);
    } else {
      context.read<JournalViewModel>().updateJournal(journal);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.journal == null ? '새 일지' : '일지 편집'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: '제목',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '제목을 입력하세요';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _contentController,
              decoration: const InputDecoration(
                labelText: '내용',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '내용을 입력하세요';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            Text(
              '수련한 아사나',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _selectedAsanas.length,
              itemBuilder: (context, index) {
                final asana = _selectedAsanas[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(asana.imageUrl),
                  ),
                  title: Text(asana.name),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        _selectedAsanas.removeAt(index);
                      });
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveJournal,
              child: const Text('저장'),
            ),
          ],
        ),
      ),
    );
  }
} 