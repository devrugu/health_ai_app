// lib/src/features/auth/presentation/screens/phone_auth_screen.dart

import 'package:flutter/material.dart';
import 'package:health_ai_app/src/features/auth/data/auth_service.dart';
import 'package:health_ai_app/src/features/auth/presentation/screens/otp_verification_screen.dart';

class PhoneAuthScreen extends StatefulWidget {
  const PhoneAuthScreen({super.key});

  @override
  State<PhoneAuthScreen> createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  void _sendOtp() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() {
      _isLoading = true;
    });

    final phoneNumber =
        '+90${_phoneController.text}'; // IMPORTANT: Add your country code

    _authService.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (credential) {
        // This is for auto-retrieval on Android, which we won't focus on now.
        // It can automatically sign the user in.
        setState(() {
          _isLoading = false;
        });
      },
      verificationFailed: (e) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send code: ${e.message}')),
        );
      },
      codeSent: (verificationId, resendToken) {
        setState(() {
          _isLoading = false;
        });
        // Navigate to the OTP screen
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) =>
                OtpVerificationScreen(verificationId: verificationId),
          ),
        );
      },
      codeAutoRetrievalTimeout: (verificationId) {
        // Called when auto-retrieval times out.
      },
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Enter Your Phone Number')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'We will send a verification code to this number.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  prefixText: '+90 ', // Match your country code
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.length < 10) {
                    return 'Please enter a valid phone number.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _isLoading ? null : _sendOtp,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Send Code'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
