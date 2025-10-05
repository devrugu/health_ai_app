// lib/src/features/auth/presentation/screens/otp_verification_screen.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_ai_app/src/features/auth/data/auth_service.dart';
import 'package:pinput/pinput.dart';

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
  bool _verificationFailed = false;

  Future<void> _verifyOtp(String pin) async {
    if (pin.length < 6) return;

    setState(() {
      _isLoading = true;
    });

    // Store the context before the async gap.
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    try {
      await _authService.signInWithOtp(
        verificationId: widget.verificationId,
        smsCode: pin,
      );
      if (mounted) {
        navigator.popUntil((route) => route.isFirst);
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _verificationFailed = true;
        });
        scaffoldMessenger.showSnackBar(
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

    // FIX 1 & 2: Use the new surfaceContainerHighest and withAlpha properties.
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 60,
      textStyle: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest
            .withAlpha(128), // approx 0.5 opacity
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
              onCompleted: (pin) => _verifyOtp(pin),
            ),
            const SizedBox(height: 32),
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
                  : const SizedBox.shrink(),
            ),
            if (_isLoading && !_verificationFailed)
              const Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }
}
