import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:go_router/go_router.dart';
import '../../../core/storage/storage_service.dart';

/// A page for onboarding new users.
class OnboardingPage extends StatefulWidget {
  /// Creates an [OnboardingPage] widget.
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _controller = PageController();
  int _index = 0;

  final _slides = [
    {
      'title': 'Plan Smarter',
      'subtitle': 'Organize your tasks with priorities and due-dates.',
      'asset': 'assets/lottie/plan.json',
    },
    {
      'title': 'Stay Secure',
      'subtitle': 'Everything is encrypted on your device by default.',
      'asset': 'assets/lottie/secure.json',
    },
    {
      'title': 'Achieve More',
      'subtitle': 'Track progress and stay focused with smart reminders.',
      'asset': 'assets/lottie/productive.json',
    },
  ];

  void _next() async { // Added async here
    if (_index < _slides.length - 1) {
      _controller.nextPage(
          duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
    } else {
      final storage = getStorageService;
      await storage.write(key: 'onboarding_complete', value: 'true');
      if (!mounted) return;
      context.go('/sign-up');
    }
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                onPageChanged: (i) => setState(() => _index = i),
                itemCount: _slides.length,
                itemBuilder: (c, i) {
                  final slide = _slides[i];
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset(slide['asset']!, width: 260),
                      const SizedBox(height: 28),
                      Text(slide['title']!,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 28),
                        child: Text(slide['subtitle']!,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleMedium),
                      ),
                    ],
                  );
                },
              ),
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_slides.length, (i) {
                  return AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: const EdgeInsets.all(6),
                      width: _index == i ? 18 : 10,
                      height: 10,
                      decoration: BoxDecoration(
                          color: _index == i ? primary : Colors.grey.shade400,
                          borderRadius: BorderRadius.circular(8)));
                })),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
              child: FilledButton(
                onPressed: _next,
                style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(50)),
                child:
                    Text(_index == _slides.length - 1 ? 'Get Started' : 'Next'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
