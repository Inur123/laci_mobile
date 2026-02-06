import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:open_filex/open_filex.dart';
import '../../../../app/app.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../shared/widgets/pickers.dart';

part '../models/pengajuan_models.dart';
part '../widgets/pengajuan_widgets.dart';

class PengajuanScreen extends StatefulWidget {
  const PengajuanScreen({super.key, required this.isCabang});

  final bool isCabang;

  @override
  State<PengajuanScreen> createState() => _PengajuanScreenState();
}

class _PengajuanScreenState extends State<PengajuanScreen> {
  int _statusIndex = 0;
  final TextEditingController _searchController = TextEditingController();

  final _statusFilters = const ['Semua', 'PENDING', 'DITERIMA', 'DITOLAK'];

  late List<_PengajuanItem> _items;

  @override
  void initState() {
    super.initState();
    _items = List<_PengajuanItem>.from(
      widget.isCabang ? _seedCabangItems : _seedPacItems,
    );
  }

  static const _seedCabangItems = [
    _PengajuanItem(
      nomorSurat: '001/PAC/2026',
      penerima: 'IPNU',
      tanggal: '01 Feb 2026',
      keperluan: 'Pengajuan kegiatan',
      deskripsi: 'Permohonan surat tugas kegiatan kaderisasi',
      status: 'PENDING',
      fileUrl: 'pengajuan-pac/surat-tugas.pdf',
      fileName: 'surat-tugas.pdf',
      fileMime: 'application/pdf',
      fileSize: 120000,
    ),
    _PengajuanItem(
      nomorSurat: '002/PAC/2026',
      penerima: 'IPNU',
      tanggal: '03 Feb 2026',
      keperluan: 'Pengajuan dana',
      deskripsi: 'Permohonan dana kegiatan pelatihan',
      status: 'DITERIMA',
      fileUrl: 'pengajuan-pac/pengajuan-dana.pdf',
      fileName: 'pengajuan-dana.pdf',
      fileMime: 'application/pdf',
      fileSize: 98000,
    ),
    _PengajuanItem(
      nomorSurat: '003/PAC/2026',
      penerima: 'IPNU',
      tanggal: '30 Jan 2026',
      keperluan: 'Pengajuan program kerja',
      deskripsi: 'Rincian program kerja triwulan',
      status: 'DITOLAK',
      fileUrl: 'pengajuan-pac/program-kerja.pdf',
      fileName: 'program-kerja.pdf',
      fileMime: 'application/pdf',
      fileSize: 160000,
    ),
  ];

  static const _seedPacItems = [
    _PengajuanItem(
      nomorSurat: '001/PAC/2026',
      penerima: 'IPNU',
      tanggal: '01 Feb 2026',
      keperluan: 'Pengajuan kegiatan',
      deskripsi: 'Pengajuan surat tugas kegiatan',
      status: 'PENDING',
      fileUrl: 'pengajuan-pac/surat-tugas.pdf',
      fileName: 'surat-tugas.pdf',
      fileMime: 'application/pdf',
      fileSize: 120000,
    ),
    _PengajuanItem(
      nomorSurat: '002/PAC/2026',
      penerima: 'IPNU',
      tanggal: '29 Jan 2026',
      keperluan: 'Pengajuan dana',
      deskripsi: 'Rincian kebutuhan dana kegiatan',
      status: 'DITERIMA',
      fileUrl: 'pengajuan-pac/pengajuan-dana.pdf',
      fileName: 'pengajuan-dana.pdf',
      fileMime: 'application/pdf',
      fileSize: 104000,
    ),
    _PengajuanItem(
      nomorSurat: '003/PAC/2026',
      penerima: 'IPNU',
      tanggal: '25 Jan 2026',
      keperluan: 'Pengajuan program kerja',
      deskripsi: 'Lampiran program kerja periode aktif',
      status: 'DITOLAK',
      fileUrl: 'pengajuan-pac/program-kerja.pdf',
      fileName: 'program-kerja.pdf',
      fileMime: 'application/pdf',
      fileSize: 145000,
    ),
  ];

