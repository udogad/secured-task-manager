import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/storage/storage_service.dart';

/// A splash screen that handles initial app setup and navigation.
class SplashPage extends StatefulWidget {
  /// Creates a [SplashPage] widget.
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await Future.delayed(const Duration(milliseconds: 500)); // fast
    final storage = getStorageService;
    final seen = await storage.read(key: 'onboarding_complete') == 'true';
    if (!mounted) return;
    if (!seen) {
      context.go('/onboarding');
    } else {
      context.go('/sign-in');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Secure Tasks Manager',
          style: TextStyle(color: Colors.black, fontSize: 24),
        ),
      ),
    );
  }
}
