import 'package:flutter/material.dart';
import '../core/theme/app_palette.dart';
import 'app_root.dart';

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
        useMaterial3: true,
      ),
      home: const AppRoot(),
    );
  }
}