  List<_PengajuanItem> get _filteredItems {
    final status = _statusFilters[_statusIndex];
    final base = status == 'Semua'
        ? _items
        : _items.where((item) => item.status == status).toList();
    final q = _searchController.text.trim().toLowerCase();
    if (q.isEmpty) return base;
    return base.where((it) {
      return it.nomorSurat.toLowerCase().contains(q) ||
          it.keperluan.toLowerCase().contains(q) ||
          it.penerima.toLowerCase().contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final items = _filteredItems;

    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Pengajuan PAC',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                ),
                if (!widget.isCabang)
                  FilledButton.icon(
                    onPressed: () => _showForm(context),
                    icon: const Icon(Icons.add),
                    label: const Text('Tambah'),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      hintText: 'Cari nomor surat, penerima, atau keperluan',
                      prefixIcon: const Icon(Icons.search),
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
                ),
                const SizedBox(width: 12),
                Container(
                  height: 46,
                  width: 46,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppPalette.border),
                  ),
                  child: const Icon(
                    Icons.filter_list,
                    color: AppPalette.textMuted,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 44,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              itemCount: _statusFilters.length,
              separatorBuilder: (context, index) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                return ChoiceChip(
                  label: Text(_statusFilters[index]),
                  selected: _statusIndex == index,
                  onSelected: (value) {
                    if (value) setState(() => _statusIndex = index);
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 6),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return _PengajuanCard(
                  item: item,
                  onDetail: () => _showDetail(context, item),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showForm(BuildContext context) async {
    final parentContext = context;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        String? fileName;
        String? penerima;
        DateTime? tanggal;
        final nomorController = TextEditingController();
        final keperluanController = TextEditingController();
        final deskripsiController = TextEditingController();
        String? nomorError,
            keperluanError,
            penerimaError,
            tanggalError,
            fileError;
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Form Pengajuan PAC',
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
                  const SizedBox(height: 16),
                  const Row(
                    children: [
                      Text(
                        'Nomor Surat',
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
                    controller: nomorController,
                    onChanged: (value) {
                      if (nomorError != null && value.trim().isNotEmpty) {
                        setModalState(() => nomorError = null);
                      }
                    },
                    decoration: InputDecoration(
                      hintText: nomorError != null
                          ? 'Wajib diisi'
                          : '002/PAC/2026',
                      hintStyle: nomorError != null
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
                          color: nomorError != null
                              ? AppPalette.error
                              : AppPalette.border,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(
                          color: nomorError != null
                              ? AppPalette.error
                              : AppPalette.border,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(
                          color: nomorError != null
                              ? AppPalette.error
                              : AppPalette.border,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  LabeledActionField(
                    label: 'Penerima',
                    valueText: penerima ?? '',
                    placeholder: 'Pilih Penerima',
                    isError: penerimaError != null,
                    isRequired: true,
                    onTap: () async {
                      final val = await showSelectSheet(
                        context: context,
                        title: 'Pilih Penerima',
                        options: const ['IPNU', 'IPPNU', 'BERSAMA'],
                        initialValue: penerima,
                      );
                      if (val != null) {
                        setModalState(() {
                          penerima = val;
                          penerimaError = null;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  const SizedBox(height: 12),
                  LabeledActionField(
                    label: 'Tanggal',
                    valueText: tanggal == null
                        ? ''
                        : '${tanggal!.year}-${tanggal!.month.toString().padLeft(2, '0')}-${tanggal!.day.toString().padLeft(2, '0')}',
                    placeholder: 'Pilih Tanggal',
                    isError: tanggalError != null,
                    isRequired: true,
                    onTap: () async {
                      final val = await showDateSheet(
                        context: context,
                        title: 'Pilih Tanggal',
                        initialValue: tanggal,
                      );
                      if (val != null) {
                        setModalState(() {
                          tanggal = val;
                          tanggalError = null;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  const SizedBox(height: 12),
                  const Row(
                    children: [
                      Text(
                        'Keperluan',
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
                    controller: keperluanController,
                    onChanged: (value) {
                      if (keperluanError != null && value.trim().isNotEmpty) {
                        setModalState(() => keperluanError = null);
                      }
                    },
                    decoration: InputDecoration(
                      hintText: keperluanError != null
                          ? 'Wajib diisi'
                          : 'Kebutuhan surat',
                      hintStyle: keperluanError != null
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
                          color: keperluanError != null
                              ? AppPalette.error
                              : AppPalette.border,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(
                          color: keperluanError != null
                              ? AppPalette.error
                              : AppPalette.border,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(
                          color: keperluanError != null
                              ? AppPalette.error
                              : AppPalette.border,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Deskripsi',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: deskripsiController,
                    decoration: InputDecoration(
                      hintText: 'Rincian singkat',
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
                  const SizedBox(height: 16),
                  LabeledActionField(
                    label: 'Upload File',
                    valueText: fileName ?? '',
                    placeholder: fileError != null
                        ? 'Wajib diisi'
                        : 'Pilih File',
                    isError: fileError != null,
                    isRequired: true,
                    onTap: () async {
                      try {
                        final res = await FilePicker.platform.pickFiles(
                          allowMultiple: false,
                        );
                        if (res != null && res.files.isNotEmpty) {
                          final f = res.files.first;
                          setModalState(() {
                            fileName = f.name;
                            fileError = null;
                          });
                        }
                      } catch (_) {
                        if (context.mounted) {
                          AppNotify.error(
                            context,
                            'File picker tidak tersedia',
                          );
                        }
                      }
                    },
                  ),
                  if (fileName != null) ...[
                    const SizedBox(height: 12),
                    Row(children: [_TagChip(label: fileName!)]),
                  ],
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
                            final nomor = nomorController.text.trim();
                            final keperluan = keperluanController.text.trim();
                            final valid =
                                nomor.isNotEmpty &&
                                (penerima != null && penerima!.isNotEmpty) &&
                                tanggal != null &&
                                keperluan.isNotEmpty &&
                                (fileName ?? '').trim().isNotEmpty;
                            if (!valid) {
                              setModalState(() {
                                nomorError = nomor.isEmpty
                                    ? 'Wajib diisi'
                                    : null;
                                keperluanError = keperluan.isEmpty
                                    ? 'Wajib diisi'
                                    : null;
                                fileError = (fileName ?? '').trim().isEmpty
                                    ? 'Wajib diisi'
                                    : null;
                                penerimaError =
                                    (penerima == null || penerima!.isEmpty)
                                    ? 'Wajib diisi'
                                    : null;
                                tanggalError = tanggal == null
                                    ? 'Wajib diisi'
                                    : null;
                              });
                              return;
                            }
                            Navigator.of(context).pop();
                            if (parentContext.mounted) {
                              AppNotify.info(
                                parentContext,
                                'Pengajuan berhasil ditambahkan',
                              );
                            }
                          },
                          child: const Text('Simpan (Dummy)'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _showDetail(BuildContext context, _PengajuanItem item) async {
    final parentContext = context;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Detail Pengajuan',
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
              const SizedBox(height: 16),
              _DetailRow(label: 'Nomor Surat', value: item.nomorSurat),
              _DetailRow(label: 'Penerima', value: item.penerima),
              _DetailRow(label: 'Tanggal', value: item.tanggal),
              _DetailRow(label: 'Keperluan', value: item.keperluan),
              _DetailRow(label: 'Deskripsi', value: item.deskripsi),
              if (item.status.isNotEmpty)
                _DetailRow(label: 'Status', value: item.status),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      width: 110,
                      child: Text(
                        'File',
                        style: TextStyle(
                          color: AppPalette.textMuted,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Expanded(child: Text(item.fileName)),
                    const SizedBox(width: 8),
                    InkWell(
                      onTap: () => _openFile(item.fileUrl, item.localPath),
                      child: const Icon(
                        Icons.visibility,
                        color: AppPalette.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              if (widget.isCabang) ...[
                if (item.status == 'PENDING')
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () async {
                            final rejected = await _showRejectReason(context);
                            if (!rejected || !context.mounted) return;
                            Navigator.of(context).pop();
                            _updateStatus(item, 'DITOLAK');
                            if (parentContext.mounted) {
                              AppNotify.info(
                                parentContext,
                                'Pengajuan ditolak',
                              );
                            }
                          },
                          child: const Text('Tolak'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            _updateStatus(item, 'DITERIMA');
                            if (parentContext.mounted) {
                              AppNotify.info(
                                parentContext,
                                'Pengajuan disetujui',
                              );
                            }
                          },
                          child: const Text('Setujui'),
                        ),
                      ),
                    ],
                  )
                else
                  Text(
                    'Status sudah final, tidak bisa diubah.',
                    style: const TextStyle(color: AppPalette.textMuted),
                  ),
              ] else if (item.status == 'PENDING')
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop();
                      if (mounted) {
                        _showEdit(parentContext, item);
                      }
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text('Edit Pengajuan'),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _openFile(String? url, String? localPath) async {
    if (localPath != null && localPath.isNotEmpty) {
      await OpenFilex.open(localPath);
      return;
    }
    if (url != null && url.isNotEmpty) {
      final ok = await launchUrlString(url);
      if (!ok && mounted) {
        AppNotify.error(context, 'Gagal membuka file');
      }
      return;
    }
    if (mounted) {
      AppNotify.info(context, 'File belum tersedia');
    }
  }

  Future<void> _showEdit(BuildContext context, _PengajuanItem item) async {
    String? penerima = item.penerima;
    DateTime? tanggal;
    String? fileName = item.fileName;
    String? nomorError, keperluanError, penerimaError, tanggalError, fileError;

    final nomorController = TextEditingController(text: item.nomorSurat);
    final keperluanController = TextEditingController(text: item.keperluan);
    final deskripsiController = TextEditingController(text: item.deskripsi);

    await showModalBottomSheet<void>(
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Edit Pengajuan PAC',
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
                  const SizedBox(height: 16),
                  const Row(
                    children: [
                      Text(
                        'Nomor Surat',
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
                    controller: nomorController,
                    onChanged: (value) {
                      if (nomorError != null && value.trim().isNotEmpty) {
                        setModalState(() => nomorError = null);
                      }
                    },
                    decoration: InputDecoration(
                      hintText: nomorError != null
                          ? 'Wajib diisi'
                          : '002/PAC/2026',
                      hintStyle: nomorError != null
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
                          color: nomorError != null
                              ? AppPalette.error
                              : AppPalette.border,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(
                          color: nomorError != null
                              ? AppPalette.error
                              : AppPalette.border,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(
                          color: nomorError != null
                              ? AppPalette.error
                              : AppPalette.border,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  LabeledActionField(
                    label: 'Penerima',
                    valueText: penerima ?? '',
                    placeholder: 'Pilih Penerima',
                    isError: penerimaError != null,
                    isRequired: true,
                    onTap: () async {
                      final val = await showSelectSheet(
                        context: context,
                        title: 'Pilih Penerima',
                        options: const ['IPNU', 'IPPNU', 'BERSAMA'],
                        initialValue: penerima,
                      );
                      if (val != null) {
                        setModalState(() {
                          penerima = val;
                          penerimaError = null;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  const SizedBox(height: 12),
                  LabeledActionField(
                    label: 'Tanggal',
                    valueText: tanggal == null
                        ? item.tanggal
                        : '${tanggal!.year}-${tanggal!.month.toString().padLeft(2, '0')}-${tanggal!.day.toString().padLeft(2, '0')}',
                    placeholder: 'Pilih Tanggal',
                    isError: tanggalError != null,
                    isRequired: true,
                    onTap: () async {
                      final val = await showDateSheet(
                        context: context,
                        title: 'Pilih Tanggal',
                        initialValue: tanggal,
                      );
                      if (val != null) {
                        setModalState(() {
                          tanggal = val;
                          tanggalError = null;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  const SizedBox(height: 12),
                  const Row(
                    children: [
                      Text(
                        'Keperluan',
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
                    controller: keperluanController,
                    onChanged: (value) {
                      if (keperluanError != null && value.trim().isNotEmpty) {
                        setModalState(() => keperluanError = null);
                      }
                    },
                    decoration: InputDecoration(
                      hintText: keperluanError != null
                          ? 'Wajib diisi'
                          : 'Kebutuhan surat',
                      hintStyle: keperluanError != null
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
                          color: keperluanError != null
                              ? AppPalette.error
                              : AppPalette.border,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(
                          color: keperluanError != null
                              ? AppPalette.error
                              : AppPalette.border,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(
                          color: keperluanError != null
                              ? AppPalette.error
                              : AppPalette.border,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Deskripsi',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: deskripsiController,
                    decoration: InputDecoration(
                      hintText: 'Rincian singkat',
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
                  const SizedBox(height: 16),
                  LabeledActionField(
                    label: 'Upload File',
                    valueText: fileName ?? '',
                    placeholder: fileError != null
                        ? 'Wajib diisi'
                        : 'Pilih File',
                    isError: fileError != null,
                    isRequired: true,
                    onTap: () async {
                      try {
                        final res = await FilePicker.platform.pickFiles(
                          allowMultiple: false,
                        );
                        if (res != null && res.files.isNotEmpty) {
                          final f = res.files.first;
                          setModalState(() {
                            fileName = f.name;
                            fileError = null;
                          });
                        }
                      } catch (_) {
                        if (context.mounted) {
                          AppNotify.error(
                            context,
                            'File picker tidak tersedia',
                          );
                        }
                      }
                    },
                  ),
                  if (fileName != null) ...[
                    const SizedBox(height: 12),
                    Row(children: [_TagChip(label: fileName!)]),
                  ],
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
                            final nomorValue = nomorController.text.trim();
                            final effNomor = nomorValue.isEmpty
                                ? item.nomorSurat
                                : nomorValue;
                            final effPenerima = (penerima ?? item.penerima)
                                .trim();
                            final effTanggal = tanggal == null
                                ? item.tanggal
                                : '${tanggal!.year}-${tanggal!.month.toString().padLeft(2, '0')}-${tanggal!.day.toString().padLeft(2, '0')}';
                            final keperluanValue = keperluanController.text
                                .trim();
                            final effKeperluan = keperluanValue.isEmpty
                                ? item.keperluan
                                : keperluanValue;
                            final deskripsiValue = deskripsiController.text
                                .trim();
                            final effDeskripsi = deskripsiValue.isEmpty
                                ? item.deskripsi
                                : deskripsiValue;
                            final effFileName = (fileName ?? item.fileName)
                                .trim();
                            final valid =
                                effNomor.isNotEmpty &&
                                effPenerima.isNotEmpty &&
                                effTanggal.isNotEmpty &&
                                effKeperluan.isNotEmpty &&
                                effFileName.isNotEmpty;
                            if (!valid) {
                              setModalState(() {
                                nomorError = effNomor.isEmpty
                                    ? 'Wajib diisi'
                                    : null;
                                keperluanError = effKeperluan.isEmpty
                                    ? 'Wajib diisi'
                                    : null;
                                fileError = effFileName.isEmpty
                                    ? 'Wajib diisi'
                                    : null;
                                penerimaError = effPenerima.isEmpty
                                    ? 'Wajib diisi'
                                    : null;
                                tanggalError = effTanggal.isEmpty
                                    ? 'Wajib diisi'
                                    : null;
                              });
                              return;
                            }
                            _updateItem(
                              item,
                              item.copyWith(
                                nomorSurat: effNomor,
                                penerima: effPenerima,
                                tanggal: effTanggal,
                                keperluan: effKeperluan,
                                deskripsi: effDeskripsi,
                                fileName: fileName ?? item.fileName,
                              ),
                            );
                            Navigator.of(context).pop();
                          },
                          child: const Text('Simpan (Dummy)'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<bool> _showRejectReason(BuildContext context) async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Alasan Penolakan',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              const _FormField(label: 'Alasan', hint: 'Wajib diisi'),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Kirim Penolakan (Dummy)'),
                ),
              ),
            ],
          ),
        );
      },
    );
    return result ?? false;
  }

  void _updateStatus(_PengajuanItem item, String status) {
    final index = _items.indexOf(item);
    if (index == -1) return;
    setState(() {
      _items[index] = item.copyWith(status: status);
    });
  }

  void _updateItem(_PengajuanItem original, _PengajuanItem updated) {
    final index = _items.indexOf(original);
    if (index == -1) {
      final currentIndex = _items.indexWhere(
        (element) => element.nomorSurat == original.nomorSurat,
      );
      if (currentIndex == -1) return;
      setState(() {
        _items[currentIndex] = updated;
      });
      return;
    }
    setState(() {
      _items[index] = updated;
    });
  }
}
