import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../core/theme/app_palette.dart';

class FormActionField extends StatelessWidget {
  const FormActionField({
    super.key,
    required this.label,
    required this.valueText,
    required this.onTap,
    this.placeholder,
    this.isError = false,
  });

  final String label;
  final String valueText;
  final VoidCallback onTap;
  final String? placeholder;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isError ? AppPalette.error : AppPalette.border,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            Text(
              valueText.isEmpty ? (placeholder ?? 'Pilih') : valueText,
              style: TextStyle(
                color: isError
                    ? AppPalette.error
                    : (valueText.isEmpty
                          ? AppPalette.primary
                          : AppPalette.textMuted),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 6),
            const Icon(Icons.chevron_right, color: AppPalette.textMuted),
          ],
        ),
      ),
    );
  }
}

class LabeledActionField extends StatelessWidget {
  const LabeledActionField({
    super.key,
    required this.label,
    required this.valueText,
    required this.onTap,
    this.backgroundColor = Colors.white,
    this.placeholder,
    this.isError = false,
    this.isRequired = false,
  });

  final String label;
  final String valueText;
  final VoidCallback onTap;
  final Color backgroundColor;
  final String? placeholder;
  final bool isError;
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
            if (isRequired)
              const Text(
                ' *',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppPalette.error,
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isError ? AppPalette.error : AppPalette.border,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    valueText.isEmpty ? (placeholder ?? 'Pilih') : valueText,
                    style: TextStyle(
                      color: isError
                          ? AppPalette.error
                          : (valueText.isEmpty
                                ? AppPalette.primary
                                : AppPalette.textMuted),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Icon(Icons.chevron_right, color: AppPalette.textMuted),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

Future<String?> showSelectSheet({
  required BuildContext context,
  required String title,
  required List<String> options,
  String? initialValue,
}) async {
  int index = initialValue != null ? options.indexOf(initialValue) : 0;
  if (index < 0) index = 0;
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    builder: (context) {
      return SafeArea(
        child: StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      Text(
                        title,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Batal'),
                      ),
                    ],
                  ),
                ),
                for (var i = 0; i < options.length; i++)
                  ListTile(
                    title: Text(options[i]),
                    trailing: index == i
                        ? const Icon(Icons.check, color: AppPalette.primary)
                        : null,
                    onTap: () => setState(() => index = i),
                  ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () =>
                          Navigator.of(context).pop(options[index]),
                      child: const Text('Konfirmasi'),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      );
    },
  );
}

Future<DateTime?> showDateSheet({
  required BuildContext context,
  required String title,
  DateTime? initialValue,
}) async {
  DateTime selected = initialValue ?? DateTime.now();
  return showModalBottomSheet<DateTime>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    builder: (context) {
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Batal'),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 220,
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                initialDateTime: selected,
                onDateTimeChanged: (date) => selected = date,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.of(context).pop(selected),
                  child: const Text('Selesai'),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

Future<String?> showUploadSheet({
  required BuildContext context,
  required String title,
}) async {
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    builder: (context) {
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Batal'),
                  ),
                ],
              ),
            ),
            ListTile(
              title: const Center(child: Text('Pilih File')),
              onTap: () => Navigator.of(context).pop('file'),
            ),
            const Divider(height: 1),
            ListTile(
              title: const Center(child: Text('Batalkan')),
              onTap: () => Navigator.of(context).pop(),
            ),
            const SizedBox(height: 10),
          ],
        ),
      );
    },
  );
}
