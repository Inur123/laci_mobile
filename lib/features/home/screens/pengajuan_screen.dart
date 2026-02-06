import 'package:flutter/material.dart';
import '../section_placeholder.dart';

class PengajuanScreen extends StatelessWidget {
  const PengajuanScreen({super.key});

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
                    'Pengajuan PAC',
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
          const Expanded(
            child: SectionPlaceholder(
              title: 'Daftar Pengajuan',
              subtitle:
                  'Pengajuan baru akan tampil di sini sesuai status dan periode.',
              icon: Icons.send,
            ),
          ),
        ],
      ),
    );
  }
}
