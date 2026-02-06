part of '../screens/periode_screen.dart';

class PeriodeItem extends StatelessWidget {
  const PeriodeItem({
    super.key,
    required this.item,
    required this.onEdit,
    required this.onDelete,
    required this.onToggleActive,
  });

  final Periode item;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onToggleActive;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onEdit,
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
              child: const Icon(Icons.event, color: AppPalette.primary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.nama,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: onToggleActive,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: item.isActive
                                ? AppPalette.primarySoft
                                : AppPalette.surface,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppPalette.border),
                          ),
                          child: Text(
                            item.isActive ? 'Aktif' : 'Nonaktif',
                            style: TextStyle(
                              fontSize: 11,
                              color: item.isActive
                                  ? AppPalette.primaryDark
                                  : AppPalette.textMuted,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: onEdit,
              icon: const Icon(Icons.edit_outlined),
              color: AppPalette.primary,
            ),
            IconButton(
              onPressed: item.isActive ? null : onDelete,
              icon: const Icon(Icons.delete_outline),
              color: item.isActive ? AppPalette.textMuted : AppPalette.error,
            ),
          ],
        ),
      ),
    );
  }
}
