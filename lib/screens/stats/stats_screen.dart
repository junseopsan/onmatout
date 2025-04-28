import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/stats_viewmodel.dart';
import 'package:fl_chart/fl_chart.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StatsViewModel>().fetchStats();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('통계'),
      ),
      body: Consumer<StatsViewModel>(
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

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '수련 시간',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 200,
                  child: LineChart(
                    LineChartData(
                      gridData: const FlGridData(show: false),
                      titlesData: const FlTitlesData(show: false),
                      borderData: FlBorderData(show: false),
                      lineBarsData: [
                        LineChartBarData(
                          spots: viewModel.practiceTimeData
                              .asMap()
                              .entries
                              .map((e) => FlSpot(e.key.toDouble(), e.value))
                              .toList(),
                          isCurved: true,
                          color: Theme.of(context).primaryColor,
                          barWidth: 2,
                          isStrokeCapRound: true,
                          dotData: const FlDotData(show: false),
                          belowBarData: BarAreaData(show: false),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  '수련한 아사나',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 200,
                  child: PieChart(
                    PieChartData(
                      sections: viewModel.practicedAsanasData.entries
                          .map(
                            (e) => PieChartSectionData(
                              value: e.value.toDouble(),
                              title: '${e.key}\n${e.value}회',
                              color: Theme.of(context).primaryColor,
                            ),
                          )
                          .toList(),
                      sectionsSpace: 0,
                      centerSpaceRadius: 40,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  '수련 일수',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  '${viewModel.totalPracticeDays}일',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 16),
                Text(
                  '총 수련 시간',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  '${viewModel.totalPracticeTime}분',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
} 