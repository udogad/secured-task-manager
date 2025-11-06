// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:secure_task_manager/app.dart';
import 'package:secure_task_manager/main.dart'; // Import main.dart to access sharedPreferencesProvider

// A mock class for SharedPreferences
class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Create a mock instance of SharedPreferences
    final mockSharedPreferences = MockSharedPreferences();

    // Stub any methods that might be called on SharedPreferences during the test
    when(() => mockSharedPreferences.getString(any())).thenReturn(null);
    when(() => mockSharedPreferences.setString(any(), any())).thenAnswer((_) async => true);

    // Build our app and trigger a frame, overriding sharedPreferencesProvider
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(mockSharedPreferences),
        ],
        child: const App(),
      ),
    );

    // Verify that the app builds without errors.
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
