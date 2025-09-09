import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/auth_wrapper.dart'; // Changed to AuthWrapper
import '../../widgets/common/loading_indicator.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController(); // Added controller for full name
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();
  bool _isLoading = false;
  bool _obscureText = true;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      // Trim input values
      final String fullName = _fullNameController.text.trim();
      final String email = _emailController.text.trim();
      final String password = _passwordController.text; // Password typically isn't trimmed for leading/trailing spaces.

      // Call the updated signUp method from AuthService
      final String result = await _authService.signUp(
        fullName: fullName,
        email: email,
        password: password,
      );
      
      if (mounted) {
        setState(() => _isLoading = false);
        if (result == 'Success') {
          // Navigate to AuthWrapper on successful sign-up
          // AuthWrapper will then decide to show home page or portfolio setup if needed
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const AuthWrapper()),
            (Route<dynamic> route) => false,
          );
        } else {
          // Show error message from AuthService
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(result), backgroundColor: Colors.red),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Let's Create.."),
        titleTextStyle: TextStyle(
            color: Colors.orange.shade700,
            fontSize: 33,
            shadows: const [Shadow(blurRadius: 2.0, color: Colors.black45)],
      ),centerTitle: true),
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
                  'Create Account',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Start building your portfolio today.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 40),
                TextFormField(
                  controller: _fullNameController, 
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(25))),
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  keyboardType: TextInputType.name,
                  validator: (value) => (value == null || value.trim().isEmpty) ? 'Enter your full name' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(25))),
                    prefixIcon: Icon(Icons.email_outlined)),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    // 1. Check for null first
                    if (value == null) {
                      return 'Enter your email';
                    }
                    // 2. Trim the value (now we know it's not null)
                    final trimmedEmail = value.trim();
                    // 3. Check if the trimmed value is empty
                    if (trimmedEmail.isEmpty) {
                      return 'Enter your email';
                    }
                    // 4. Perform other validations on the trimmed email
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
                    border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(25))), 
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
                    : CustomButton(text: 'Sign Up', onPressed: _signUp),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
