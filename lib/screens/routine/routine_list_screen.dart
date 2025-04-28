import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/routine_viewmodel.dart';
import 'routine_detail_screen.dart';
import 'edit_routine_screen.dart';

class RoutineListScreen extends StatefulWidget {
  const RoutineListScreen({super.key});

  @override
  State<RoutineListScreen> createState() => _RoutineListScreenState();
}

class _RoutineListScreenState extends State<RoutineListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RoutineViewModel>().fetchAllRoutines();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('루틴 목록'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const EditRoutineScreen(),
              ),
            ),
          ),
        ],
      ),
      body: Consumer<RoutineViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (viewModel.error != null && viewModel.error!.isNotEmpty) {
            return Center(
              child: Text(
                viewModel.error!,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          return ListView.builder(
            itemCount: viewModel.routines.length,
            itemBuilder: (context, index) {
              final routine = viewModel.routines[index];
              return ListTile(
                title: Text(routine.name),
                subtitle: Text('${routine.steps.length}개의 아사나'),
                trailing: Text('${viewModel.getTotalDuration(routine.id)}분'),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RoutineDetailScreen(routine: routine),
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