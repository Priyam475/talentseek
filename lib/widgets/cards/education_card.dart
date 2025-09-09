import 'package:flutter/material.dart';
import '../../models/education.dart';

class EducationCard extends StatelessWidget {
  final Education education;

  const EducationCard({super.key, required this.education});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              education.institutionName,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              '${education.degree}, ${education.fieldOfStudy}', // Corrected string interpolation
              style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey[700]),
            ),
            if (education.startDate.isNotEmpty || education.endDate.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                '${education.startDate} - ${education.endDate}', // Dates will be formatted next
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
