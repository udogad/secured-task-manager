import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../data/auth_repository.dart';

/// A page that allows users to sign in or register.
class SignInPage extends StatefulWidget {
  /// Creates a new [SignInPage].
  const SignInPage({super.key});
  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _busy = false;
  String? _error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Secure Task Manager')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Text('Sign in to your account',
                      style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    autofillHints: const [AutofillHints.email],
                    decoration: const InputDecoration(labelText: 'Email'),
                    validator: (v) {
                      final s = (v ?? '').trim();
                      if (s.isEmpty) return 'Email required';
                      if (!s.contains('@') || s.length > 160) {
                        return 'Enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _password,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'Password'),
                    validator: (v) {
                      final s = v ?? '';
                      if (s.isEmpty) return 'Password required';
                      if (s.length < 6) return 'Minimum 6 characters';
                      if (s.length > 128) return 'Password too long';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  if (_error != null)
                    Text(_error!, style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 8),
                  FilledButton(
                    onPressed: _busy
                        ? null
                        : () async {
                            if (!_formKey.currentState!.validate()) return;
                            setState(() {
                              _busy = true;
                              _error = null;
                            });
                            final res = await AuthRepository.instance
                                .signInWithEmail(
                                    _email.text.trim(), _password.text);
                            res.when(
                              ok: (_) => context.go('/dashboard'),
                              err: (f) {
                                String errorMessage = 'An unknown error occurred.';
                                if (f.code == 'user-not-found') {
                                  errorMessage = 'No user found for that email.';
                                } else if (f.code == 'wrong-password') {
                                  errorMessage = 'Wrong password provided for that user.';
                                } else if (f.code == 'invalid-email') {
                                  errorMessage = 'The email address is not valid.';
                                } else if (f.code == 'user-disabled') {
                                  errorMessage = 'This user has been disabled.';
                                }
                                setState(() => _error = errorMessage);
                              },
                            );
                            setState(() => _busy = false);
                          },
                    child: _busy
                        ? const SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(strokeWidth: 2))
                        : const Text('Continue'),
                  ),
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
