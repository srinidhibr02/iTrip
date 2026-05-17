import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:itrip/core/constants/app_constants.dart';
import 'package:itrip/core/providers/theme_provider.dart';
import 'package:itrip/core/router/app_router.dart';
import 'package:itrip/core/theme/app_theme.dart';

/// Root application widget.
class ITripApp extends ConsumerWidget {
  const ITripApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      routerConfig: router,
    );
  }
}
