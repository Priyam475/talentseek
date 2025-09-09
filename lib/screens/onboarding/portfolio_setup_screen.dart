import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/portfolio_provider.dart';
import '../home/home_screen.dart';
import 'steps/personal_details_step.dart';
import 'steps/skills_step.dart';
import 'steps/projects_step.dart';
import 'steps/education_step.dart';
import 'steps/experience_step.dart';
import 'steps/certificates_step.dart';
import 'steps/finalize_step.dart';

class PortfolioSetupScreen extends StatefulWidget {
  // [NEW] Flag to determine if we are creating or editing.
  final bool isEditing;
  const PortfolioSetupScreen({super.key, this.isEditing = false});

  @override
  State<PortfolioSetupScreen> createState() => _PortfolioSetupScreenState();
}

class _PortfolioSetupScreenState extends State<PortfolioSetupScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    // [FIX] Only clear temporary data if we are creating a new portfolio.
    if (!widget.isEditing) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<PortfolioProvider>().clearTemporaryData();
      });
    }
  }

  late final List<Widget> _steps = [
    PersonalDetailsStep(onNext: _nextPage),
    SkillsStep(onNext: _nextPage),
    ProjectsStep(onNext: _nextPage),
    EducationStep(onNext: _nextPage, onPrevious: () {  },),
    ExperienceStep(onNext: _nextPage),
    CertificatesStep(onNext: _nextPage),
    FinalizeStep(onFinish: _finishSetup),
  ];

  void _nextPage() {
    if (_currentPage < _steps.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    }
  }

  void _finishSetup() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    // This single method now handles both creating and updating the portfolio.
    await context.read<PortfolioProvider>().saveFullPortfolio();

    // After saving, fetch the newly updated portfolio data.
    if (mounted) {
      await context.read<PortfolioProvider>().fetchFullPortfolio();
    }

    if (mounted) {
      // If editing, just pop back to the portfolio view. If creating, go to the home screen.
      if (widget.isEditing) {
        Navigator.of(context).pop(); // Dismiss loading dialog
        Navigator.of(context).pop(); // Pop the setup screen itself
      } else {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
              (Route<dynamic> route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // [NEW] Title changes based on whether we are editing or creating.
        title: Text(widget.isEditing ? 'Edit Your Portfolio' : 'Create Portfolio (${_currentPage + 1}/${_steps.length})'),
        // Only show a native back button if we are in edit mode.
        automaticallyImplyLeading: widget.isEditing,
      ),
      body: PageView.builder(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _steps.length,
        onPageChanged: (page) => setState(() => _currentPage = page),
        itemBuilder: (context, index) => _steps[index],
      ),
    );
  }
}