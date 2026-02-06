import 'package:flutter/material.dart';
import '../../core/theme/app_palette.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key, required this.onFinish});

  final Future<void> Function() onFinish;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _index = 0;

  final List<_SimpleOnboardingPageData> _pages = const [
    _SimpleOnboardingPageData(
      title: 'Selamat Datang di Laci Digital',
      description:
          'Kelola organisasi lebih rapi, cepat, dan terintegrasi dari satu aplikasi.',
      assetImage: 'assets/images/logo-laci.png',
    ),
    _SimpleOnboardingPageData(
      title: 'Kelola Administrasi',
      description:
          'Simpan data administrasi, arsip, dan surat masuk secara rapi dan aman.',
      icon: Icons.group,
    ),
    _SimpleOnboardingPageData(
      title: 'Mulai Sekarang',
      description:
          'Akses sumber daya, dashboard, dan laporan kapan pun dibutuhkan.',
      icon: Icons.dashboard,
    ),
  ];

  void _next() {
    if (_index < _pages.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _finish() async {
    await widget.onFinish();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _pages.length,
                onPageChanged: (value) {
                  setState(() {
                    _index = value;
                  });
                },
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return _SimpleOnboardingPage(page: page);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  TextButton(onPressed: _finish, child: const Text('Lewati')),
                  const Spacer(),
                  Row(
                    children: List.generate(
                      _pages.length,
                      (index) => _Dot(isActive: index == _index),
                    ),
                  ),
                  const Spacer(),
                  FilledButton(
                    onPressed: _index == _pages.length - 1 ? _finish : _next,
                    child: Text(
                      _index == _pages.length - 1 ? 'Mulai' : 'Lanjut',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.isActive});

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 8,
      width: isActive ? 22 : 8,
      decoration: BoxDecoration(
        color: isActive ? AppPalette.primary : AppPalette.primarySoft,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}

class _SimpleOnboardingPageData {
  const _SimpleOnboardingPageData({
    required this.title,
    required this.description,
    this.icon,
    this.assetImage,
  });

  final String title;
  final String description;
  final IconData? icon;
  final String? assetImage;
}

class _SimpleOnboardingPage extends StatelessWidget {
  const _SimpleOnboardingPage({required this.page});

  final _SimpleOnboardingPageData page;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 140,
            width: 140,
            decoration: BoxDecoration(
              color: AppPalette.primarySoft,
              borderRadius: BorderRadius.circular(32),
            ),
            clipBehavior: Clip.antiAlias,
            child: page.assetImage != null
                ? Image.asset(page.assetImage!, fit: BoxFit.cover)
                : Icon(page.icon!, size: 72, color: AppPalette.primary),
          ),
          const SizedBox(height: 24),
          Text(
            page.title,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            page.description,
            style: const TextStyle(color: AppPalette.textMuted, height: 1.4),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
