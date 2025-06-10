import 'package:flutter/material.dart';
import '../models/record_model.dart';

class RecordEntry extends StatelessWidget {
  final RecordModel record;
  final VoidCallback? onTap;

  static const String dateLabel = '날짜';
  static const String asanasLabel = '아사나';
  static const String emotionLabel = '감정';
  static const String energyLabel = '에너지';
  static const String focusLabel = '집중도';
  static const String memoLabel = '메모';

  const RecordEntry({
    Key? key,
    required this.record,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '$dateLabel: ${record.date.toLocal().toString().split(" ")[0]}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  if (record.asanas.isNotEmpty)
                    Row(
                      children: record.asanas.take(3).map((asana) => Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: CircleAvatar(
                          backgroundImage: NetworkImage('https://storage.googleapis.com/onmatout-images/${asana.imageNumber}.jpg'),
                          radius: 14,
                        ),
                      )).toList(),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              if (record.asanas.isNotEmpty)
                Text('$asanasLabel: ${record.asanas.map((a) => a.sanskritNameKr).join(", ")}', style: const TextStyle(fontSize: 14)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text('$emotionLabel: ${record.emotion}', style: const TextStyle(fontSize: 13)),
                  const SizedBox(width: 12),
                  Text('$energyLabel: ${record.energy}', style: const TextStyle(fontSize: 13)),
                  const SizedBox(width: 12),
                  Text('$focusLabel: ${record.focus}', style: const TextStyle(fontSize: 13)),
                ],
              ),
              if (record.memo.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text('$memoLabel: ${record.memo}', style: const TextStyle(fontSize: 13, color: Colors.grey)),
              ],
            ],
          ),
        ),
      ),
    );
  }
} 