import 'package:flutter/material.dart';
import '../section_placeholder.dart';

class KegiatanScreen extends StatelessWidget {
  const KegiatanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: SectionPlaceholder(
        title: 'Kegiatan',
        subtitle: 'Pantau agenda dan status kegiatan cabang.',
        icon: Icons.event_note,
      ),
    );
  }
}
