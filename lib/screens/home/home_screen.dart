// lib/screens/home/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../providers/portfolio_provider.dart'; // Keep for logout action
import 'empty_home_view.dart'; // This will be the main view shown
// portfolio_view.dart is no longer directly used here, so its import can be removed
// LoadingIndicator might also not be directly needed here anymore

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // You might still want to trigger checkSetupStatus, perhaps in an initState
    // of EmptyHomeView or when HomeScreen first builds, if EmptyHomeView relies on it.
    // For now, let's keep HomeScreen simple.
    // context.read<PortfolioProvider>().checkSetupStatus(); // Example: could be called here

    return Scaffold(
      appBar: AppBar(
        title: const Text('Portfolio Hub'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<PortfolioProvider>().userLoggedOut();
              FirebaseAuth.instance.signOut();
              // After logout, you'll likely navigate to a login screen.
              // This is usually handled by a listener on the auth state.
            },
          ),
        ],
      ),
      body: const EmptyHomeView(), // Always show EmptyHomeView
    );
  }
}
