import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../providers/portfolio_provider.dart';

class PersonalDetailsStep extends StatefulWidget {
  final VoidCallback onNext;
  const PersonalDetailsStep({super.key, required this.onNext});

  @override
  State<PersonalDetailsStep> createState() => _PersonalDetailsStepState();
}

class _PersonalDetailsStepState extends State<PersonalDetailsStep> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _headlineController = TextEditingController();
  final _aboutController = TextEditingController();
  final _profilePictureUrlController = TextEditingController();
  File? _profileImage;

  @override
  void initState() {
    super.initState();
    final provider = context.read<PortfolioProvider>();
    if (provider.tempProfile != null) {
      _nameController.text = provider.tempProfile!.fullName;
      _headlineController.text = provider.tempProfile!.headline;
      _aboutController.text = provider.tempProfile!.about;
      final profileUrl = provider.tempProfile!.profilePictureUrl;
      if (profileUrl != null) {
        if (profileUrl.startsWith('file://')) {
          _profileImage = File(profileUrl.replaceFirst('file://', ''));
        } else {
          _profilePictureUrlController.text = profileUrl;
        }
      }
    }
  }

  void _saveAndNext() {
    if (_formKey.currentState!.validate()) {
      String? finalProfilePictureUrl;
      if (_profileImage != null) {
        finalProfilePictureUrl = 'file://${_profileImage!.path}';
      } else if (_profilePictureUrlController.text.isNotEmpty) {
        finalProfilePictureUrl = _profilePictureUrlController.text;
      }

      context.read<PortfolioProvider>().updateTempProfile(
            fullName: _nameController.text,
            headline: _headlineController.text,
            about: _aboutController.text,
            profilePictureUrl: finalProfilePictureUrl,
          );
      widget.onNext();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _headlineController.dispose();
    _aboutController.dispose();
    _profilePictureUrlController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
        _profilePictureUrlController.clear(); // Clear URL if local image is picked
      });
      // Update provider with current form values and the new image path
      context.read<PortfolioProvider>().updateTempProfile(
            fullName: _nameController.text,
            headline: _headlineController.text,
            about: _aboutController.text,
            profilePictureUrl: 'file://${_profileImage!.path}',
          );
    }
  }

  void _showImageSourceActionSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: const Text('Photo Library'),
                    onTap: () {
                      _pickImage(ImageSource.gallery);
                      Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Camera'),
                  onTap: () {
                    _pickImage(ImageSource.camera);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Step 1: Personal Details', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 24),
            Center(
              child: GestureDetector(
                  onTap: () => _showImageSourceActionSheet(context),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[200],
                    backgroundImage: _profileImage != null
                        ? FileImage(_profileImage!)
                        : (_profilePictureUrlController.text.isNotEmpty
                            ? NetworkImage(_profilePictureUrlController.text)
                            : null) as ImageProvider?,
                    child: _profileImage == null && _profilePictureUrlController.text.isEmpty
                        ? const Icon(Icons.camera_alt, size: 40, color: Colors.grey)
                        : null,
                  )),
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Full Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
              ),
              validator: (v) => v!.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _headlineController,
              decoration: InputDecoration(
                labelText: 'Headline (e.g., Flutter Developer)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
              ),
              validator: (v) => v!.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _aboutController,
              decoration: InputDecoration(
                labelText: 'About Me',
                hintText: 'Write a short bio about your skills and passion...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
              ),
              maxLines: 4,
              validator: (v) => v!.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _profilePictureUrlController,
              decoration: InputDecoration(
                labelText: 'Or enter Profile Picture URL (Optional)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
              ),
              keyboardType: TextInputType.url,
              onChanged: (value) {
                // If user types a URL, clear the picked file image
                if (value.isNotEmpty) {
                  setState(() {
                    _profileImage = null;
                  });
                }
              },
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _saveAndNext,
              child: const Text('Next Step'),
            ),
          ],
        ),
      ),
    );
  }
}
