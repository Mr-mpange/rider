import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:rider/core/constants/app_branding.dart';
import 'package:rider/core/services/app_preferences.dart';
import 'package:rider/core/services/auth_service.dart';
import 'package:rider/screens/splash_screen.dart';

void main() {
  testWidgets('Splash screen renders brand', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AppPreferences()),
          ChangeNotifierProvider(create: (_) => AuthService()),
        ],
        child: const MaterialApp(home: SplashScreen()),
      ),
    );
    expect(find.text(AppBranding.appName), findsOneWidget);
    expect(find.text(AppBranding.tagline), findsOneWidget);
  });
}
