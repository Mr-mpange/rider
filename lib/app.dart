import 'package:flutter/material.dart';
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
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _router = createRouter();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppPreferences()),
        ChangeNotifierProvider(create: (_) => AuthService()),
        Provider(create: (_) => FirestoreService()),
      ],
      child: Builder(
        builder: (context) {
          final localeCode = context.watch<AppPreferences>().localeCode;
          return MaterialApp.router(
            title: AppBranding.appTitle,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            locale: Locale(localeCode),
            supportedLocales: const [Locale('en'), Locale('sw')],
            routerConfig: _router,
          );
        },
      ),
    );
  }
}
