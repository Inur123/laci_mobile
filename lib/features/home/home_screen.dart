import 'package:flutter/material.dart';
import '../../core/theme/app_palette.dart';
import 'screens/arsip_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/kegiatan_screen.dart';
import 'screens/pengajuan_screen.dart';
import 'screens/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.isCabang = false});

  final bool isCabang;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final tabs = <_HomeTab>[
      const _HomeTab(
        label: 'Beranda',
        icon: Icons.home_outlined,
        activeIcon: Icons.home,
        content: DashboardScreen(),
      ),
      const _HomeTab(
        label: 'Arsip',
        icon: Icons.folder_outlined,
        activeIcon: Icons.folder,
        content: ArsipScreen(),
      ),
      const _HomeTab(
        label: 'Pengajuan',
        icon: Icons.send_outlined,
        activeIcon: Icons.send,
        content: PengajuanScreen(),
      ),
      if (widget.isCabang)
        const _HomeTab(
          label: 'Kegiatan',
          icon: Icons.event_outlined,
          activeIcon: Icons.event,
          content: KegiatanScreen(),
        ),
      const _HomeTab(
        label: 'Profil',
        icon: Icons.person_outline,
        activeIcon: Icons.person,
        content: ProfileScreen(),
      ),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: tabs.map((tab) => tab.content).toList(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (value) => setState(() => _index = value),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppPalette.primary,
        unselectedItemColor: AppPalette.textMuted,
        items: [
          for (final tab in tabs)
            BottomNavigationBarItem(
              icon: Icon(tab.icon),
              activeIcon: Icon(tab.activeIcon),
              label: tab.label,
            ),
        ],
      ),
    );
  }
}

class _HomeTab {
  const _HomeTab({
    required this.label,
    required this.icon,
    required this.activeIcon,
    required this.content,
  });

  final String label;
  final IconData icon;
  final IconData activeIcon;
  final Widget content;
}
