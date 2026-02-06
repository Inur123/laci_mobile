import 'package:flutter/material.dart';
import '../../core/theme/app_palette.dart';
import '../../widgets/brand_logo.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key, this.showLogo = false});

  final bool showLogo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showLogo) ...const [BrandLogo(size: 72), SizedBox(height: 16)],
            const Text(
              'Laci Digital',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            const Text(
              'Sistem Manajemen Organisasi',
              style: TextStyle(color: AppPalette.textMuted),
            ),
          ],
        ),
      ),
    );
  }
}
