import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/studio_viewmodel.dart';
import '../widgets/studio_card.dart';

class StudioScreen extends StatefulWidget {
  const StudioScreen({Key? key}) : super(key: key);

  @override
  State<StudioScreen> createState() => _StudioScreenState();
}

class _StudioScreenState extends State<StudioScreen> {
  static const String title = '요가원 탐색';
  static const String searchHint = '지역, 이름으로 검색';

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StudioViewModel>().fetchStudios();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<StudioViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          appBar: AppBar(title: const Text(title)),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: searchHint,
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: viewModel.searchStudios,
                ),
              ),
              Expanded(
                child: viewModel.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : viewModel.studios.isEmpty
                        ? const Center(child: Text('요가원이 없습니다.'))
                        : ListView.builder(
                            itemCount: viewModel.studios.length,
                            itemBuilder: (context, idx) {
                              final studio = viewModel.studios[idx];
                              return StudioCard(
                                studio: studio,
                                onTap: () {
                                  // TODO: 상세 화면 이동 구현
                                },
                              );
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