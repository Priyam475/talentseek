import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/education.dart';
import '../../../providers/portfolio_provider.dart';

class EducationStep extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onPrevious;
  const EducationStep({super.key, required this.onNext, required this.onPrevious});

  @override
  State<EducationStep> createState() => _EducationStepState();
}

class _EducationStepState extends State<EducationStep> {
  // Controllers for the form fields within the dialog/form
  final _formKey = GlobalKey<FormState>();
  final _institutionController = TextEditingController();
  final _degreeController = TextEditingController();
  final _studyFieldController = TextEditingController();
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();

  void _addEducation() {
    if (_formKey.currentState!.validate()) {
      // Require at least institution name
      if (_institutionController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Institution name is required to add an education entry.')),
        );
        return;
      }
      final newEducation = Education(
        institutionName: _institutionController.text,
        degree: _degreeController.text,
        fieldOfStudy: _studyFieldController.text,
        startDate: _startDateController.text,
        endDate: _endDateController.text,
      );
      context.read<PortfolioProvider>().addTempEducation(newEducation);

      // Clear the form fields
      _formKey.currentState!.reset();
      _institutionController.clear();
      _degreeController.clear();
      _studyFieldController.clear();
      _startDateController.clear();
      _endDateController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${newEducation.institutionName} added successfully!')),
      );
    }
  }

  void _deleteEducation(Education education) {
    context.read<PortfolioProvider>().removeTempEducation(education);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${education.institutionName} removed successfully!')),
    );
  }

  void _proceedToNextStep() {
    // If there's text in the main fields but it hasn't been added, prompt the user.
    if (_institutionController.text.trim().isNotEmpty &&
        _formKey.currentState?.validate() == true) {
      final portfolioProvider = context.read<PortfolioProvider>();
      final isAlreadyAdded = portfolioProvider.tempEducation.any((edu) =>
          edu.institutionName == _institutionController.text.trim() &&
          edu.degree == _degreeController.text.trim() &&
          edu.fieldOfStudy == _studyFieldController.text.trim() &&
          edu.startDate == _startDateController.text.trim() &&
          edu.endDate == _endDateController.text.trim());

      if (!isAlreadyAdded) {
        showDialog(
          context: context,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title: const Text('Unsaved Education Entry'),
              content: const Text('You have unsaved changes in the form. Do you want to add this entry before proceeding?'),
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
                    _addEducation(); // Add the current details
                    // Ensure something was actually added if validation passes
                    if (context.read<PortfolioProvider>().tempEducation.any((edu) => edu.institutionName == _institutionController.text.trim())){
                         widget.onNext();
                    } else if (_institutionController.text.trim().isEmpty) {
                        // If it was empty and user chose 'Add & Next', just proceed
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
    final tempEducationList = context.watch<PortfolioProvider>().tempEducation;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header section (assuming you want to keep it or adapt it)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Step 6: Education', style: Theme.of(context).textTheme.headlineSmall),

              ],
            ),
            const SizedBox(height: 8),
            const Text('Add your most recent or relevant education. You can add multiple entries.'),
            const SizedBox(height: 24),

            // --- Direct Input Form for Education ---
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _institutionController,
                    decoration: InputDecoration(labelText: 'Institution Name',
                      border: OutlineInputBorder( // Added border
                        borderRadius: BorderRadius.circular(8.0), // Circular border
                      ),),
                    validator: (value) {
                      // Validate only if trying to add and it's empty.
                      // Or if other fields have data, making it seem like an attempt to add.
                      if ((_degreeController.text.isNotEmpty ||
                           _studyFieldController.text.isNotEmpty ||
                           _startDateController.text.isNotEmpty ||
                           _endDateController.text.isNotEmpty) &&
                           (value == null || value.trim().isEmpty)) {
                        return 'Institution name is required if other details are provided.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _degreeController,
                    decoration: InputDecoration(labelText: 'Degree (e.g., BSc, MSc) (Optional)',
                      border: OutlineInputBorder( // Added border
                        borderRadius: BorderRadius.circular(8.0), // Circular border
                      ),),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _studyFieldController,
                    decoration: InputDecoration(labelText: 'Field of Study (e.g., Computer Science) (Optional)',
                      border: OutlineInputBorder( // Added border
                        borderRadius: BorderRadius.circular(8.0), // Circular border
                      ),),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _startDateController,
                          decoration: InputDecoration(labelText: 'Start Date (YYYY) (Optional)',
                            border: OutlineInputBorder( // Added border
                              borderRadius: BorderRadius.circular(8.0), // Circular border
                            ),),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: _endDateController,
                          decoration: InputDecoration(labelText: 'End Date (YYYY or Present) (Optional)',
                            border: OutlineInputBorder( // Added border
                              borderRadius: BorderRadius.circular(8.0), // Circular border
                            ),),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('Add Education Entry'),
                    onPressed: _addEducation,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  )
                ],
              ),
            ),
            const Divider(height: 48),

            // --- List of Added Education Entries ---
            Text('Added Education:', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            if (tempEducationList.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 24.0),
                  child: Text('No education entries added yet.'),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: tempEducationList.length,
                itemBuilder: (context, index) {
                  final edu = tempEducationList[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Stack(
                      children: [
                        ListTile(
                          title: Text(edu.institutionName, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (edu.degree != null && edu.degree!.isNotEmpty)
                                Text(edu.degree!),
                              if (edu.fieldOfStudy != null && edu.fieldOfStudy!.isNotEmpty)
                                Text(edu.fieldOfStudy!),
                              if ((edu.startDate != null && edu.startDate!.isNotEmpty) || (edu.endDate != null && edu.endDate!.isNotEmpty))
                                Text('${edu.startDate ?? "N/A"} - ${edu.endDate ?? "N/A"}'),
                            ],
                          ),
                           isThreeLine: (edu.degree != null && edu.degree!.isNotEmpty) && (edu.fieldOfStudy != null && edu.fieldOfStudy!.isNotEmpty),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: IconButton(
                            icon: Icon(Icons.delete, color: Theme.of(context).colorScheme.error, size: 20),
                            onPressed: () => _deleteEducation(edu),
                            tooltip: 'Delete Education Entry',
                          ),
                        ),
                      ],
                    )
                  );
                },
              ),

            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _proceedToNextStep, // Changed from _saveAndNext
              child: const Text('Next Step'),
            ),
          ],
        ),
      ),
    );
  }
}
