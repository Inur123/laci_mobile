import 'package:flutter/material.dart';
import '../../../core/theme/app_palette.dart';
import '../section_placeholder.dart';

class ArsipScreen extends StatelessWidget {
  const ArsipScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Arsip',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.search, color: AppPalette.textMuted),
                ),
              ],
            ),
          ),
          const Expanded(
            child: SectionPlaceholder(
              title: 'Arsip Surat & Berkas',
              subtitle: 'Kelola arsip surat, berkas pimpinan, dan berkas SP.',
              icon: Icons.folder_open,
            ),
          ),
        ],
      ),
    );
  }
}
