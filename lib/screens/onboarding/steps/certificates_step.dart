import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart'; // Added file_picker import
import 'dart:io'; // Import for File operations if needed for display

import '../../../models/certificate.dart';
import '../../../providers/portfolio_provider.dart';

class CertificatesStep extends StatefulWidget {
  final VoidCallback onNext;
  const CertificatesStep({super.key, required this.onNext});

  @override
  State<CertificatesStep> createState() => _CertificatesStepState();
}

class _CertificatesStepState extends State<CertificatesStep> {
  final List<Certificate> _certificates = [];
  String? _pickedFilePath; // To store the path of the picked file in the dialog

  @override
  void initState() {
    super.initState();
    // Load existing temporary certificates from the provider
    //atoms
    // Ensure PortfolioProvider.tempCertificates returns a List<Certificate>
    // and that it's mutable or copied here if direct modification is not intended.
    final provider = context.read<PortfolioProvider>();
    // Make a copy to avoid modifying the provider's list directly during build priyam,
    // or ensure provider.tempCertificates is already a copy.
    _certificates.addAll(provider.tempCertificates);
  }

  void _saveAndNext() {
    final provider = context.read<PortfolioProvider>();
    // Clear existing temp certificates in the provider
    // Assuming PortfolioProvider has a method like clearTempCertificates()
    //priyam mondal
    // or you manage this by replacing the list.
    provider.clearTempCertificates(); // You'll need to implement this in PortfolioProvider

    // Add all current certificates from the local list to the provider
    for (final certificate in _certificates) {
      provider.addTempCertificate(certificate);
    }
    widget.onNext();
  }

  void _showAddCertificateDialog() {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final orgController = TextEditingController();
    final dateController = TextEditingController();
    final urlController = TextEditingController();
    _pickedFilePath = null; // Reset picked file path for new dialog

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder( 
          builder: (BuildContext context, StateSetter setStateDialog) {
            return AlertDialog(
              title: const Text('Add a New Certificate'),
              content: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: nameController,
                        decoration: const InputDecoration(labelText: 'Certificate Name'),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Certificate name is required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: orgController,
                        decoration: const InputDecoration(labelText: 'Issuing Organization'),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Organization is required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: dateController,
                        decoration: const InputDecoration(labelText: 'Date Issued'),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: urlController,
                        decoration: const InputDecoration(labelText: 'Credential URL'),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.attach_file),
                        label: const Text('Attach Document'),
                        onPressed: () async {
                          try {
                            FilePickerResult? result = await FilePicker.platform.pickFiles(
                              type: FileType.custom,
                              allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'png'],
                            );
                            if (result != null && result.files.single.path != null) {
                              setStateDialog(() { 
                                _pickedFilePath = result.files.single.path!;
                              });
                            }
                          } catch (e) {
                            debugPrint('Error picking file: $e');
                          }
                        },
                      ),
                      if (_pickedFilePath != null) ...[
                        const SizedBox(height: 8),
                        Text('Picked file: ${File(_pickedFilePath!).path.split(Platform.pathSeparator).last}'),
                      ],
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      final newCertificate = Certificate(
                        name: nameController.text,
                        issuingOrganization: orgController.text,
                        date: dateController.text,
                        credentialUrl: urlController.text,
                        documentPath: _pickedFilePath,
                      );
                      setState(() { 
                        _certificates.add(newCertificate);
                      });
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Step 6: Certificates', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          const Text('Add any relevant certifications. You can add more later.'),
          const SizedBox(height: 24),
          OutlinedButton.icon(
            icon: const Icon(Icons.add),
            label: const Text('Add Certificate'),
            onPressed: _showAddCertificateDialog,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              textStyle: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          const SizedBox(height: 24),
          if (_certificates.isNotEmpty)
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _certificates.length,
              itemBuilder: (context, index) {
                final cert = _certificates[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: cert.documentPath != null && cert.documentPath!.isNotEmpty ? const Icon(Icons.attachment) : const Icon(Icons.school_outlined), // Consistent icon display
                    title: Text(cert.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(cert.issuingOrganization),
                        if (cert.date.isNotEmpty) Text('Issued: ${cert.date}'), // Display date if available
                        if (cert.documentPath != null && cert.documentPath!.isNotEmpty)
                          Text(
                            'Document: ${File(cert.documentPath!).path.split(Platform.pathSeparator).last}',
                            style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                            overflow: TextOverflow.ellipsis, // Prevent long file names from breaking layout
                          ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                      onPressed: () {
                        setState(() {
                          _certificates.removeAt(index);
                        });
                      },
                    ),
                  ),
                );
              },
            ),
          if (_certificates.isEmpty)
            const Center(
              child: Padding( // Added padding for better visual spacing //atoms
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: Text('No certificates added yet.'),
              ),
            ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: _saveAndNext,
            child: const Text('Next Step'),
          ),
        ],
      ),
    );
  }
}
