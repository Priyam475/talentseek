import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../providers/portfolio_provider.dart'; // [FIX] Use PortfolioProvider
import '../widgets/common/custom_button.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // [FIX] Watch the PortfolioProvider to get the rich user profile data
    final portfolioProvider = context.watch<PortfolioProvider>();
    final profile = portfolioProvider.liveProfile;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.account_circle, size: 80, color: Colors.grey),
            const SizedBox(height: 16),
            Center(
              child: Text(
                // [FIX] Display the full name from the portfolio
                profile?.fullName ?? 'User Name',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                // [FIX] Display the headline from the portfolio
                profile?.headline ?? 'No headline provided.',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            const Spacer(),
            CustomButton(
              text: 'Logout',
              onPressed: () {
                // [FIX] Simplified logout. The AuthWrapper handles navigation.
                FirebaseAuth.instance.signOut();
                // Pop all screens until the AuthWrapper is shown.
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            ),
          ],
        ),
      ),
    );
  }
}
