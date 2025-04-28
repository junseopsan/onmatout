import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/routine_model.dart';
import '../../viewmodels/routine_viewmodel.dart';
import '../../viewmodels/asana_viewmodel.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditRoutineScreen extends StatefulWidget {
  final RoutineModel? routine;

  const EditRoutineScreen({
    super.key,
    this.routine,
  });

  @override
  State<EditRoutineScreen> createState() => _EditRoutineScreenState();
}

class _EditRoutineScreenState extends State<EditRoutineScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _steps = <RoutineStep>[];

  @override
  void initState() {
    super.initState();
    if (widget.routine != null) {
      _nameController.text = widget.routine!.name;
      _steps.addAll(widget.routine!.steps);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _addStep(String asanaId, String asanaName, String asanaImageUrl, int duration) {
    setState(() {
      _steps.add(RoutineStep(
        id: DateTime.now().toString(),
        asanaId: asanaId,
        asanaName: asanaName,
        asanaImageUrl: asanaImageUrl,
        duration: duration,
      ));
    });
  }

  void _removeStep(int index) {
    setState(() {
      _steps.removeAt(index);
    });
  }

  void _saveRoutine() {
    if (!_formKey.currentState!.validate()) return;

    final routine = RoutineModel(
      id: widget.routine?.id ?? DateTime.now().toString(),
      userId: Supabase.instance.client.auth.currentUser?.id ?? '',
      name: _nameController.text,
      description: '',
      steps: _steps,
      createdAt: widget.routine?.createdAt ?? DateTime.now(),
    );

    if (widget.routine == null) {
      context.read<RoutineViewModel>().addRoutine(routine);
    } else {
      context.read<RoutineViewModel>().updateRoutine(routine);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.routine == null ? '새 루틴' : '루틴 편집'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: '루틴 이름',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '루틴 이름을 입력하세요';
                  }
                  return null;
                },
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _steps.length,
                itemBuilder: (context, index) {
                  final step = _steps[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(step.asanaImageUrl),
                    ),
                    title: Text(step.asanaName),
                    subtitle: Text('${step.duration}초'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _removeStep(index),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _saveRoutine,
        label: const Text('저장'),
        icon: const Icon(Icons.save),
      ),
    );
  }
} 