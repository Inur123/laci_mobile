import 'package:flutter/material.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../app/app.dart';

part '../models/periode_models.dart';
part '../widgets/periode_widgets.dart';

class PeriodeScreen extends StatefulWidget {
  const PeriodeScreen({super.key, required this.initialPeriods});

  final List<Periode> initialPeriods;

  @override
  State<PeriodeScreen> createState() => _PeriodeScreenState();
}

class _PeriodeScreenState extends State<PeriodeScreen> {
  late List<Periode> _periods;

  @override
  void initState() {
    super.initState();
    _periods = List<Periode>.from(widget.initialPeriods);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kelola Periode'),
        leading: BackButton(
          onPressed: () => Navigator.of(context).pop(_periods),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Daftar Periode',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  FilledButton.icon(
                    onPressed: _addPeriode,
                    icon: const Icon(Icons.add),
                    label: const Text('Tambah'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: _periods.length,
                itemBuilder: (context, index) {
                  final item = _periods[index];
                  return PeriodeItem(
                    item: item,
                    onEdit: () => _editPeriode(index),
                    onDelete: () => _deletePeriode(index),
                    onToggleActive: () => _setActive(index),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _setActive(int index) {
    setState(() {
      for (int i = 0; i < _periods.length; i++) {
        _periods[i] = _periods[i].copyWith(isActive: i == index);
      }
    });
  }

  void _addPeriode() {
    final parentContext = context;
    final controller = TextEditingController();
    bool active = false;
    String? nameError;
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Tambah Periode',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Row(
                      children: [
                        Text(
                          'Nama Periode',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          ' *',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppPalette.error,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: controller,
                      onChanged: (value) {
                        if (nameError != null && value.trim().isNotEmpty) {
                          setModalState(() => nameError = null);
                        }
                      },
                      decoration: InputDecoration(
                        hintText: nameError != null
                            ? 'Wajib diisi'
                            : 'Contoh: 2025-2026',
                        hintStyle: nameError != null
                            ? const TextStyle(color: AppPalette.error)
                            : null,
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(
                            color: nameError != null
                                ? AppPalette.error
                                : AppPalette.border,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(
                            color: nameError != null
                                ? AppPalette.error
                                : AppPalette.border,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(
                            color: nameError != null
                                ? AppPalette.error
                                : AppPalette.border,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Expanded(child: Text('Aktif')),
                        Switch(
                          value: active,
                          onChanged: (v) => setModalState(() => active = v),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Batal'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: FilledButton(
                            onPressed: () {
                              final name = controller.text.trim();
                              if (name.isEmpty) {
                                setModalState(
                                  () => nameError = 'Nama periode wajib diisi',
                                );
                                return;
                              } else {
                                setModalState(() => nameError = null);
                              }
                              if (_periods.isEmpty && !active) {
                                AppNotify.error(
                                  context,
                                  'Periode pertama harus Aktif.',
                                );
                                return;
                              }
                              setState(() {
                                if (active) {
                                  for (int i = 0; i < _periods.length; i++) {
                                    _periods[i] = _periods[i].copyWith(
                                      isActive: false,
                                    );
                                  }
                                }
                                _periods.insert(
                                  0,
                                  Periode(nama: name, isActive: active),
                                );
                              });
                              if (parentContext.mounted) {
                                AppNotify.info(
                                  parentContext,
                                  'Periode berhasil ditambahkan',
                                );
                              }
                              Navigator.of(context).pop();
                            },
                            child: const Text('Simpan'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _editPeriode(int index) {
    final item = _periods[index];
    final controller = TextEditingController(text: item.nama);
    bool active = item.isActive;
    String? nameError;
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Ubah Periode',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Row(
                      children: [
                        Text(
                          'Nama Periode',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          ' *',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppPalette.error,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: controller,
                      onChanged: (value) {
                        if (nameError != null && value.trim().isNotEmpty) {
                          setModalState(() => nameError = null);
                        }
                      },
                      decoration: InputDecoration(
                        hintText: nameError != null
                            ? 'Wajib diisi'
                            : 'Contoh: 2025-2026',
                        hintStyle: nameError != null
                            ? const TextStyle(color: AppPalette.error)
                            : null,
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(
                            color: nameError != null
                                ? AppPalette.error
                                : AppPalette.border,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(
                            color: nameError != null
                                ? AppPalette.error
                                : AppPalette.border,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(
                            color: nameError != null
                                ? AppPalette.error
                                : AppPalette.border,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Expanded(child: Text('Aktif')),
                        Switch(
                          value: active,
                          onChanged: (v) => setModalState(() => active = v),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Batal'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: FilledButton(
                            onPressed: () {
                              final name = controller.text.trim();
                              if (name.isEmpty) {
                                setModalState(
                                  () => nameError = 'Nama periode wajib diisi',
                                );
                                return;
                              } else {
                                setModalState(() => nameError = null);
                              }
                              final onlyActiveThis =
                                  item.isActive &&
                                  _periods.where((p) => p.isActive).length == 1;
                              if (onlyActiveThis && !active) {
                                AppNotify.error(
                                  context,
                                  'Minimal satu periode harus aktif.',
                                );
                                return;
                              }
                              setState(() {
                                if (active) {
                                  for (int i = 0; i < _periods.length; i++) {
                                    if (i == index) continue;
                                    _periods[i] = _periods[i].copyWith(
                                      isActive: false,
                                    );
                                  }
                                }
                                _periods[index] = _periods[index].copyWith(
                                  nama: name,
                                  isActive: active,
                                );
                              });
                              Navigator.of(context).pop();
                            },
                            child: const Text('Simpan'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _deletePeriode(int index) async {
    final item = _periods[index];
    if (item.isActive) {
      AppNotify.error(context, 'Tidak bisa menghapus periode aktif.');
      return;
    }
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Hapus Periode?'),
          content: Text('Periode "${item.nama}" akan dihapus.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Batal'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );
    if (result == true) {
      setState(() {
        _periods.removeAt(index);
      });
      if (mounted) {
        AppNotify.info(context, 'Periode berhasil dihapus');
      }
    }
  }
}
