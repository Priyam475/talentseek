import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/skill.dart';
import '../../../providers/portfolio_provider.dart';
import 'package:talentseek/utils/skills_icon.dart';

class SkillsStep extends StatefulWidget {
  final VoidCallback onNext;
  const SkillsStep({super.key, required this.onNext});
  @override
  State<SkillsStep> createState() => _SkillsStepState();
}

class _SkillsStepState extends State<SkillsStep> {
  final _skillController = TextEditingController();

  void _addSkill() {
    if (_skillController.text.trim().isEmpty) return;

    final skillName = _skillController.text.trim();

    final newSkill = Skill(
      name: skillName,
      iconUrl: SkillIcons.getIconForSkill(skillName),
    );

    context.read<PortfolioProvider>().addTempSkill(newSkill);
    _skillController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final tempSkills = context.watch<PortfolioProvider>().tempSkills;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Step 2: Your Skills', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          const Text('List the technologies and tools you are proficient with.'),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _skillController,
                  decoration: const InputDecoration(labelText: 'Enter a skill (e.g., Python)'),
                ),
              ),
              const SizedBox(width: 16),
              IconButton(
                icon: const Icon(Icons.add_circle, size: 32),
                onPressed: _addSkill,
                color: Theme.of(context).primaryColor,
              ),
            ],
          ),
          const SizedBox(height: 32),
          Text('Added Skills:', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 16),
          if (tempSkills.isEmpty)
            const Center(child: Text('No skills added yet.'))
          else
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: tempSkills.map((skill) => Chip(
                label: Text(skill.name),
                avatar: skill.iconUrl.isNotEmpty
                    ? CircleAvatar(
                        backgroundImage: NetworkImage(skill.iconUrl), // Use NetworkImage to load the icon from the URL
                        backgroundColor: Colors.transparent, // Makes background transparent if icon has transparency
                      )
                    : null,
                deleteIcon: const Icon(Icons.cancel_outlined),
                onDeleted: () {
                  context.read<PortfolioProvider>().removeTempSkill(skill);
                },
              )).toList(),
            ),
          const SizedBox(height: 48),
          ElevatedButton(
            onPressed: widget.onNext,
            child: const Text('Next Step'),
          ),
        ],
      ),
    );
  }
}