import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Laci Mobile',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const AppRoot(),
    );
  }
}

enum AppStartFlow { loading, onboarding, returningSplash, login, register }

class AppRoot extends StatefulWidget {
  const AppRoot({super.key});

  @override
  State<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  AppStartFlow _flow = AppStartFlow.loading;

  @override
  void initState() {
    super.initState();
    _decideStartFlow();
  }

  Future<void> _decideStartFlow() async {
    final prefs = await SharedPreferences.getInstance();
    final seenOnboarding = prefs.getBool('onboarding_completed') ?? false;
    setState(() {
      _flow = seenOnboarding
          ? AppStartFlow.returningSplash
          : AppStartFlow.onboarding;
    });
  }

  void _goToLogin() {
    setState(() {
      _flow = AppStartFlow.login;
    });
  }

  void _goToRegister() {
    setState(() {
      _flow = AppStartFlow.register;
    });
  }

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_completed', true);
    _goToRegister();
  }

  @override
  Widget build(BuildContext context) {
    switch (_flow) {
      case AppStartFlow.loading:
        return const SplashScreen();
      case AppStartFlow.onboarding:
        return OnboardingScreen(onFinish: _completeOnboarding);
      case AppStartFlow.returningSplash:
        return ReturningSplash(onDone: _goToLogin);
      case AppStartFlow.login:
        return LoginScreen(onRegister: _goToRegister);
      case AppStartFlow.register:
        return RegisterScreen(onLogin: _goToLogin);
    }
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Laci Mobile',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

class ReturningSplash extends StatefulWidget {
  const ReturningSplash({super.key, required this.onDone});

  final VoidCallback onDone;

  @override
  State<ReturningSplash> createState() => _ReturningSplashState();
}

class _ReturningSplashState extends State<ReturningSplash> {
  @override
  void initState() {
    super.initState();
    _startDelay();
  }

  Future<void> _startDelay() async {
    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (mounted) {
      widget.onDone();
    }
  }

  @override
  Widget build(BuildContext context) {
    return const SplashScreen();
  }
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key, required this.onFinish});

  final Future<void> Function() onFinish;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _index = 0;

  final List<_OnboardingPageData> _pages = const [
    _OnboardingPageData(
      title: 'Selamat Datang',
      description: 'Kenalan dulu dengan aplikasi Laci Mobile.',
      icon: Icons.auto_awesome,
    ),
    _OnboardingPageData(
      title: 'Kelola Data',
      description: 'Atur dan simpan data lebih rapi dan cepat.',
      icon: Icons.inventory_2,
    ),
    _OnboardingPageData(
      title: 'Siap Mulai',
      description: 'Ayo lanjut ke proses pendaftaran.',
      icon: Icons.rocket_launch,
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
                  return _OnboardingPage(page: page);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  TextButton(
                    onPressed: _finish,
                    child: const Text('Lewati'),
                  ),
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
                    child: Text(_index == _pages.length - 1 ? 'Mulai' : 'Lanjut'),
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

class _OnboardingPageData {
  const _OnboardingPageData({
    required this.title,
    required this.description,
    required this.icon,
  });

  final String title;
  final String description;
  final IconData icon;
}

class _OnboardingPage extends StatelessWidget {
  const _OnboardingPage({required this.page});

  final _OnboardingPageData page;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(28),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(page.icon, size: 120, color: Colors.deepPurple),
          const SizedBox(height: 24),
          Text(
            page.title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            page.description,
            style: const TextStyle(fontSize: 16, color: Colors.black54),
            textAlign: TextAlign.center,
          ),
        ],
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
        color: isActive ? Colors.deepPurple : Colors.deepPurple.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key, required this.onRegister});

  final VoidCallback onRegister;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Login',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'Halaman login belum diisi. Lanjutkan ke register jika perlu.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: onRegister,
                child: const Text('Belum punya akun? Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key, required this.onLogin});

  final VoidCallback onLogin;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Register',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'Halaman register belum diisi. Lanjutkan ke login jika perlu.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: onLogin,
                child: const Text('Sudah punya akun? Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
