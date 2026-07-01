import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'core/constants/app_branding.dart';
import 'core/router/app_router.dart';
import 'core/services/app_preferences.dart';
import 'core/services/auth_service.dart';
import 'core/services/firestore_service.dart';
import 'core/theme/app_theme.dart';

class RiderApp extends StatefulWidget {
  const RiderApp({super.key});

  @override
  State<RiderApp> createState() => _RiderAppState();
}

class _RiderAppState extends State<RiderApp> {
  GoRouter? _router;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (Firebase.apps.isEmpty) {
      return const MaterialApp(
        home: Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppPreferences()),
        ChangeNotifierProvider(create: (_) => AuthService()),
        Provider(create: (_) => FirestoreService()),
      ],
      child: Builder(
        builder: (context) {
          final prefs = context.watch<AppPreferences>();
          final auth = context.watch<AuthService>();
          _router ??= createRouter(prefs: prefs, auth: auth);
          final localeCode = prefs.localeCode;
          return MaterialApp.router(
            title: AppBranding.appTitle,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            locale: Locale(localeCode),
            supportedLocales: const [Locale('en'), Locale('sw')],
            routerConfig: _router!,
          );
        },
      ),
    );
  }
}
