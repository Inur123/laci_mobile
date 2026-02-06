part of '../screens/arsip_screen.dart';

class _ArsipCard extends StatelessWidget {
  const _ArsipCard({required this.item, required this.onTap});

  final _ArsipItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
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
              height: 44,
              width: 44,
              decoration: BoxDecoration(
                color: AppPalette.primarySoft,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.folder, color: AppPalette.primary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.type == _ArsipType.surat
                        ? (item.nomorSurat ?? item.title)
                        : item.type == _ArsipType.pimpinan
                        ? (item.nama ?? item.title)
                        : (item.namaPimpinan ?? item.title),
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.type == _ArsipType.surat
                        ? (item.perihal ?? item.subtitle)
                        : item.type == _ArsipType.pimpinan
                        ? (item.catatan ?? item.subtitle)
                        : (item.catatan ?? item.subtitle),
                    style: const TextStyle(color: AppPalette.textMuted),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      if (item.type == _ArsipType.surat) ...[
                        _TagChip(label: item.jenisSurat ?? ''),
                        const SizedBox(width: 8),
                        _TagChip(label: item.organisasi ?? ''),
                        const SizedBox(width: 8),
                      ] else if (item.type == _ArsipType.sp) ...[
                        _TagChip(label: item.organisasi ?? ''),
                        const SizedBox(width: 8),
                      ],
                      Text(
                        item.type == _ArsipType.surat
                            ? (item.tanggalSurat ?? item.dateLabel)
                            : item.type == _ArsipType.pimpinan
                            ? (item.tanggal ?? item.dateLabel)
                            : (item.tanggalMulai ?? item.dateLabel),
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppPalette.textMuted,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppPalette.textMuted),
          ],
        ),
      ),
    );
  }
}

class _TagChip extends StatelessWidget {
  const _TagChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppPalette.primarySoft,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 11, color: AppPalette.primaryDark),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: const TextStyle(
                color: AppPalette.textMuted,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
