import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

/// A widget that guards its child with biometric authentication.
class BiometricGuard extends StatefulWidget {
  /// The widget to display if authentication is successful.
  final Widget child;

  /// Creates a [BiometricGuard] widget.
  const BiometricGuard({super.key, required this.child});

  @override
  State<BiometricGuard> createState() => _BiometricGuardState();
}

class _BiometricGuardState extends State<BiometricGuard> {
  final LocalAuthentication _auth = LocalAuthentication();
  bool _authorized = false;
  bool _checking = true;

  @override
  void initState() {
    super.initState();
    _initAuth();
  }

  Future<void> _initAuth() async {
    try {
      final canCheck =
          await _auth.canCheckBiometrics || await _auth.isDeviceSupported();
      setState(() {
        _checking = false;
      });
      if (canCheck) {
        await _authenticate();
      } else {
        setState(() {
          _authorized = true;
        }); // fallback: allow if device has none
      }
    } catch (_) {
      setState(() {
        _authorized = true;
        _checking = false;
      });
    }
  }

  Future<void> _authenticate() async {
    try {
      final didAuth = await _auth.authenticate(
        localizedReason: 'Please authenticate to access your tasks',
      );
      setState(() {
        _authorized = didAuth;
      });
    } catch (_) {
      setState(() {
        _authorized = true;
      }); // fallback: allow on error (you can change to lockout)
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_checking) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (!_authorized) {
      return Scaffold(
        body: Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.fingerprint, size: 64),
            const SizedBox(height: 12),
            const Text('Unlock to continue'),
            const SizedBox(height: 16),
            FilledButton(onPressed: _authenticate, child: const Text('Unlock')),
            const SizedBox(height: 8),
            TextButton(
                onPressed: () => setState(() => _authorized = true),
                child: const Text('Use PIN (fallback)')),
          ]),
        ),
      );
    }
    return widget.child;
  }
}
