import 'dart:io'; // Added for FileImage
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:open_filex/open_filex.dart' as open_filex_lib; // Import for opening files with alias
// import 'package:url_launcher/url_launcher.dart'; // Removed as ProjectCard handles its own URL launching

import '../../models/certificate.dart';
import '../../models/education.dart';
import '../../models/experience.dart';
import '../../models/project.dart'; 
import '../../providers/portfolio_provider.dart';
import '../../screens/onboarding/portfolio_setup_screen.dart';
import '../../utils/portfolio_theme_generator.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../widgets/cards/project_card.dart';
import '../../widgets/cards/skill_card.dart';
import '../../widgets/cards/experience_card.dart';
import '../../widgets/cards/education_card.dart';

class PortfolioView extends StatefulWidget {
  const PortfolioView({super.key});
  @override
  State<PortfolioView> createState() => _PortfolioViewState();
}

class _PortfolioViewState extends State<PortfolioView> {
  PortfolioTheme? _theme;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchPortfolioData();
    });
  }

  Future<void> _fetchPortfolioData() async {
    final portfolioProvider = context.read<PortfolioProvider>();
    await portfolioProvider.checkSetupStatus();
    if (portfolioProvider.isSetupComplete) {
      await portfolioProvider.fetchFullPortfolio();
      if (portfolioProvider.liveProfile != null && mounted) {
        setState(() {
          _theme = PortfolioThemeGenerator.generateTheme(portfolioProvider.liveProfile!.uid);
        });
      }
    } else {
      if (mounted) setState(() {});
    }
  }

  // _showProjectDetailsDialog method was removed in a previous step

  @override
  Widget build(BuildContext context) {
    final portfolio = context.watch<PortfolioProvider>();

    if (portfolio.isLoading) return const LoadingIndicator();

    if (!portfolio.isSetupComplete || portfolio.liveProfile == null) {
      // Empty state UI
      return Scaffold(
        appBar: AppBar(
          title: const Text('My Portfolio'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.folder_open_outlined, size: 80, color: Colors.grey),
                const SizedBox(height: 24),
                Text(
                  'Your portfolio is currently empty.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.grey[700]),
                ),
                const SizedBox(height: 16),
                Text(
                  'Create your portfolio to showcase your skills and projects.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                ),
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  icon: const Icon(Icons.add_circle_outline),
                  label: const Text('Create Your Portfolio'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (_) => const PortfolioSetupScreen(),
                    )).then((_) {
                       _fetchPortfolioData();
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      );
    }
    
    if (_theme == null) return const LoadingIndicator(); 

    return Scaffold(
      appBar: AppBar(
          title: Text(portfolio.liveProfile!.fullName, style: TextStyle(color: _theme!.primaryColor, fontWeight: FontWeight.bold)),
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: _theme!.primaryColor), // For back button or other icons
        ),
      body: Container(
        decoration: BoxDecoration(gradient: _theme!.backgroundGradient),
        child: RefreshIndicator(
          onRefresh: () => portfolio.fetchFullPortfolio(), 
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 80.0), // Added bottom padding for FAB
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, portfolio, _theme!),
                const SizedBox(height: 24),
                _buildAboutMe(context, portfolio, _theme!),

                if (portfolio.liveSkills.isNotEmpty) _buildSection('My Skills',
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4, 
                        crossAxisSpacing: 8, // Reduced from 12
                        mainAxisSpacing: 8,  // Reduced from 12
                        childAspectRatio: 1
                      ),
                      itemCount: portfolio.liveSkills.length,
                      itemBuilder: (context, index) => SkillCard(skill: portfolio.liveSkills[index]),
                    ), _theme!
                ),
                if (portfolio.liveProjects.isNotEmpty) _buildSection('Featured Projects',
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: portfolio.liveProjects.length,
                      itemBuilder: (itemContext, index) { 
                        final project = portfolio.liveProjects[index];
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: ProjectCard(
                            project: project,
                          ),
                        );
                      },
                    ), _theme!
                ),
                if (portfolio.liveExperience.isNotEmpty) _buildSection('Experience',
                    ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: portfolio.liveExperience.length,
                        itemBuilder: (context, index) => ExperienceCard(experience: portfolio.liveExperience[index]),
                    ), 
                    _theme!
                ),
                if (portfolio.liveEducation.isNotEmpty) _buildSection('Education',
                    ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: portfolio.liveEducation.length,
                        itemBuilder: (context, index) => EducationCard(education: portfolio.liveEducation[index]),
                    ),
                    _theme!
                ),
                if (portfolio.liveCertificates.isNotEmpty) _buildSection('Certificates',
                    _buildCertificateList(context, portfolio.liveCertificates, _theme!),
                    _theme!
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.read<PortfolioProvider>().prepareForEditing();
          Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => const PortfolioSetupScreen(isEditing: true),
          )).then((_) {
             _fetchPortfolioData();
          });
        },
        icon: const Icon(Icons.edit),
        label: const Text('Edit Portfolio'),
        backgroundColor: _theme!.primaryColor,
      ),
    );
  }

  Widget _buildHeader(BuildContext context, PortfolioProvider portfolio, PortfolioTheme theme) {
    ImageProvider? backgroundImage;
    final profilePictureUrl = portfolio.liveProfile?.profilePictureUrl;

    if (profilePictureUrl != null && profilePictureUrl.isNotEmpty) {
      if (profilePictureUrl.startsWith('file://')) {
        backgroundImage = FileImage(File(profilePictureUrl.replaceFirst('file://', '')));
      } else {
        backgroundImage = NetworkImage(profilePictureUrl);
      }
    }

    return Padding(
      padding: const EdgeInsets.only(top: 16.0), // Add space between AppBar and CircleAvatar
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
                Text(portfolio.liveProfile!.headline, style: TextStyle(fontSize: 16, color: Colors.grey[700])),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutMe(BuildContext context, PortfolioProvider portfolio, PortfolioTheme theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('About Me', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: theme.primaryColor)),
        const SizedBox(height: 8),
        Text(portfolio.liveProfile!.about, style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.5, color: Colors.black87)),
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
                        if (result.type != open_filex_lib.ResultType.done) { 
                           debugPrint('Could not open file: ${result.message}');
                           if (mounted) { 
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Could not open file: ${result.message}')),
                            );
                           }
                        }
                      } catch (e) {
                        debugPrint('Error opening file: $e');
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
