import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:shared_preferences/shared_preferences.dart'; // No longer needed here for initial routing
import 'firebase_options.dart';
import 'providers/portfolio_provider.dart';
import 'providers/user_provider.dart';
import 'utils/theme.dart';
import 'widgets/auth_wrapper.dart';
// import 'screens/onboarding/steps/personal_details_step.dart'; // No longer needed here as InitialSetupScreen is removed

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // The initialSetupComplete flag from SharedPreferences is no longer used here
  // to determine the initial route.

  runApp(const MyApp()); // Pass const MyApp() directly
}

class MyApp extends StatelessWidget {
  // initialSetupComplete parameter is removed
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => PortfolioProvider()),
      ],
      child: MaterialApp(
        title: 'Portfolio Hub',
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        // AuthWrapper will now be the initial screen.
        // It should handle authentication and then navigate to your main app screen
        // where PortfolioView can be displayed (which will show its empty state if needed).
        home: const AuthWrapper(),
      ),
    );
  }
}

// InitialSetupScreen widget is removed as it's no longer part of the initial flow.
// The PersonalDetailsStep will be accessed through the PortfolioSetupScreen when a user
// chooses to create or edit their portfolio from the PortfolioView.
