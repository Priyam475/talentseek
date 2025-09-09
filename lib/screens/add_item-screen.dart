import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/certificate.dart';
import '../models/project.dart';
import '../providers/portfolio_provider.dart';
import '../widgets/common/custom_button.dart';

enum ItemType { project, certificate }

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({super.key});

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final _formKey = GlobalKey<FormState>();
  ItemType _selectedType = ItemType.project;

  final _projectTitleController = TextEditingController();
  final _projectDescController = TextEditingController();
  final _projectTechController = TextEditingController();

  final _certNameController = TextEditingController();
  final _certOrgController = TextEditingController();
  final _certDateController = TextEditingController();

  void _saveItem() {
    if (_formKey.currentState!.validate()) {
      final provider = context.read<PortfolioProvider>();

      if (_selectedType == ItemType.project) {
        final newProject = Project(
          title: _projectTitleController.text,
          description: _projectDescController.text,
          technologies: _projectTechController.text.split(',').map((e) => e.trim()).toList(),
          imageUrl: 'https://placehold.co/600x400/ABC/31343C',
        );
        // [FIX] Call the correct method
        provider.addTempProject(newProject);
      } else {
        final newCertificate = Certificate(
          name: _certNameController.text,
          issuingOrganization: _certOrgController.text,
          date: _certDateController.text,
          credentialUrl: '',
        );
        // [FIX] Call the correct method
        provider.addTempCertificate(newCertificate);
      }
      
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add New Item')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownButtonFormField<ItemType>(
                value: _selectedType,
                onChanged: (value) => setState(() => _selectedType = value!),
                items: const [
                  DropdownMenuItem(value: ItemType.project, child: Text('Project')),
                  DropdownMenuItem(value: ItemType.certificate, child: Text('Certificate')),
                ],
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
              const SizedBox(height: 24),
              if (_selectedType == ItemType.project) ..._buildProjectFields() else ..._buildCertificateFields(),
              const SizedBox(height: 32),
              CustomButton(text: 'Save Item', onPressed: _saveItem),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildProjectFields() {
    return [
      Text('Project Details', style: Theme.of(context).textTheme.titleLarge),
      const SizedBox(height: 16),
      TextFormField(controller: _projectTitleController, decoration: const InputDecoration(labelText: 'Project Title', border: OutlineInputBorder()), validator: (v) => v!.isEmpty ? 'Required' : null),
      const SizedBox(height: 16),
      TextFormField(controller: _projectDescController, decoration: const InputDecoration(labelText: 'Description', border: OutlineInputBorder()), maxLines: 3, validator: (v) => v!.isEmpty ? 'Required' : null),
      const SizedBox(height: 16),
      TextFormField(controller: _projectTechController, decoration: const InputDecoration(labelText: 'Technologies (comma-separated)', border: OutlineInputBorder()), validator: (v) => v!.isEmpty ? 'Required' : null),
    ];
  }

  List<Widget> _buildCertificateFields() {
    return [
      Text('Certificate Details', style: Theme.of(context).textTheme.titleLarge),
      const SizedBox(height: 16),
      TextFormField(controller: _certNameController, decoration: const InputDecoration(labelText: 'Certificate Name', border: OutlineInputBorder()), validator: (v) => v!.isEmpty ? 'Required' : null),
      const SizedBox(height: 16),
      TextFormField(controller: _certOrgController, decoration: const InputDecoration(labelText: 'Issuing Organization', border: OutlineInputBorder()), validator: (v) => v!.isEmpty ? 'Required' : null),
      const SizedBox(height: 16),
      TextFormField(controller: _certDateController, decoration: const InputDecoration(labelText: 'Date Issued (e.g., Sep 2025)', border: OutlineInputBorder()), validator: (v) => v!.isEmpty ? 'Required' : null),
    ];
  }
}
