import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:open_filex/open_filex.dart';
import '../../../core/theme/app_palette.dart';
import '../../../shared/widgets/pickers.dart';

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
                  const _FormField(label: 'Nomor Surat', hint: '002/PAC/2026'),
                  const SizedBox(height: 12),
                  LabeledActionField(
                    label: 'Penerima',
                    valueText: penerima ?? '',
                    onTap: () async {
                      final val = await showSelectSheet(
                        context: context,
                        title: 'Pilih Penerima',
                        options: const ['IPNU', 'IPPNU', 'BERSAMA'],
                        initialValue: penerima,
                      );
                      if (val != null) setModalState(() => penerima = val);
                    },
                  ),
                  const SizedBox(height: 12),
                  LabeledActionField(
                    label: 'Tanggal',
                    valueText: tanggal == null
                        ? ''
                        : '${tanggal!.year}-${tanggal!.month.toString().padLeft(2, '0')}-${tanggal!.day.toString().padLeft(2, '0')}',
                    onTap: () async {
                      final val = await showDateSheet(
                        context: context,
                        title: 'Pilih Tanggal',
                        initialValue: tanggal,
                      );
                      if (val != null) setModalState(() => tanggal = val);
                    },
                  ),
                  const SizedBox(height: 12),
                  const _FormField(label: 'Keperluan', hint: 'Kebutuhan surat'),
                  const SizedBox(height: 12),
                  const _FormField(label: 'Deskripsi', hint: 'Rincian singkat'),
                  const SizedBox(height: 16),
                  LabeledActionField(
                    label: 'Upload File',
                    valueText: fileName ?? '',
                    onTap: () async {
                      try {
                        final res = await FilePicker.platform.pickFiles(
                          allowMultiple: false,
                        );
                        if (res != null && res.files.isNotEmpty) {
                          final f = res.files.first;
                          setModalState(() => fileName = f.name);
                        } else {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Pemilihan file dibatalkan'),
                              ),
                            );
                          }
                        }
                      } catch (_) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('File picker tidak tersedia'),
                            ),
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
                          onPressed: () => Navigator.of(context).pop(),
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
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Gagal membuka file')));
      }
      return;
    }
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('File belum tersedia')));
    }
  }

  Future<void> _showEdit(BuildContext context, _PengajuanItem item) async {
    String? penerima = item.penerima;
    DateTime? tanggal;
    String? fileName = item.fileName;

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
                  Text(
                    'Nomor Surat',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: nomorController,
                    decoration: InputDecoration(
                      hintText: '002/PAC/2026',
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
                  const SizedBox(height: 12),
                  LabeledActionField(
                    label: 'Penerima',
                    valueText: penerima ?? '',
                    onTap: () async {
                      final val = await showSelectSheet(
                        context: context,
                        title: 'Pilih Penerima',
                        options: const ['IPNU', 'IPPNU', 'BERSAMA'],
                        initialValue: penerima,
                      );
                      if (val != null) setModalState(() => penerima = val);
                    },
                  ),
                  const SizedBox(height: 12),
                  LabeledActionField(
                    label: 'Tanggal',
                    valueText: tanggal == null
                        ? item.tanggal
                        : '${tanggal!.year}-${tanggal!.month.toString().padLeft(2, '0')}-${tanggal!.day.toString().padLeft(2, '0')}',
                    onTap: () async {
                      final val = await showDateSheet(
                        context: context,
                        title: 'Pilih Tanggal',
                        initialValue: tanggal,
                      );
                      if (val != null) setModalState(() => tanggal = val);
                    },
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Keperluan',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: keperluanController,
                    decoration: InputDecoration(
                      hintText: 'Kebutuhan surat',
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
                    onTap: () async {
                      try {
                        final res = await FilePicker.platform.pickFiles(
                          allowMultiple: false,
                        );
                        if (res != null && res.files.isNotEmpty) {
                          final f = res.files.first;
                          setModalState(() => fileName = f.name);
                        } else {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Pemilihan file dibatalkan'),
                              ),
                            );
                          }
                        }
                      } catch (_) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('File picker tidak tersedia'),
                            ),
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
                            final tanggalValue = tanggal == null
                                ? item.tanggal
                                : '${tanggal!.year}-${tanggal!.month.toString().padLeft(2, '0')}-${tanggal!.day.toString().padLeft(2, '0')}';
                            final nomorValue = nomorController.text.trim();
                            final keperluanValue = keperluanController.text
                                .trim();
                            final deskripsiValue = deskripsiController.text
                                .trim();
                            _updateItem(
                              item,
                              item.copyWith(
                                nomorSurat: nomorValue.isEmpty
                                    ? item.nomorSurat
                                    : nomorValue,
                                penerima: penerima ?? item.penerima,
                                tanggal: tanggalValue,
                                keperluan: keperluanValue.isEmpty
                                    ? item.keperluan
                                    : keperluanValue,
                                deskripsi: deskripsiValue.isEmpty
                                    ? item.deskripsi
                                    : deskripsiValue,
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

class _PengajuanItem {
  const _PengajuanItem({
    required this.nomorSurat,
    required this.penerima,
    required this.tanggal,
    required this.keperluan,
    required this.deskripsi,
    required this.status,
    required this.fileUrl,
    required this.fileName,
    required this.fileMime,
    required this.fileSize,
    this.localPath,
  });

  final String nomorSurat;
  final String penerima;
  final String tanggal;
  final String keperluan;
  final String deskripsi;
  final String status;
  final String fileUrl;
  final String fileName;
  final String fileMime;
  final int fileSize;
  final String? localPath;

  _PengajuanItem copyWith({
    String? nomorSurat,
    String? penerima,
    String? tanggal,
    String? keperluan,
    String? deskripsi,
    String? status,
    String? fileUrl,
    String? fileName,
    String? fileMime,
    int? fileSize,
    String? localPath,
  }) {
    return _PengajuanItem(
      nomorSurat: nomorSurat ?? this.nomorSurat,
      penerima: penerima ?? this.penerima,
      tanggal: tanggal ?? this.tanggal,
      keperluan: keperluan ?? this.keperluan,
      deskripsi: deskripsi ?? this.deskripsi,
      status: status ?? this.status,
      fileUrl: fileUrl ?? this.fileUrl,
      fileName: fileName ?? this.fileName,
      fileMime: fileMime ?? this.fileMime,
      fileSize: fileSize ?? this.fileSize,
      localPath: localPath ?? this.localPath,
    );
  }
}

class _PengajuanCard extends StatelessWidget {
  const _PengajuanCard({required this.item, required this.onDetail});

  final _PengajuanItem item;
  final VoidCallback onDetail;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onDetail,
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
              child: const Icon(Icons.send, color: AppPalette.primary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.nomorSurat,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.keperluan,
                    style: const TextStyle(color: AppPalette.textMuted),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _TagChip(label: item.status),
                      const SizedBox(width: 8),
                      _TagChip(label: item.penerima),
                      const SizedBox(width: 8),
                      Text(
                        item.tanggal,
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

class _FormField extends StatelessWidget {
  const _FormField({required this.label, required this.hint});

  final String label;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        TextField(
          decoration: InputDecoration(
            hintText: hint,
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
