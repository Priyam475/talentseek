import 'package:flutter/material.dart';
import 'package:talentseek/screens/auth/signup_screen.dart';
import '../../services/auth_service.dart';
import '../../widgets/auth_wrapper.dart'; // Changed to AuthWrapper
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/loading_indicator.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();
  bool _isLoading = false;
  bool _obscureText = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      // Trim email input
      final String email = _emailController.text.trim();
      final String password = _passwordController.text; // Passwords usually aren't trimmed

      final user = await _authService.signInWithEmailAndPassword(
        email, // Use trimmed email
        password,
      );

      if (mounted) {
        setState(() => _isLoading = false); // Stop loading indicator regardless of outcome
        if (user != null) {
          // Navigate to AuthWrapper if login is successful
          // AuthWrapper will then decide the next screen (HomeScreen)
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const AuthWrapper()),
            (Route<dynamic> route) => false,
          );
        } else {
          // Show an error and stop loading if the login fails.
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Invalid email or password. Please try again.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFB5CBB7), // Added const
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Welcome Back!',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Log in to your portfolio hub.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 40),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(25))),
                      prefixIcon: Icon(Icons.email_outlined)),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null) {
                      return 'Enter your email';
                    }
                    final trimmedEmail = value.trim();
                    if (trimmedEmail.isEmpty) {
                      return 'Enter your email';
                    }
                    if (!trimmedEmail.contains('@') || !trimmedEmail.contains('.')) {
                      return 'Enter a valid email address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(25))), // Applied consistent border radius
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
                      onPressed: () {
                        setState(() => _obscureText = !_obscureText);
                      },
                    ),
                  ),
                  obscureText: _obscureText,
                  validator: (value) => (value == null || value.length < 6) ? 'Password must be at least 6 characters' : null,
                ),
                const SizedBox(height: 24),
                _isLoading
                    ? const LoadingIndicator()
                    : CustomButton(text: 'Login', onPressed: _login),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SignUpScreen())),
                  child: const Text('Don\'t have an account? Sign Up'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
