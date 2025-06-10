import 'package:flutter/material.dart';
import '../../models/record_model.dart';

class RecordEntry extends StatelessWidget {
  final RecordModel record;

  const RecordEntry({
    Key? key,
    required this.record,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${record.date.year}년 ${record.date.month}월 ${record.date.day}일',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${record.date.hour}:${record.date.minute.toString().padLeft(2, '0')}',
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: record.asanas.map((asana) {
                return Chip(
                  label: Text(asana.sanskritNameKr),
                  backgroundColor: Colors.blue[100],
                );
              }).toList(),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildStatusChip('감정', record.emotion),
                const SizedBox(width: 8),
                _buildStatusChip('에너지', record.energy),
                const SizedBox(width: 8),
                _buildStatusChip('집중도', record.focus),
              ],
            ),
            if (record.memo.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                record.memo,
                style: TextStyle(
                  color: Colors.grey[800],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String label, String value) {
    Color chipColor;
    switch (value) {
      case '좋음':
      case '높음':
      case '집중':
        chipColor = Colors.green[100]!;
        break;
      case '보통':
      case '흐림':
        chipColor = Colors.orange[100]!;
        break;
      case '나쁨':
      case '낮음':
      case '산만':
        chipColor = Colors.red[100]!;
        break;
      default:
        chipColor = Colors.grey[100]!;
    }

    return Chip(
      label: Text('$label: $value'),
      backgroundColor: chipColor,
    );
  }
} 