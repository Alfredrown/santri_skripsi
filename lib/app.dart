import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'core/accessibility/a11y_constants.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/widgets/web_mobile_frame.dart';

class SantriSkripsiApp extends ConsumerWidget {
  const SantriSkripsiApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'Santri Skripsi',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: router,
      builder: (context, child) {
        // Supports dynamic font scaling up to 200% (WCAG 1.4.4)
        final mediaQuery = MediaQuery.of(context);
        final clampedScaler = mediaQuery.textScaler.clamp(
          minScaleFactor: 0.85,
          maxScaleFactor: A11yConstants.maxTextScaleFactor,
        );
        final Widget appContent = MediaQuery(
          data: mediaQuery.copyWith(textScaler: clampedScaler),
          child: child ?? const SizedBox.shrink(),
        );
        if (kIsWeb) {
          return WebMobileFrame(child: appContent);
        }
        return appContent;
      },
    );
  }
}
