import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../features/auth/login_screen.dart';
import '../features/auth/register_screen.dart';
import '../features/home/home_screen.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../features/splash/returning_splash.dart';
import '../features/splash/splash_screen.dart';

enum AppStartFlow {
  loading,
  onboarding,
  returningSplash,
  login,
  register,
  home,
}

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

  void _goToHome() {
    setState(() {
      _flow = AppStartFlow.home;
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
        return LoginScreen(onRegister: _goToRegister, onSuccess: _goToHome);
      case AppStartFlow.register:
        return RegisterScreen(onLogin: _goToLogin, onSuccess: _goToHome);
      case AppStartFlow.home:
        return const HomeScreen();
    }
  }
}
