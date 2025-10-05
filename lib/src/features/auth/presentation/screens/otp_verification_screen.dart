// lib/src/features/auth/presentation/screens/otp_verification_screen.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_ai_app/src/features/auth/data/auth_service.dart';
import 'package:pinput/pinput.dart'; // Import the new package

class OtpVerificationScreen extends StatefulWidget {
  final String verificationId;
  const OtpVerificationScreen({super.key, required this.verificationId});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final _otpController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  // NEW: State to track if the first auto-verification attempt failed
  bool _verificationFailed = false;

  // This function is now called automatically on completion, or manually by the button
  Future<void> _verifyOtp(String pin) async {
    // Ensure we don't try to verify an incomplete pin
    if (pin.length < 6) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await _authService.signInWithOtp(
        verificationId: widget.verificationId,
        smsCode: pin,
      );
      if (mounted) {
        // Pop until we are back at the AuthWrapper, clearing the auth flow.
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    }
    // --- THIS IS THE FIX ---
    // We now specifically catch the FirebaseAuthException.
    on FirebaseAuthException catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _verificationFailed = true; // Show the manual submit button
        });
        // Display a user-friendly message from the exception.
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text(e.message ?? 'Verification failed. Please try again.')),
        );
      }
    }
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Define the style for the PIN boxes
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 60,
      textStyle: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.transparent),
      ),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Enter Verification Code')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Enter the 6-digit code we sent to your phone.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            // The Pinput widget
            Pinput(
              length: 6,
              controller: _otpController,
              autofocus: true,
              defaultPinTheme: defaultPinTheme,
              focusedPinTheme: defaultPinTheme.copyWith(
                decoration: defaultPinTheme.decoration!.copyWith(
                  border: Border.all(color: theme.colorScheme.primary),
                ),
              ),
              // NEW: Automatically submit when all 6 digits are entered
              onCompleted: (pin) => _verifyOtp(pin),
            ),
            const SizedBox(height: 32),
            // This button will only appear if the initial verification fails
            AnimatedOpacity(
              opacity: _verificationFailed ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 300),
              child: _verificationFailed
                  ? ElevatedButton(
                      onPressed: _isLoading
                          ? null
                          : () => _verifyOtp(_otpController.text),
                      child: _isLoading
                          ? const CircularProgressIndicator()
                          : const Text('Verify & Sign In'),
                    )
                  : const SizedBox.shrink(), // Takes no space when hidden
            ),
            // Show a loading indicator in the center while auto-verifying
            if (_isLoading && !_verificationFailed)
              const Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }
}
