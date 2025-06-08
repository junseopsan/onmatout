import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/stats_viewmodel.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({Key? key}) : super(key: key);

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  static const String title = '수련 통계';
  static const String totalCountLabel = '누적 수련 횟수';
  static const String streakCountLabel = '연속 수련 일수';
  static const String emotionLabel = '감정 통계';
  static const String energyLabel = '에너지 통계';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StatsViewModel>().fetchStats();
    });
  }

  Widget _buildPieChart(Map<String, int> data, String label) {
    if (data.isEmpty) {
      return const Text('데이터 없음');
    }
    final total = data.values.fold<int>(0, (sum, v) => sum + v);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 12,
          children: data.entries.map((e) {
            final percent = total > 0 ? (e.value / total * 100).toStringAsFixed(1) : '0';
            return Chip(
              label: Text('${e.key}: ${e.value}회 ($percent%)'),
            );
          }).toList(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<StatsViewModel>(
      builder: (context, viewModel, child) {
        final stats = viewModel.stats;
        return Scaffold(
          appBar: AppBar(title: const Text(title)),
          body: viewModel.isLoading
              ? const Center(child: CircularProgressIndicator())
              : stats == null
                  ? Center(child: Text(viewModel.errorMessage ?? '통계 데이터가 없습니다.'))
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  Text(totalCountLabel, style: const TextStyle(fontSize: 14)),
                                  const SizedBox(height: 4),
                                  Text('${stats.totalCount}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
                                ],
                              ),
                              Column(
                                children: [
                                  Text(streakCountLabel, style: const TextStyle(fontSize: 14)),
                                  const SizedBox(height: 4),
                                  Text('${stats.streakCount}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),
                          _buildPieChart(stats.emotionStats, emotionLabel),
                          const SizedBox(height: 24),
                          _buildPieChart(stats.energyStats, energyLabel),
                        ],
                      ),
                    ),
        );
      },
    );
  }
} 