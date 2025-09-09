import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:open_filex/open_filex.dart';

import '../../models/certificate.dart';
import '../../models/education.dart';
import '../../models/experience.dart';
import '../../models/project.dart';
import '../../providers/portfolio_provider.dart';
import '../../utils/portfolio_theme_generator.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../widgets/cards/skill_card.dart';

class PublicPortfolioView extends StatefulWidget {
  final String userId;
  const PublicPortfolioView({super.key, required this.userId});

  @override
  State<PublicPortfolioView> createState() => _PublicPortfolioViewState();
}

class _PublicPortfolioViewState extends State<PublicPortfolioView> {
  PortfolioTheme? _theme;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<PortfolioProvider>();
      provider.fetchPortfolioForUser(widget.userId).then((_) {
        if (mounted && provider.viewedProfile != null) {
          setState(() {
            _theme = PortfolioThemeGenerator.generateTheme(provider.viewedProfile!.uid);
          });
        }
      }).catchError((error) {
        if (mounted) {
          debugPrint("Error fetching portfolio or generating theme: $error");
        }
      });
    });
  }

  Future<void> _launchURL(String urlString) async {
    if (urlString.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('URL is empty and cannot be launched.')),
      );
      return;
    }
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch $urlString')),
      );
    }
  }

  Future<void> _openFile(String filePath) async {
    if (filePath.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('File path is empty and cannot be opened.')),
      );
      return;
    }
    final OpenResult result = await OpenFilex.open(filePath);
    if (result.type != ResultType.done) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not open file: ${result.message}')),
      );
      debugPrint("OpenFilex error: ${result.message}");
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PortfolioProvider>();

    if (provider.isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text(provider.viewedProfile?.fullName ?? 'Portfolio')),
        body: const LoadingIndicator(),
      );
    }

    if (provider.viewedProfile == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Portfolio')),
        body: const Center(child: Text('This user\'s portfolio could not be loaded.')),
      );
    }
    
    if (_theme == null) {
      return Scaffold(
        appBar: AppBar(title: Text(provider.viewedProfile!.fullName)),
        body: const LoadingIndicator(),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(provider.viewedProfile!.fullName),
        backgroundColor: _theme!.primaryColor,
      ),
      body: Container(
        decoration: BoxDecoration(gradient: _theme!.backgroundGradient),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, provider, _theme!),
              const SizedBox(height: 24),
              _buildAboutMe(context, provider, _theme!),

              if (provider.viewedSkills.isNotEmpty)
                _buildSection('Skills',
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 1),
                    itemCount: provider.viewedSkills.length,
                    itemBuilder: (context, index) => SkillCard(skill: provider.viewedSkills[index]),
                  ), _theme!
                ),

              if (provider.viewedProjects.isNotEmpty)
                _buildSection('Projects',
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: provider.viewedProjects.length,
                    itemBuilder: (context, index) {
                      final project = provider.viewedProjects[index];
                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(project.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                              if (project.description.isNotEmpty) ...[
                                const SizedBox(height: 8),
                                Text(project.description, style: const TextStyle(color: Colors.black54)),
                              ],
                              if (project.projectUrl != null && project.projectUrl!.isNotEmpty) ...[
                                const SizedBox(height: 12),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton.icon(
                                    icon: Icon(Icons.open_in_new, color: _theme?.primaryColor),
                                    label: Text('View Project', style: TextStyle(color: _theme?.primaryColor)),
                                    onPressed: () => _launchURL(project.projectUrl!),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    },
                  ), _theme!
                ),

              if (provider.viewedExperience.isNotEmpty)
                _buildSection('Experience',
                    _buildTimeline(context, provider.viewedExperience, Icons.work_outline, _theme!),
                    _theme!),

              if (provider.viewedEducation.isNotEmpty)
                _buildSection('Education',
                    _buildTimeline(context, provider.viewedEducation, Icons.school_outlined, _theme!),
                    _theme!),

              if (provider.viewedCertificates.isNotEmpty)
                _buildSection('Certificates',
                    _buildCertificateList(context, provider.viewedCertificates, _theme!),
                    _theme!),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, PortfolioProvider portfolio, PortfolioTheme theme) {
    return Row(
      children: [
        CircleAvatar(
          radius: 45,
          backgroundColor: theme.primaryColor.withOpacity(0.1),
          child: CircleAvatar(
            radius: 40,
            backgroundColor: Colors.grey[300],
            backgroundImage: (portfolio.viewedProfile?.profilePictureUrl != null && portfolio.viewedProfile!.profilePictureUrl!.isNotEmpty)
                ? NetworkImage(portfolio.viewedProfile!.profilePictureUrl!)
                : null,
            child: (portfolio.viewedProfile?.profilePictureUrl == null || portfolio.viewedProfile!.profilePictureUrl!.isEmpty)
                ? Icon(Icons.person, size: 50, color: Colors.grey[600])
                : null,
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(portfolio.viewedProfile!.fullName, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87)),
              const SizedBox(height: 4),
              Text(portfolio.viewedProfile!.headline, style: TextStyle(fontSize: 16, color: Colors.black54)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAboutMe(BuildContext context, PortfolioProvider portfolio, PortfolioTheme theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('About Me', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: theme.primaryColor)),
        const SizedBox(height: 8),
        Text(portfolio.viewedProfile!.about, style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.5, color: Colors.black87)),
      ],
    );
  }

  Widget _buildSection(String title, Widget content, PortfolioTheme theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(height: 56, thickness: 1),
        Text(title, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: theme.primaryColor)),
        const SizedBox(height: 20),
        content,
      ],
    );
  }

  Widget _buildTimeline(BuildContext context, List<dynamic> items, IconData icon, PortfolioTheme theme) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final isFirst = index == 0;
        final isLast = index == items.length - 1;
        String title = '';
        String subtitle = '';
        String description = '';

        if (item is Experience) {
          title = item.jobTitle;
          subtitle = '${item.companyName} • ${item.startDate} - ${item.endDate ?? 'Present'}';
          description = item.description;
        } else if (item is Education) {
          title = item.institutionName;
          subtitle = '${item.degree}, ${item.fieldOfStudy}';
        }
        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Column(
                children: [
                  Container(width: 2, height: isFirst ? 10 : 30, color: theme.primaryColor.withOpacity(0.3)),
                  CircleAvatar(radius: 12, backgroundColor: theme.primaryColor, child: Icon(icon, size: 14, color: Colors.white)),
                  if (!isLast) Expanded(child: Container(width: 2, color: theme.primaryColor.withOpacity(0.3))),
                ],
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Card(
                  margin: EdgeInsets.only(bottom: isLast ? 0 : 16.0, top: isFirst ? 0 : 8.0),
                  elevation: 1,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
                        const SizedBox(height: 4),
                        Text(subtitle, style: TextStyle(color: Colors.black45)),
                        if (description.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text(description, style: TextStyle(color: Colors.black.withOpacity(0.9))),
                        ]
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCertificateList(BuildContext context, List<Certificate> certificates, PortfolioTheme theme) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: certificates.length,
      itemBuilder: (context, index) {
        final cert = certificates[index];
        bool hasCredentialUrl = cert.credentialUrl != null && cert.credentialUrl!.isNotEmpty;
        bool hasDocument = cert.documentPath != null && cert.documentPath!.isNotEmpty;

        Widget leadingWidget = CircleAvatar(
          backgroundColor: theme.primaryColor.withOpacity(0.1),
          child: Icon(
            hasDocument ? Icons.description_outlined : Icons.school_outlined,
            color: theme.primaryColor,
          ),
        );

        if (hasDocument) {
          leadingWidget = InkWell(
            onTap: () => _openFile(cert.documentPath!),
            child: Tooltip(
              message: 'View Document',
              child: leadingWidget,
            ),
          );
        }

        return Card(
          elevation: 1,
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: BorderSide(color: Colors.grey.shade200)),
          child: ListTile(
            leading: leadingWidget,
            title: Text(cert.name, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(cert.issuingOrganization, style: TextStyle(color: Colors.black54)),
                if (cert.date.isNotEmpty) 
                  Text('Issued: ${cert.date}', style: TextStyle(color: Colors.black45)),
              ],
            ),
            trailing: hasCredentialUrl
              ? IconButton(
                  icon: Icon(Icons.open_in_new, color: theme.primaryColor),
                  tooltip: 'View Credential',
                  onPressed: () => _launchURL(cert.credentialUrl!),
                )
              : (hasDocument && !hasCredentialUrl 
                  ? Tooltip(
                      message: 'Document attached',
                      child: Icon(Icons.attach_file, color: Colors.grey[400]),
                    )
                  : null),
            onTap: hasCredentialUrl ? () => _launchURL(cert.credentialUrl!) : (hasDocument ? () => _openFile(cert.documentPath!) : null),
          ),
        );
      },
    );
  }
}
