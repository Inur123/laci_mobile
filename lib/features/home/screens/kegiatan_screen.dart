import 'package:flutter/material.dart';
import '../../../core/theme/app_palette.dart';

class KegiatanScreen extends StatelessWidget {
  const KegiatanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const items = [
      _KegiatanItem(
        title: 'Rapat Koordinasi',
        subtitle: 'Aula PC IPNU',
        dateLabel: '10 Feb 2026, 09.00',
        status: 'MENDATANG',
        color: Color(0xFF22C55E),
      ),
      _KegiatanItem(
        title: 'Pelatihan Administrasi',
        subtitle: 'Sekretariat Cabang',
        dateLabel: '05 Feb 2026, 13.00',
        status: 'BERLANGSUNG',
        color: Color(0xFFF59E0B),
      ),
      _KegiatanItem(
        title: 'Musyawarah Cabang',
        subtitle: 'Gedung Serbaguna',
        dateLabel: '25 Jan 2026, 09.00',
        status: 'SELESAI',
        color: Color(0xFF94A3B8),
      ),
    ];

    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Kegiatan',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                ),
                FilledButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add),
                  label: const Text('Tambah'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return _KegiatanCard(item: item);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _KegiatanItem {
  const _KegiatanItem({
    required this.title,
    required this.subtitle,
    required this.dateLabel,
    required this.status,
    required this.color,
  });

  final String title;
  final String subtitle;
  final String dateLabel;
  final String status;
  final Color color;
}

class _KegiatanCard extends StatelessWidget {
  const _KegiatanCard({required this.item});

  final _KegiatanItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppPalette.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 46,
            width: 46,
            decoration: BoxDecoration(
              color: item.color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(Icons.event, color: item.color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text(
                  item.subtitle,
                  style: const TextStyle(color: AppPalette.textMuted),
                ),
                const SizedBox(height: 8),
                Text(
                  item.dateLabel,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppPalette.textMuted,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: item.color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              item.status,
              style: TextStyle(fontSize: 11, color: item.color),
            ),
          ),
        ],
      ),
    );
  }
}
