// lib/screens/home/empty_home_view.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:talentseek/screens/explore/explore_screen.dart';
import 'package:talentseek/screens/home/portfolio_view.dart';
import 'package:talentseek/providers/portfolio_provider.dart';
import '../onboarding/portfolio_setup_screen.dart';

class EmptyHomeView extends StatelessWidget {
  const EmptyHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final portfolioProviderInitial = context.watch<PortfolioProvider>();
    final bool hasPortfolioInitially = portfolioProviderInitial.isSetupComplete;

    return Scaffold(
     body: Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.dashboard_customize_outlined, size: 80, color: Colors.grey),
            const SizedBox(height: 24),
            Text('Welcome to Portfolio Hub!', textAlign: TextAlign.center, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            
            if (hasPortfolioInitially)
              const Text('You have an existing portfolio. View it or explore others.', textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: Colors.black54))
            else
              const Text('You don\'t have a portfolio yet. Create one to showcase your work or explore others.', textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: Colors.black54)),
            const SizedBox(height: 48),

            // Button 1: View My Portfolio / Create Portfolio
            ElevatedButton.icon(
              icon: Icon(hasPortfolioInitially ? Icons.visibility : Icons.add_circle),
              label: Text(hasPortfolioInitially ? 'View My Portfolio' : 'Create Portfolio'),
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16), textStyle: const TextStyle(fontSize: 16)),
              onPressed: () async {
                final portfolioProvider = context.read<PortfolioProvider>();
                showDialog(context: context, builder: (context) => const Center(child: CircularProgressIndicator()), barrierDismissible: false);
                await portfolioProvider.checkSetupStatus();
                Navigator.pop(context); // Dismiss loading indicator

                if (portfolioProvider.isSetupComplete) {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const PortfolioView()));
                } else {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const PortfolioSetupScreen()));
                }
              },
            ),
            const SizedBox(height: 16),

            // Middle button (Edit/Manage) is REMOVED

            // Button 2: Explore Other Portfolios
            OutlinedButton.icon(
              icon: const Icon(Icons.explore_outlined),
              label: const Text('Explore Other Portfolios'),
              style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16), textStyle: const TextStyle(fontSize: 16)),
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => ExploreScreen())),
            ),
          ],
        ),
      ),
      ));
  }
}
