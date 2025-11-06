import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../data/auth_repository.dart';

/// A page for user sign-up.
class SignUpPage extends StatefulWidget {
  /// Creates a [SignUpPage] widget.
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _busy = false;
  String? _error;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 40),
              Text('Create Account',
                  style: theme.textTheme.headlineMedium
                      ?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('Let’s get you started with Smart Task Manager!',
                  style: theme.textTheme.titleMedium),
              const SizedBox(height: 40),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _email,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            prefixIcon: Icon(Icons.email_outlined),
                          ),
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return 'Email required';
                            }
                            if (!v.contains('@')) {
                              return 'Invalid email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _password,
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: 'Password',
                            prefixIcon: Icon(Icons.lock_outline),
                          ),
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return 'Password required';
                            }
                            if (v.length < 6) {
                              return 'Minimum 6 chars';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        if (_error != null)
                          Text(_error!,
                              style: const TextStyle(
                                  color: Colors.red, fontSize: 14)),
                        const SizedBox(height: 12),
                        FilledButton(
                          onPressed: _busy
                              ? null
                              : () async {
                                  if (!_formKey.currentState!.validate()) {
                                    return;
                                  }
                                  setState(() => _busy = true);
                                  final result = await AuthRepository.instance
                                      .signUpWithEmail(
                                          _email.text.trim(), _password.text);
                                  result.when(
                                    ok: (_) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Account created successfully! Please sign in.'),
                                        ),
                                      );
                                      context.go('/sign-in');
                                    },
                                    err: (f) {
                                      String errorMessage = 'An unknown error occurred.';
                                      if (f.code == 'email-already-in-use') {
                                        errorMessage = 'The email address is already in use by another account.';
                                      } else if (f.code == 'weak-password') {
                                        errorMessage = 'The password provided is too weak.';
                                      } else if (f.code == 'invalid-email') {
                                        errorMessage = 'The email address is not valid.';
                                      }
                                      setState(() => _error = errorMessage);
                                    },
                                  );
                                  setState(() => _busy = false);
                                },
                          style: FilledButton.styleFrom(
                              minimumSize: const Size.fromHeight(48)),
                          child: _busy
                              ? const CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white)
                              : const Text('Sign Up'),
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: () => context.go('/sign-in'),
                          child: const Text('Already have an account? Log in'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
