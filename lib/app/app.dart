import 'package:flutter/material.dart';
import '../core/theme/app_palette.dart';
import 'app_root.dart';
import 'package:another_flushbar/flushbar.dart';

final GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();

class AppLoader {
  static OverlayEntry? _entry;

  static void show() {
    if (_entry != null) return;
    final overlay = appNavigatorKey.currentState?.overlay;
    if (overlay == null) return;
    _entry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          Positioned.fill(
            child: ColoredBox(color: Colors.black.withValues(alpha: 0.08)),
          ),
          Center(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppPalette.border),
              ),
              child: const SizedBox(
                height: 26,
                width: 26,
                child: CircularProgressIndicator(strokeWidth: 2.6),
              ),
            ),
          ),
        ],
      ),
    );
    overlay.insert(_entry!);
  }

  static void hide() {
    _entry?.remove();
    _entry = null;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Laci Mobile',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppPalette.primary,
          primary: AppPalette.primary,
          surface: AppPalette.surface,
        ),
        scaffoldBackgroundColor: AppPalette.background,
        snackBarTheme: SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: const BorderSide(color: AppPalette.border),
          ),
          contentTextStyle: const TextStyle(
            color: AppPalette.primaryDark,
            fontWeight: FontWeight.w600,
          ),
          actionTextColor: AppPalette.primary,
          disabledActionTextColor: AppPalette.textMuted,
        ),
        useMaterial3: true,
      ),
      navigatorKey: appNavigatorKey,
      home: const AppRoot(),
    );
  }
}

class AppNotify {
  static Future<void> info(BuildContext context, String message) {
    late final Flushbar f;
    f = Flushbar(
      flushbarPosition: FlushbarPosition.TOP,
      backgroundColor: Colors.white,
      borderRadius: BorderRadius.circular(14),
      margin: const EdgeInsets.all(12),
      duration: const Duration(seconds: 3),
      isDismissible: true,
      dismissDirection: FlushbarDismissDirection.HORIZONTAL,
      animationDuration: const Duration(milliseconds: 260),
      forwardAnimationCurve: Curves.easeOutCubic,
      reverseAnimationCurve: Curves.easeInCubic,
      boxShadows: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.08),
          blurRadius: 12,
          offset: const Offset(0, 6),
        ),
      ],
      messageText: Row(
        children: [
          const Icon(Icons.info_outline, color: AppPalette.primaryDark),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: AppPalette.primaryDark,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      mainButton: IconButton(
        onPressed: () => f.dismiss(),
        icon: const Icon(Icons.close, color: AppPalette.textMuted),
      ),
    );
    return f.show(context);
  }

  static Future<void> error(BuildContext context, String message) {
    late final Flushbar f;
    f = Flushbar(
      flushbarPosition: FlushbarPosition.TOP,
      backgroundColor: Colors.white,
      borderRadius: BorderRadius.circular(14),
      margin: const EdgeInsets.all(12),
      duration: const Duration(seconds: 3),
      isDismissible: true,
      dismissDirection: FlushbarDismissDirection.HORIZONTAL,
      animationDuration: const Duration(milliseconds: 260),
      forwardAnimationCurve: Curves.easeOutCubic,
      reverseAnimationCurve: Curves.easeInCubic,
      boxShadows: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.08),
          blurRadius: 12,
          offset: const Offset(0, 6),
        ),
      ],
      messageText: Row(
        children: [
          const Icon(Icons.error_outline, color: AppPalette.error),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: AppPalette.error,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
      mainButton: IconButton(
        onPressed: () => f.dismiss(),
        icon: const Icon(Icons.close, color: AppPalette.textMuted),
      ),
    );
    return f.show(context);
  }
}
