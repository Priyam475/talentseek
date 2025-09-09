// lib/widgets/auth_wrapper.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/portfolio_provider.dart';
import '../screens/auth/login_screen.dart';
import '../screens/home/home_screen.dart';
import 'common/loading_indicator.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: LoadingIndicator());
        }

        final user = snapshot.data;
        if (user == null) {
          context.read<PortfolioProvider>().userLoggedOut();
          return LoginScreen();
        } else {
          return const HomeScreen();
        }
      },
    );
  }
}