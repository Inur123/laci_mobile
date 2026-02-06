import 'package:flutter/material.dart';
import '../../../core/theme/app_palette.dart';
import '../../../app/app.dart';
import '../periode/screens/periode_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
    required this.isCabang,
    required this.onLogout,
  });

  final bool isCabang;
  final VoidCallback onLogout;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _passwordController;
  bool _isEditing = false;
  bool _isVerified = false;
  String? _photoPath;
  final List<_Periode> _periodes = [
    _Periode('2025-2026', true),
    _Periode('2023-2024', false),
    _Periode('2021-2022', false),
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: 'PAC A');
    _emailController = TextEditingController(text: 'a@x.id');
    _phoneController = TextEditingController(text: '0812xxxxxxx');
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final roleLabel = widget.isCabang ? 'Sekretaris Cabang' : 'Sekretaris PAC';

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Profil',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppPalette.border),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Container(
                      height: 62,
                      width: 62,
                      color: AppPalette.primarySoft,
                      child: _photoPath == null
                          ? const Icon(Icons.person, color: AppPalette.primary)
                          : Image.file(File(_photoPath!), fit: BoxFit.cover),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _nameController.text,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _emailController.text,
                          style: const TextStyle(color: AppPalette.textMuted),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          roleLabel,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppPalette.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  OutlinedButton(
                    onPressed: _pickPhoto,
                    child: const Text('Ubah Foto'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _ProfileTile(
              icon: Icons.verified_user,
              title: 'Status Verifikasi',
              subtitle: _isVerified ? 'Terverifikasi' : 'Belum verifikasi',
              trailing: _isVerified ? 'Aman' : 'Perlu verifikasi',
            ),
            if (!_isVerified) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppPalette.border),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.mail_lock, color: AppPalette.primary),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Email belum terverifikasi. Verifikasi untuk keamanan akun.',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    FilledButton(
                      onPressed: () {
                        AppLoader.show();
                        Future<void>.delayed(
                          const Duration(milliseconds: 600),
                        ).then((_) {
                          if (!mounted) return;
                          AppLoader.hide();
                          setState(() => _isVerified = true);
                          AppNotify.info(
                            context,
                            'Email terverifikasi (dummy).',
                          );
                        });
                      },
                      child: const Text('Verifikasi'),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppPalette.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Periode Organisasi',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                      OutlinedButton.icon(
                        onPressed: _managePeriode,
                        icon: const Icon(Icons.settings),
                        label: const Text('Kelola Periode'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Builder(
                    builder: (context) {
                      final active = _periodes
                          .where((p) => p.isActive)
                          .toList();
                      if (active.isEmpty) {
                        return const Text(
                          'Belum ada periode aktif.',
                          style: TextStyle(color: AppPalette.textMuted),
                        );
                      }
                      return _PeriodeItem(
                        item: active.first,
                        onEdit: () =>
                            _editPeriode(_periodes.indexOf(active.first)),
                        onDelete: () =>
                            _deletePeriode(_periodes.indexOf(active.first)),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _ProfileField(
              label: 'Nama Lengkap',
              controller: _nameController,
              enabled: _isEditing,
              trailing: TextButton(
                onPressed: () => setState(() => _isEditing = !_isEditing),
                child: Text(_isEditing ? 'Selesai' : 'Ubah'),
              ),
            ),
            const SizedBox(height: 12),
            const SizedBox(height: 12),
            _ProfileField(
              label: 'Email',
              controller: _emailController,
              enabled: _isEditing,
            ),
            const SizedBox(height: 12),
            _ProfileField(
              label: 'No HP',
              controller: _phoneController,
              enabled: _isEditing,
            ),
            const SizedBox(height: 12),
            _ProfileField(
              label: 'Kata Sandi Baru',
              controller: _passwordController,
              obscureText: true,
              hintText: 'Minimal 6 karakter',
              enabled: _isEditing,
            ),
            if (_isEditing) ...[
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    AppLoader.show();
                    Future<void>.delayed(
                      const Duration(milliseconds: 600),
                    ).then((_) {
                      if (!mounted) return;
                      AppLoader.hide();
                      AppNotify.info(context, 'Profil tersimpan (dummy).');
                    });
                    setState(() => _isEditing = false);
                  },
                  child: const Text('Simpan Perubahan'),
                ),
              ),
            ],
            const SizedBox(height: 20),
            _ProfileAction(
              icon: Icons.logout,
              title: 'Keluar',
              subtitle: 'Logout dari aplikasi',
              onTap: () => _confirmLogout(context),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _managePeriode() async {
    final initial = _periodes
        .map((e) => Periode(nama: e.nama, isActive: e.isActive))
        .toList();
    final result = await Navigator.of(context).push<List<Periode>>(
      MaterialPageRoute(
        builder: (context) {
          return PeriodeScreen(initialPeriods: initial);
        },
      ),
    );
    if (result != null && mounted) {
      setState(() {
        _periodes
          ..clear()
          ..addAll(result.map((e) => _Periode(e.nama, e.isActive)));
      });
    }
  }

  Future<void> _confirmLogout(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Keluar dari akun?'),
          content: const Text('Kamu akan kembali ke halaman login.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Batal'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Keluar'),
            ),
          ],
        );
      },
    );
    if (result == true) {
      AppLoader.show();
      await Future<void>.delayed(const Duration(milliseconds: 600));
      AppLoader.hide();
      widget.onLogout();
    }
  }

  void _editPeriode(int index) {
    final item = _periodes[index];
    final controller = TextEditingController(text: item.nama);
    bool active = item.isActive;
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Ubah Periode'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller,
                decoration: const InputDecoration(labelText: 'Nama Periode'),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Expanded(child: Text('Aktif')),
                  StatefulBuilder(
                    builder: (context, setStateDialog) {
                      return Switch(
                        value: active,
                        onChanged: (v) {
                          setStateDialog(() {
                            active = v;
                          });
                        },
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Batal'),
            ),
            FilledButton(
              onPressed: () {
                if (controller.text.trim().isEmpty) return;
                setState(() {
                  if (active) {
                    for (int i = 0; i < _periodes.length; i++) {
                      if (i == index) continue;
                      _periodes[i] = _Periode(_periodes[i].nama, false);
                    }
                  }
                  _periodes[index] = _Periode(controller.text.trim(), active);
                });
                Navigator.of(context).pop();
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  void _deletePeriode(int index) {
    final item = _periodes[index];
    if (item.isActive) {
      AppNotify.error(context, 'Tidak bisa menghapus periode aktif.');
      return;
    }
    showDialog<bool>(
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
    ).then((value) {
      if (value == true) {
        setState(() {
          _periodes.removeAt(index);
        });
      }
    });
  }

  Future<void> _pickPhoto() async {
    final source = await _showPhotoSourceSheet();
    if (source == null) return;
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: source,
      imageQuality: 85,
    );
    if (image == null) return;
    if (!mounted) return;
    setState(() {
      _photoPath = image.path;
    });
    AppNotify.info(context, 'Foto profil diperbarui (dummy).');
  }

  Future<ImageSource?> _showPhotoSourceSheet() {
    return showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Pilih sumber foto',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 12),
                _PhotoSourceTile(
                  icon: Icons.camera_alt,
                  label: 'Kamera',
                  onTap: () => Navigator.of(context).pop(ImageSource.camera),
                ),
                const SizedBox(height: 12),
                _PhotoSourceTile(
                  icon: Icons.photo_library,
                  label: 'Galeri',
                  onTap: () => Navigator.of(context).pop(ImageSource.gallery),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Batal'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ProfileTile extends StatelessWidget {
  const _ProfileTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.trailing,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
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
          if (trailing.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppPalette.primarySoft,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                trailing,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppPalette.primaryDark,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _PhotoSourceTile extends StatelessWidget {
  const _PhotoSourceTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
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
              child: Text(
                label,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            const Icon(Icons.chevron_right, color: AppPalette.textMuted),
          ],
        ),
      ),
    );
  }
}

class _ProfileField extends StatelessWidget {
  const _ProfileField({
    required this.label,
    required this.controller,
    required this.enabled,
    this.obscureText = false,
    this.hintText,
    this.trailing,
  });

  final String label;
  final TextEditingController controller;
  final bool enabled;
  final bool obscureText;
  final String? hintText;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            trailing ?? const SizedBox.shrink(),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscureText,
          enabled: enabled,
          decoration: InputDecoration(
            hintText: hintText,
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: AppPalette.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: AppPalette.border),
            ),
          ),
        ),
      ],
    );
  }
}

class _ProfileAction extends StatelessWidget {
  const _ProfileAction({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
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
          ],
        ),
      ),
    );
  }
}

class _Periode {
  _Periode(this.nama, this.isActive);
  final String nama;
  final bool isActive;
}

class _PeriodeItem extends StatelessWidget {
  const _PeriodeItem({
    required this.item,
    required this.onEdit,
    required this.onDelete,
  });

  final _Periode item;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppPalette.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              item.nama,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
        ],
      ),
    );
  }
}
