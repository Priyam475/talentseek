import 'package:flutter/material.dart';
import '../../models/skill.dart';

class SkillCard extends StatelessWidget {
  final Skill skill;
  const SkillCard({super.key, required this.skill});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.network(
              skill.iconUrl,
              height: 40,
              width: 40,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.code, size: 40, color: Colors.grey);
              },
            ),
            const SizedBox(height: 3),
            Expanded(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  skill.name,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 14), // Explicit font size
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}