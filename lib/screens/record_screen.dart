import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/record_viewmodel.dart';
import '../models/record_model.dart';
import '../models/asana_model.dart';
import '../widgets/record_entry.dart';
import '../record_screen.dart'; // 또는 실제 경로에 맞게 수정

class RecordScreen extends StatefulWidget {
  const RecordScreen({Key? key}) : super(key: key);

  @override
  State<RecordScreen> createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> {
  final _formKey = GlobalKey<FormState>();
  List<AsanaModel> _selectedAsanas = [];
  String _emotion = '';
  String _energy = '';
  String _focus = '';
  String _memo = '';

  static const String title = '수련 기록';
  static const String addRecordBtn = '기록 추가';
  static const String asanaSelectLabel = '아사나 선택';
  static const String emotionLabel = '감정';
  static const String energyLabel = '에너지';
  static const String focusLabel = '집중도';
  static const String memoLabel = '메모';
  static const String requiredFieldMsg = '필수 입력 항목입니다.';
  static const List<String> emotionOptions = ['좋음', '보통', '나쁨'];
  static const List<String> energyOptions = ['높음', '보통', '낮음'];
  static const List<String> focusOptions = ['집중', '흐림', '산만'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RecordViewModel>().fetchRecords();
    });
  }

  void _showAsanaSelectDialog(List<AsanaModel> allAsanas) async {
    final selected = await showDialog<List<AsanaModel>>(
      context: context,
      builder: (context) {
        final tempSelected = List<AsanaModel>.from(_selectedAsanas);
        return AlertDialog(
          title: const Text(asanaSelectLabel),
          content: SizedBox(
            width: double.maxFinite,
            height: 300,
            child: ListView(
              children: allAsanas.map((asana) {
                final selected = tempSelected.contains(asana);
                return CheckboxListTile(
                  value: selected,
                  title: Text(asana.nameKo),
                  onChanged: (v) {
                    setState(() {
                      if (v == true) {
                        tempSelected.add(asana);
                      } else {
                        tempSelected.remove(asana);
                      }
                    });
                  },
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, tempSelected),
              child: const Text('확인'),
            ),
          ],
        );
      },
    );
    if (selected != null) {
      setState(() {
        _selectedAsanas = selected;
      });
    }
  }

  Future<void> _addRecord(RecordViewModel viewModel) async {
    if (_selectedAsanas.isEmpty || _emotion.isEmpty || _energy.isEmpty || _focus.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(requiredFieldMsg)));
      return;
    }
    final record = RecordModel(
      id: '',
      userId: '', // 실제 구현 시 현재 유저 ID로 대체
      date: DateTime.now(),
      asanas: _selectedAsanas,
      emotion: _emotion,
      energy: _energy,
      focus: _focus,
      memo: _memo,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    await viewModel.addRecord(record);
    setState(() {
      _selectedAsanas = [];
      _emotion = '';
      _energy = '';
      _focus = '';
      _memo = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RecordViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          appBar: AppBar(title: const Text(title)),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ElevatedButton(
                        onPressed: () => _showAsanaSelectDialog([]), // TODO: 실제 아사나 목록 전달
                        child: Text(_selectedAsanas.isEmpty
                            ? asanaSelectLabel
                            : _selectedAsanas.map((a) => a.nameKo).join(', ')),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _emotion.isEmpty ? null : _emotion,
                        items: emotionOptions
                            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                            .toList(),
                        onChanged: (v) => setState(() => _emotion = v ?? ''),
                        decoration: const InputDecoration(labelText: emotionLabel),
                        validator: (v) => v == null || v.isEmpty ? requiredFieldMsg : null,
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _energy.isEmpty ? null : _energy,
                        items: energyOptions
                            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                            .toList(),
                        onChanged: (v) => setState(() => _energy = v ?? ''),
                        decoration: const InputDecoration(labelText: energyLabel),
                        validator: (v) => v == null || v.isEmpty ? requiredFieldMsg : null,
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _focus.isEmpty ? null : _focus,
                        items: focusOptions
                            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                            .toList(),
                        onChanged: (v) => setState(() => _focus = v ?? ''),
                        decoration: const InputDecoration(labelText: focusLabel),
                        validator: (v) => v == null || v.isEmpty ? requiredFieldMsg : null,
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        initialValue: _memo,
                        decoration: const InputDecoration(labelText: memoLabel),
                        onChanged: (v) => setState(() => _memo = v),
                        maxLines: 2,
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: viewModel.isLoading ? null : () => _addRecord(viewModel),
                        child: viewModel.isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Text(addRecordBtn),
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(),
              Expanded(
                child: viewModel.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : viewModel.records.isEmpty
                        ? const Center(child: Text('기록이 없습니다.'))
                        : ListView.builder(
                            itemCount: viewModel.records.length,
                            itemBuilder: (context, idx) {
                              final record = viewModel.records[idx];
                              return RecordEntry(record: record);
                            },
                          ),
              ),
            ],
          ),
        );
      },
    );
  }
} 