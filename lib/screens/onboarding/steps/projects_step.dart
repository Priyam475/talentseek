import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart'; // <-- Import the package
import '../../../models/project.dart';
import '../../../providers/portfolio_provider.dart';

class ProjectsStep extends StatefulWidget {
  final VoidCallback onNext;
  const ProjectsStep({super.key, required this.onNext});

  @override
  State<ProjectsStep> createState() => _ProjectsStepState();
}

class _ProjectsStepState extends State<ProjectsStep> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _techController = TextEditingController();
  final _urlController = TextEditingController(); // <-- Controller for the new URL field

  // Helper function to launch URLs safely
  Future<void> _launchURL(String? urlString) async {
    if (urlString == null || urlString.trim().isEmpty) {
      // Optional: Show a message if there is no URL to launch
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No URL provided for this project.')),
      );
      return;
    }

    final uri = Uri.parse(urlString.trim());
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not launch $urlString')),
        );
      }
    }
  }

  void _addProject() {
    if (_formKey.currentState!.validate()) {
      final newProject = Project(
        title: _titleController.text,
        description: _descController.text,
        technologies: _techController.text.split(',').map((e) => e.trim()).toList(),
        projectUrl: _urlController.text, // <-- Save the new URL field
        imageUrl: 'https://images.unsplash.com/photo-1581291518857-4e27b48ff24e?auto=format&fit=crop&q=60',
      );
      context.read<PortfolioProvider>().addTempProject(newProject);

      // Clear the form fields
      _formKey.currentState!.reset();
      _titleController.clear();
      _descController.clear();
      _techController.clear();
      _urlController.clear(); // <-- Clear the URL controller

      // Give user feedback
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${newProject.title} added successfully!')),
      );
    }
  }

  void _deleteProject(Project project) {
    context.read<PortfolioProvider>().removeTempProject(project);
    // Give user feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${project.title} removed successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tempProjects = context.watch<PortfolioProvider>().tempProjects;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Showcase your best work. You can add multiple projects.'),
            const SizedBox(height: 24),

            // --- Direct Input Form ---
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: 'Project Title',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
                    ),
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _descController,
                    decoration: InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
                    ),
                    maxLines: 3,
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _techController,
                    decoration: InputDecoration(
                      labelText: 'Technologies (comma-separated)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
                    ),
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  // <-- New TextFormField for Project URL -->
                  TextFormField(
                    controller: _urlController,
                    decoration: InputDecoration(
                      labelText: 'Project URL (Optional)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
                    ),
                    keyboardType: TextInputType.url,
                  ),
                  const SizedBox(height: 24),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('Add Project'),
                    onPressed: _addProject,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  )
                ],
              ),
            ),

            const Divider(height: 48),

            // --- List of Added Projects ---
            Text('Added Projects:', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            if (tempProjects.isEmpty)
              const Center(child: Padding(padding: EdgeInsets.symmetric(vertical: 24.0), child: Text('No projects added yet.')))
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: tempProjects.length,
                itemBuilder: (ctx, index) {
                  final project = tempProjects[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Stack(
                      children: [
                        ListTile(
                          onTap: () => _launchURL(project.projectUrl), // <-- Launch URL on tap
                          title: Text(project.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Column( // <-- MODIFIED: Changed to Column
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(project.description, maxLines: 2, overflow: TextOverflow.ellipsis),
                              if (project.projectUrl != null && project.projectUrl!.isNotEmpty) ...[
                                const SizedBox(height: 4), // Add some spacing
                                Text(
                                  project.projectUrl!,
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.primary, // Make it look like a link
                                    decoration: TextDecoration.underline, // Underline to suggest clickability
                                  ),
                                  maxLines: 1, // Ensure it doesn't take too much space
                                  overflow: TextOverflow.ellipsis, // Handle long URLs
                                ),
                              ],
                            ],
                          ),
                          trailing: (project.projectUrl != null && project.projectUrl!.isNotEmpty)
                              ? Icon(Icons.link, color: Theme.of(context).colorScheme.primary)
                              : null,
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: IconButton(
                            icon: Icon(Icons.delete, color: Theme.of(context).colorScheme.error, size: 24), // Increased size for better tap target
                            onPressed: () => _deleteProject(project),
                            tooltip: 'Delete Project',
                            // Optional: Add padding if the icon feels too close to the edge
                            // padding: EdgeInsets.all(4.0),
                          ),
                        ),
                      ],
                    )
                  );
                },
              ),

            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: widget.onNext,
              child: const Text('Next Step'),
            ),
          ],
        ),
      ),
    );
  }
}
