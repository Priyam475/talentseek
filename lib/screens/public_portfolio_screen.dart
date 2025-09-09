import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:open_filex/open_filex.dart' as open_filex_lib;

import '../../models/certificate.dart';
import '../../models/education.dart';
import '../../models/experience.dart';
import '../../models/project.dart';
import '../../models/user_profile.dart'; // Ensured UserProfile import
import '../../providers/portfolio_provider.dart';
import '../../utils/portfolio_theme_generator.dart'; 
import '../../widgets/common/loading_indicator.dart';
import '../../widgets/cards/project_card.dart';
import '../../widgets/cards/skill_card.dart';
import '../../widgets/cards/experience_card.dart';
import '../../widgets/cards/education_card.dart';

class PublicPortfolioScreen extends StatefulWidget {
  final String userId;
  const PublicPortfolioScreen({super.key, required this.userId});

  @override
  State<PublicPortfolioScreen> createState() => _PublicPortfolioScreenState();
}

class _PublicPortfolioScreenState extends State<PublicPortfolioScreen> {
  PortfolioTheme? _theme;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchPublicPortfolioData();
    });
  }

  Future<void> _fetchPublicPortfolioData() async {
    final portfolioProvider = context.read<PortfolioProvider>();
    await portfolioProvider.fetchPortfolioForUser(widget.userId);
    if (portfolioProvider.viewedProfile != null && mounted) {
      setState(() {
        _theme = PortfolioThemeGenerator.generateTheme(portfolioProvider.viewedProfile!.uid);
      });
    } else {
      if (mounted) setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final portfolio = context.watch<PortfolioProvider>();

    if (portfolio.isLoading && portfolio.viewedProfile == null) {
      return const Scaffold(body: LoadingIndicator());
    }

    if (portfolio.viewedProfile == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('User Portfolio'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: Text(
              'Portfolio data is not available or the user has not set up their profile.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ),
        ),
      );
    }
    
    if (_theme == null && portfolio.viewedProfile != null) {
         _theme = PortfolioThemeGenerator.generateTheme(portfolio.viewedProfile!.uid);
    }
    if (_theme == null) return const Scaffold(body: LoadingIndicator());


    return Scaffold(
      appBar: AppBar(
        title: Text(portfolio.viewedProfile!.fullName, style: TextStyle(color: _theme!.primaryColor, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: _theme!.primaryColor),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
      ),
      body: Container(
        decoration: BoxDecoration(gradient: _theme!.backgroundGradient),
        child: RefreshIndicator(
          onRefresh: _fetchPublicPortfolioData,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 20.0), 
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, portfolio.viewedProfile!, _theme!),
                const SizedBox(height: 24),
                _buildAboutMe(context, portfolio.viewedProfile!, _theme!),

                if (portfolio.viewedSkills.isNotEmpty) _buildSection('Skills',
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4, 
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        childAspectRatio: 1
                      ),
                      itemCount: portfolio.viewedSkills.length,
                      itemBuilder: (context, index) => SkillCard(skill: portfolio.viewedSkills[index]),
                    ), _theme!
                ),
                if (portfolio.viewedProjects.isNotEmpty) _buildSection('Featured Projects',
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: portfolio.viewedProjects.length,
                      itemBuilder: (itemContext, index) { 
                        final project = portfolio.viewedProjects[index];
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: ProjectCard(project: project),
                        );
                      },
                    ), _theme!
                ),
                if (portfolio.viewedExperience.isNotEmpty) _buildSection('Experience',
                    ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: portfolio.viewedExperience.length,
                        itemBuilder: (context, index) => ExperienceCard(experience: portfolio.viewedExperience[index]),
                    ), 
                    _theme!
                ),
                if (portfolio.viewedEducation.isNotEmpty) _buildSection('Education',
                    ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: portfolio.viewedEducation.length,
                        itemBuilder: (context, index) => EducationCard(education: portfolio.viewedEducation[index]),
                    ),
                    _theme!
                ),
                if (portfolio.viewedCertificates.isNotEmpty) _buildSection('Certificates',
                    _buildCertificateList(context, portfolio.viewedCertificates, _theme!),
                    _theme!
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, UserProfile userProfile, PortfolioTheme theme) {
    ImageProvider? backgroundImage;
    final profilePictureUrl = userProfile.profilePictureUrl;

    if (profilePictureUrl != null && profilePictureUrl.isNotEmpty) {
      if (profilePictureUrl.startsWith('file://')) {
        backgroundImage = FileImage(File(profilePictureUrl.replaceFirst('file://', '')));
      } else {
        backgroundImage = NetworkImage(profilePictureUrl);
      }
    }

    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 65,
            backgroundColor: theme.primaryColor.withOpacity(0.1),
            child: CircleAvatar(
              radius: 60,
              backgroundImage: backgroundImage,
              backgroundColor: Colors.grey[300],
              child: backgroundImage == null ? const Icon(Icons.person, size: 50, color: Colors.grey) : null,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(userProfile.headline, style: TextStyle(fontSize: 16, color: Colors.grey[700])),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutMe(BuildContext context, UserProfile userProfile, PortfolioTheme theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('About Me', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: theme.primaryColor)),
        const SizedBox(height: 8),
        Text(userProfile.about, style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.5, color: Colors.black87)),
      ],
    );
  }

  Widget _buildSection(String title, Widget content, PortfolioTheme theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(height: 56, thickness: 1.5),
        Text(title, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: theme.primaryColor)),
        const SizedBox(height: 20),
        content,
      ],
    );
  }

  Widget _buildCertificateList(BuildContext context, List<Certificate> certificates, PortfolioTheme theme) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: certificates.length,
      itemBuilder: (context, index) {
        final cert = certificates[index];
        return Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.grey[200]!)),
          child: ListTile(
            leading: CircleAvatar(backgroundColor: theme.primaryColor.withOpacity(0.1), child: Icon(Icons.school_outlined, color: theme.primaryColor)),
            title: Text(cert.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(cert.issuingOrganization),
            trailing: (cert.documentPath != null && cert.documentPath!.isNotEmpty)
                ? IconButton(
                    icon: const Icon(Icons.open_in_new),
                    color: theme.primaryColor,
                    onPressed: () async {
                      try {
                        final result = await open_filex_lib.OpenFilex.open(cert.documentPath!);
                        if (result.type != open_filex_lib.ResultType.done && mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Could not open file: ${result.message}')),
                          );
                        }
                      } catch (e) {
                         if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error opening file: An unexpected error occurred.')),
                          );
                         }
                      }
                    },
                  )
                : null,
          ),
        );
      },
    );
  }
}
