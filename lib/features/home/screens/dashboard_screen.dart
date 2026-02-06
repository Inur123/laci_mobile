import 'package:flutter/material.dart';
import '../../../core/theme/app_palette.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key, required this.isCabang});

  final bool isCabang;

  @override
  Widget build(BuildContext context) {
    final roleLabel = isCabang ? 'Sekretaris Cabang' : 'Sekretaris PAC';
    final stats = isCabang
        ? const [
            _StatData('Arsip Surat', '12', Icons.mail),
            _StatData('Berkas SP', '6', Icons.article),
            _StatData('Kegiatan', '5', Icons.event),
            _StatData('Anggota', '240', Icons.group),
          ]
        : const [
            _StatData('Arsip Surat', '12', Icons.mail),
            _StatData('Berkas', '16', Icons.folder),
            _StatData('Pengajuan', '4', Icons.send),
            _StatData('Anggota', '128', Icons.group),
          ];
    final quickActions = isCabang
        ? const [
            _QuickActionData('Tambah Arsip', Icons.add),
            _QuickActionData('Buat Kegiatan', Icons.event_available),
            _QuickActionData('Verifikasi PAC', Icons.verified_user),
          ]
        : const [
            _QuickActionData('Tambah Arsip', Icons.add),
            _QuickActionData('Tambah Anggota', Icons.person_add),
            _QuickActionData('Ajukan Surat', Icons.send),
          ];
    final activities = isCabang
        ? const [
            _ActivityData(
              'Berkas SP',
              'Ketua PC IPNU',
              '2 jam lalu',
              Icons.article,
            ),
            _ActivityData(
              'Kegiatan',
              'Rapat koordinasi',
              '5 jam lalu',
              Icons.event,
            ),
            _ActivityData(
              'Pengajuan',
              'PAC A disetujui',
              'Kemarin',
              Icons.send,
            ),
          ]
        : const [
            _ActivityData(
              'Arsip Surat',
              'Undangan rapat',
              '1 jam lalu',
              Icons.mail,
            ),
            _ActivityData(
              'Pengajuan',
              'Menunggu verifikasi',
              '4 jam lalu',
              Icons.send,
            ),
            _ActivityData(
              'Anggota',
              'Ahmad ditambahkan',
              'Kemarin',
              Icons.group,
            ),
          ];

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppPalette.primary, AppPalette.primaryDark],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppPalette.primary.withValues(alpha: 0.18),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.person, color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          roleLabel,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Selamat datang kembali',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Periode 2025-2026',
                      style: TextStyle(fontSize: 11, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                for (final item in stats)
                  _StatCard(
                    title: item.title,
                    value: item.value,
                    icon: item.icon,
                  ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Aksi Cepat',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                for (final action in quickActions)
                  _QuickActionButton(title: action.title, icon: action.icon),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Aktivitas Terbaru',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            Column(
              children: [
                for (final activity in activities)
                  _ActivityTile(
                    title: activity.title,
                    subtitle: activity.subtitle,
                    timeLabel: activity.timeLabel,
                    icon: activity.icon,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatData {
  const _StatData(this.title, this.value, this.icon);

  final String title;
  final String value;
  final IconData icon;
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  final String title;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppPalette.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 36,
            width: 36,
            decoration: BoxDecoration(
              color: AppPalette.primarySoft,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppPalette.primary, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(fontSize: 12, color: AppPalette.textMuted),
          ),
        ],
      ),
    );
  }
}

class _QuickActionData {
  const _QuickActionData(this.title, this.icon);

  final String title;
  final IconData icon;
}

class _QuickActionButton extends StatelessWidget {
  const _QuickActionButton({required this.title, required this.icon});

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () {},
      icon: Icon(icon),
      label: Text(title),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }
}

class _ActivityData {
  const _ActivityData(this.title, this.subtitle, this.timeLabel, this.icon);

  final String title;
  final String subtitle;
  final String timeLabel;
  final IconData icon;
}

class _ActivityTile extends StatelessWidget {
  const _ActivityTile({
    required this.title,
    required this.subtitle,
    required this.timeLabel,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final String timeLabel;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppPalette.border),
      ),
      child: Row(
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: AppPalette.primarySoft,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppPalette.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(color: AppPalette.textMuted),
                ),
              ],
            ),
          ),
          Text(
            timeLabel,
            style: const TextStyle(fontSize: 11, color: AppPalette.textMuted),
          ),
        ],
      ),
    );
  }
}
