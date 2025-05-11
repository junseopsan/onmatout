import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/routine_model.dart';
import '../../viewmodels/routine_viewmodel.dart';
import '../../viewmodels/asana_viewmodel.dart';
import '../asana/asana_detail_screen.dart';
import 'edit_routine_screen.dart';

class RoutineDetailScreen extends StatelessWidget {
  final RoutineModel routine;

  const RoutineDetailScreen({
    super.key,
    required this.routine,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(routine.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditRoutineScreen(routine: routine),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '총 ${routine.steps.length}개의 아사나',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  '총 소요 시간: ${context.read<RoutineViewModel>().getTotalDuration(routine.id)}분',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: routine.steps.length,
              itemBuilder: (context, index) {
                final step = routine.steps[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(step.asanaImageUrl),
                  ),
                  title: Text(step.asanaName),
                  subtitle: Text('${step.duration}초'),
                  onTap: () async {
                    final asana = await context.read<AsanaViewModel>().getAsanaById(step.asanaId);
                    if (asana != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AsanaDetailScreen(
                            asana: asana,
                            asanaId: asana.id,
                            asanaImageNumber: asana.imageNumber,
                          ),
                        ),
                      );
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: 루틴 시작 구현
        },
        label: const Text('루틴 시작'),
        icon: const Icon(Icons.play_arrow),
      ),
    );
  }
} 