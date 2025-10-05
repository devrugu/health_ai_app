// lib/src/features/auth/presentation/screens/auth_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isLoginMode = true;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _toggleMode() {
    setState(() {
      _isLoginMode = !_isLoginMode;
    });
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      final email = _emailController.text;
      final password = _passwordController.text;
      print(
          'Form is valid. Email: $email, Password: $password, Mode: ${_isLoginMode ? 'Login' : 'Register'}');
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          // --- THIS IS THE FIX ---
          // The Form widget directly contains the Column.
          // The incorrect mainAxisAlignment and crossAxisAlignment properties have been removed.
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center, // This is the correct placement
              crossAxisAlignment:
                  CrossAxisAlignment.stretch, // This is the correct placement
              children: [
                const Icon(Icons.fitness_center, size: 60)
                    .animate()
                    .fade(duration: 500.ms)
                    .scale(),
                const SizedBox(height: 24),
                Text(
                  _isLoginMode ? 'Welcome Back' : 'Create Account',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ).animate().fade(delay: 200.ms),
                const SizedBox(height: 8),
                Text(
                  _isLoginMode
                      ? 'Sign in to continue your journey'
                      : 'Let\'s get you started',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ).animate().fade(delay: 300.ms),
                const SizedBox(height: 40),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email Address'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || !value.contains('@')) {
                      return 'Please enter a valid email.';
                    }
                    return null;
                  },
                ).animate().fadeIn(delay: 500.ms).slideX(begin: -0.2),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.length < 6) {
                      return 'Password must be at least 6 characters long.';
                    }
                    return null;
                  },
                ).animate().fadeIn(delay: 600.ms).slideX(begin: -0.2),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: Text(_isLoginMode ? 'Login' : 'Sign Up'),
                ).animate().fadeIn(delay: 700.ms).slideY(begin: 0.2, end: 0),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: _toggleMode,
                  child: Text(
                    _isLoginMode
                        ? 'Don\'t have an account? Sign Up'
                        : 'Already have an account? Login',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
