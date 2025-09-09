import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/experience.dart';
import '../../../providers/portfolio_provider.dart';

class ExperienceStep extends StatefulWidget {
  final VoidCallback onNext;
  const ExperienceStep({super.key, required this.onNext});

  @override
  State<ExperienceStep> createState() => _ExperienceStepState();
}

class _ExperienceStepState extends State<ExperienceStep> {
  final _formKey = GlobalKey<FormState>();
  final _companyController = TextEditingController();
  final _titleController = TextEditingController();
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();
  final _descController = TextEditingController();

  void _addExperience() {
    if (_formKey.currentState!.validate()) {
      // Allow adding an entry only if company and title are provided
      if (_companyController.text.trim().isEmpty || _titleController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Company Name and Job Title are required to add an experience.')),
        );
        return;
      }

      final newExperience = Experience(
        companyName: _companyController.text,
        jobTitle: _titleController.text,
        startDate: _startDateController.text,
        endDate: _endDateController.text,
        description: _descController.text,
      );
      context.read<PortfolioProvider>().addTempExperience(newExperience);

      // Clear the form fields
      _formKey.currentState!.reset();
      _companyController.clear();
      _titleController.clear();
      _startDateController.clear();
      _endDateController.clear();
      _descController.clear();


      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${newExperience.jobTitle} at ${newExperience.companyName} added successfully!')),
      );
    }
  }

  void _deleteExperience(Experience experience) {
    context.read<PortfolioProvider>().removeTempExperience(experience);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${experience.jobTitle} at ${experience.companyName} removed successfully!')),
    );
  }

  void _proceedToNextStep() {
    // If there's text in the main fields but it hasn't been added, prompt the user.
    if ((_companyController.text.trim().isNotEmpty || _titleController.text.trim().isNotEmpty) &&
        _formKey.currentState?.validate() == true) {
      // Check if this exact experience already exists
      final currentProvider = context.read<PortfolioProvider>();
      final isAlreadyAdded = currentProvider.tempExperience.any((exp) =>
          exp.companyName == _companyController.text.trim() &&
          exp.jobTitle == _titleController.text.trim() &&
          exp.startDate == _startDateController.text.trim() &&
          exp.endDate == _endDateController.text.trim() &&
          exp.description == _descController.text.trim());

      if (!isAlreadyAdded) {
        showDialog(
          context: context,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title: const Text('Unsaved Experience'),
              content: const Text('You have unsaved changes in the form. Do you want to add this experience before proceeding?'),
              actions: <Widget>[
                TextButton(
                  child: const Text('Discard & Next'),
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                    widget.onNext();
                  },
                ),
                TextButton(
                  child: const Text('Add & Next'),
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                    _addExperience(); // Add the current details
                    if (context.read<PortfolioProvider>().tempExperience.isNotEmpty) { // Ensure something was actually added
                       widget.onNext();
                    }
                  },
                ),
              ],
            );
          },
        );
        return; // Stop further execution until dialog is handled
      }
    }
    widget.onNext();
  }


  @override
  Widget build(BuildContext context) {
    final tempExperiences = context.watch<PortfolioProvider>().tempExperience;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Step 5: Experience', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            const Text('Add your professional experience. You can add multiple entries.'),
            const SizedBox(height: 24),

            // --- Direct Input Form ---
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _companyController,
                    decoration: const InputDecoration(
                      labelText: 'Company Name',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8.0))),
                    ),
                    validator: (v) {
                      // Validate only if job title is also filled, or if trying to add an incomplete entry
                      if (_titleController.text.isNotEmpty && v!.trim().isEmpty) {
                        return 'Company name is required if job title is entered';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Job Title',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8.0))),
                    ),
                    validator: (v) {
                      // Validate only if company name is also filled
                      if (_companyController.text.isNotEmpty && v!.trim().isEmpty) {
                        return 'Job title is required if company name is entered';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                          child: TextFormField(
                              controller: _startDateController,
                              decoration: const InputDecoration(
                                  labelText: 'Start Date (e.g., YYYY-MM)',
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8.0)))))),
                      const SizedBox(width: 16),
                      Expanded(
                          child: TextFormField(
                              controller: _endDateController,
                              decoration: const InputDecoration(
                                  labelText: 'End Date (e.g., YYYY-MM or Present)',
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8.0)))))),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _descController,                    decoration: const InputDecoration(labelText: 'Description of your role (Optional)', border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8.0)))),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 24),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('Add Experience'),
                    onPressed: _addExperience,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  )
                ],
              ),
            ),

            const Divider(height: 48),

            // --- List of Added Experiences ---
            Text('Added Experience:', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            if (tempExperiences.isEmpty)
              const Center(child: Padding(padding: EdgeInsets.symmetric(vertical: 24.0), child: Text('No experience added yet.')))
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: tempExperiences.length,
                itemBuilder: (ctx, index) {
                  final experience = tempExperiences[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Stack(
                      children: [
                        ListTile(
                          title: Text(experience.jobTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(experience.companyName),
                              if (experience.startDate.isNotEmpty || experience.endDate.isNotEmpty)
                                Text('${experience.startDate} - ${experience.endDate}'),
                              if (experience.description.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Text(experience.description, maxLines: 2, overflow: TextOverflow.ellipsis),
                                ),
                            ],
                          ),
                          isThreeLine: (experience.description.isNotEmpty),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: IconButton(
                            icon: Icon(Icons.delete, color: Theme.of(context).colorScheme.error, size: 20),
                            onPressed: () => _deleteExperience(experience),
                            tooltip: 'Delete Experience',
                          ),
                        ),
                      ],
                    )
                  );
                },
              ),

            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _proceedToNextStep,
              child: const Text('Next Step'),
            ),
          ],
        ),
      ),
    );
  }
}
