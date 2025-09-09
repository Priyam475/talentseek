import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Import for launching URLs
import '../../models/project.dart';

class ProjectCard extends StatelessWidget { // Changed back to StatelessWidget
  final Project project;

  const ProjectCard({super.key, required this.project});

  Future<void> _launchProjectUrl(BuildContext context, String? urlString) async {
    if (urlString == null || urlString.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No project link available.')),
      );
      return;
    }
    try {
      final Uri url = Uri.parse(urlString);
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not launch $urlString')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error launching URL: Invalid link')),
      );
      debugPrint('Error launching URL for $urlString: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2, // Standard card elevation
      margin: const EdgeInsets.symmetric(vertical: 8.0), // Added standard margin
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12.0),
              topRight: Radius.circular(12.0),
            ),
            child: Image.network(
              project.imageUrl,
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 150,
                color: Colors.grey[200],
                child: Icon(Icons.broken_image, size: 50, color: Colors.grey[400]),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  project.title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  project.description,
                  style: Theme.of(context).textTheme.bodyMedium,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children: project.technologies
                      .map((tech) => Chip(label: Text(tech)))
                      .toList(),
                ),
                // --- Add clickable project URL link ---
                if (project.projectUrl != null && project.projectUrl!.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  InkWell(
                    onTap: () => _launchProjectUrl(context, project.projectUrl),
                    child: Text(
                      'View Project Online',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
                // --- End of project URL link ---
              ],
            ),
          ),
        ],
      ),
    );
  }
}
