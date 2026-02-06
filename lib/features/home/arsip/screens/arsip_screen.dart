import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:open_filex/open_filex.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../shared/widgets/pickers.dart';

part '../models/arsip_models.dart';
part '../widgets/arsip_widgets.dart';

class ArsipScreen extends StatefulWidget {
  const ArsipScreen({super.key, required this.isCabang});

  final bool isCabang;

  @override
  State<ArsipScreen> createState() => _ArsipScreenState();
}

class _ArsipScreenState extends State<ArsipScreen> {
  int _categoryIndex = 0;

  List<_ArsipCategory> get _categories {
    final base = [
      const _ArsipCategory(
        type: _ArsipType.surat,
        label: 'Arsip Surat',
        subtitle: 'Surat masuk dan keluar',
      ),
      const _ArsipCategory(
        type: _ArsipType.pimpinan,
        label: 'Berkas Pimpinan',
        subtitle: 'SK & dokumen pimpinan',
      ),
    ];
    if (widget.isCabang) {
      base.add(
        const _ArsipCategory(
          type: _ArsipType.sp,
          label: 'Berkas SP',
          subtitle: 'Surat keputusan pimpinan',
        ),
      );
    }
    return base;
  }

  List<_ArsipItem> _itemsFor(_ArsipType type) {
    switch (type) {
      case _ArsipType.surat:
        return [
          const _ArsipItem.surat(
            nomorSurat: '001/PC/2026',
            jenisSurat: 'MASUK',
            organisasi: 'IPNU',
            tanggalSurat: '01 Feb 2026',
            penerimaPengirim: 'Pengurus PC',
            perihal: 'Undangan Rapat Koordinasi',
            deskripsi: 'Rapat koordinasi bulanan',
            fileUrl: 'arsip/undangan-rapat.pdf',
            fileName: 'undangan-rapat.pdf',
            fileMime: 'application/pdf',
            fileSize: 120000,
            periodeId: 'periode-2026',
          ),
          const _ArsipItem.surat(
            nomorSurat: '002/PC/2026',
            jenisSurat: 'KELUAR',
            organisasi: 'IPPNU',
            tanggalSurat: '02 Feb 2026',
            penerimaPengirim: 'Pengurus IPPNU',
            perihal: 'Permohonan Dukungan',
            deskripsi: 'Permohonan dukungan kegiatan',
            fileUrl: 'arsip/permohonan-dukungan.pdf',
            fileName: 'permohonan-dukungan.pdf',
            fileMime: 'application/pdf',
            fileSize: 98000,
            periodeId: 'periode-2026',
          ),
          const _ArsipItem.surat(
            nomorSurat: '003/PC/2026',
            jenisSurat: 'MASUK',
            organisasi: 'BERSAMA',
            tanggalSurat: '03 Feb 2026',
            penerimaPengirim: 'Sekretariat',
            perihal: 'Notulensi Rapat',
            deskripsi: 'Ringkasan rapat koordinasi',
            fileUrl: 'arsip/notulensi-rapat.pdf',
            fileName: 'notulensi-rapat.pdf',
            fileMime: 'application/pdf',
            fileSize: 87000,
            periodeId: 'periode-2026',
          ),
        ];
      case _ArsipType.pimpinan:
        return [
          const _ArsipItem.pimpinan(
            nama: 'SK Pengurus Harian',
            tanggal: '12 Jan 2026',
            catatan: 'Berkas pimpinan periode 2025-2026',
            fileUrl: 'pimpinan/sk-pengurus.pdf',
            fileName: 'sk-pengurus.pdf',
            fileMime: 'application/pdf',
            fileSize: 210000,
            periodeId: 'periode-2026',
          ),
          const _ArsipItem.pimpinan(
            nama: 'Surat Tugas',
            tanggal: '18 Jan 2026',
            catatan: 'Delegasi kegiatan regional',
            fileUrl: 'pimpinan/surat-tugas.docx',
            fileName: 'surat-tugas.docx',
            fileMime:
                'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
            fileSize: 156000,
            periodeId: 'periode-2026',
          ),
        ];
      case _ArsipType.sp:
        return [
          const _ArsipItem.sp(
            namaPimpinan: 'Ketua PC',
            organisasi: 'IPNU',
            tanggalMulai: '01 Jan 2026',
            tanggalBerakhir: '01 Jan 2027',
            catatan: 'Masa bakti 2026-2027',
            fileUrl: 'sp/sp-ketua-pc.pdf',
            fileName: 'sp-ketua-pc.pdf',
            fileMime: 'application/pdf',
            fileSize: 140000,
            periodeId: 'periode-2026',
          ),
          const _ArsipItem.sp(
            namaPimpinan: 'Sekretaris',
            organisasi: 'BERSAMA',
            tanggalMulai: '15 Jan 2026',
            tanggalBerakhir: '15 Jan 2027',
            catatan: 'Periode 2025-2026',
            fileUrl: 'sp/sp-sekretaris.pdf',
            fileName: 'sp-sekretaris.pdf',
            fileMime: 'application/pdf',
            fileSize: 132000,
            periodeId: 'periode-2026',
          ),
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final categories = _categories;
    final selectedCategory = categories[_categoryIndex];
    final items = _itemsFor(selectedCategory.type);

    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Arsip',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                ),
                FilledButton.icon(
                  onPressed: () => _showForm(context, selectedCategory.type),
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
                    decoration: InputDecoration(
                      hintText: 'Cari arsip atau berkas',
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
              itemBuilder: (context, index) {
                final category = categories[index];
                return ChoiceChip(
                  label: Text(category.label),
                  selected: _categoryIndex == index,
                  onSelected: (value) {
                    if (value) {
                      setState(() => _categoryIndex = index);
                    }
                  },
                );
              },
              separatorBuilder: (context, index) => const SizedBox(width: 10),
              itemCount: categories.length,
            ),
          ),
          const SizedBox(height: 6),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return _ArsipCard(
                  item: item,
                  onTap: () => _showDetail(context, item),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showForm(BuildContext context, _ArsipType type) async {
    final title = switch (type) {
      _ArsipType.surat => 'Form Arsip Surat',
      _ArsipType.pimpinan => 'Form Berkas Pimpinan',
      _ArsipType.sp => 'Form Berkas SP',
    };
    String? organisasi;
    String? jenisSurat;
    DateTime? tanggal;
    DateTime? tanggalMulai;
    DateTime? tanggalBerakhir;
    String? fileName;

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
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: const TextStyle(
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
                    if (type == _ArsipType.surat)
                      const _FormField(
                        label: 'Nomor Surat',
                        hint: 'Contoh: 001/PC/2026',
                      )
                    else if (type == _ArsipType.pimpinan)
                      const _FormField(
                        label: 'Nama',
                        hint: 'Nama berkas pimpinan',
                      )
                    else
                      const _FormField(
                        label: 'Nama Pimpinan',
                        hint: 'Nama pimpinan',
                      ),
                    const SizedBox(height: 12),
                    if (type != _ArsipType.pimpinan) ...[
                      LabeledActionField(
                        label: 'Organisasi',
                        valueText: organisasi ?? '',
                        onTap: () async {
                          final val = await showSelectSheet(
                            context: context,
                            title: 'Pilih Organisasi',
                            options: const ['IPNU', 'IPPNU', 'BERSAMA'],
                            initialValue: organisasi,
                          );
                          if (val != null) {
                            setModalState(() => organisasi = val);
                          }
                        },
                      ),
                      const SizedBox(height: 12),
                    ],
                    if (type == _ArsipType.surat)
                      LabeledActionField(
                        label: 'Jenis Surat',
                        valueText: jenisSurat ?? '',
                        onTap: () async {
                          final val = await showSelectSheet(
                            context: context,
                            title: 'Pilih Jenis Surat',
                            options: const ['MASUK', 'KELUAR'],
                            initialValue: jenisSurat,
                          );
                          if (val != null) {
                            setModalState(() => jenisSurat = val);
                          }
                        },
                      ),
                    if (type == _ArsipType.sp) ...[
                      const SizedBox(height: 12),
                      LabeledActionField(
                        label: 'Tanggal Mulai',
                        valueText: tanggalMulai == null
                            ? ''
                            : '${tanggalMulai!.year}-${tanggalMulai!.month.toString().padLeft(2, '0')}-${tanggalMulai!.day.toString().padLeft(2, '0')}',
                        onTap: () async {
                          final val = await showDateSheet(
                            context: context,
                            title: 'Pilih Tanggal Mulai',
                            initialValue: tanggalMulai,
                          );
                          if (val != null) {
                            setModalState(() => tanggalMulai = val);
                          }
                        },
                      ),
                      const SizedBox(height: 12),
                      LabeledActionField(
                        label: 'Tanggal Berakhir',
                        valueText: tanggalBerakhir == null
                            ? ''
                            : '${tanggalBerakhir!.year}-${tanggalBerakhir!.month.toString().padLeft(2, '0')}-${tanggalBerakhir!.day.toString().padLeft(2, '0')}',
                        onTap: () async {
                          final val = await showDateSheet(
                            context: context,
                            title: 'Pilih Tanggal Berakhir',
                            initialValue: tanggalBerakhir,
                          );
                          if (val != null) {
                            setModalState(() => tanggalBerakhir = val);
                          }
                        },
                      ),
                    ] else ...[
                      const SizedBox(height: 12),
                      LabeledActionField(
                        label: type == _ArsipType.surat
                            ? 'Tanggal Surat'
                            : 'Tanggal',
                        valueText: tanggal == null
                            ? ''
                            : '${tanggal!.year}-${tanggal!.month.toString().padLeft(2, '0')}-${tanggal!.day.toString().padLeft(2, '0')}',
                        onTap: () async {
                          final val = await showDateSheet(
                            context: context,
                            title: type == _ArsipType.surat
                                ? 'Pilih Tanggal Surat'
                                : 'Pilih Tanggal',
                            initialValue: tanggal,
                          );
                          if (val != null) {
                            setModalState(() => tanggal = val);
                          }
                        },
                      ),
                    ],
                    const SizedBox(height: 12),
                    if (type == _ArsipType.surat) ...[
                      const _FormField(
                        label: 'Penerima/Pengirim',
                        hint: 'Nama penerima atau pengirim',
                      ),
                      const SizedBox(height: 12),
                      const _FormField(
                        label: 'Perihal',
                        hint: 'Isi perihal surat',
                      ),
                      const SizedBox(height: 12),
                      const _FormField(
                        label: 'Deskripsi',
                        hint: 'Deskripsi singkat',
                      ),
                    ] else
                      const _FormField(
                        label: 'Catatan',
                        hint: 'Tambahkan catatan',
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
                            setModalState(() {
                              fileName = f.name;
                            });
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
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _showDetail(BuildContext context, _ArsipItem item) async {
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
                      'Detail',
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
              if (item.type == _ArsipType.surat) ...[
                _DetailRow(
                  label: 'Nomor Surat',
                  value: item.nomorSurat ?? item.title,
                ),
                _DetailRow(label: 'Jenis Surat', value: item.jenisSurat ?? ''),
                _DetailRow(label: 'Organisasi', value: item.organisasi ?? ''),
                _DetailRow(
                  label: 'Tanggal Surat',
                  value: item.tanggalSurat ?? item.dateLabel,
                ),
                _DetailRow(
                  label: 'Penerima/Pengirim',
                  value: item.penerimaPengirim ?? '',
                ),
                _DetailRow(label: 'Perihal', value: item.perihal ?? ''),
                _DetailRow(label: 'Deskripsi', value: item.deskripsi ?? ''),
              ] else if (item.type == _ArsipType.pimpinan) ...[
                _DetailRow(label: 'Nama', value: item.nama ?? item.title),
                _DetailRow(
                  label: 'Tanggal',
                  value: item.tanggal ?? item.dateLabel,
                ),
                _DetailRow(label: 'Catatan', value: item.catatan ?? ''),
              ] else ...[
                _DetailRow(
                  label: 'Nama Pimpinan',
                  value: item.namaPimpinan ?? item.title,
                ),
                _DetailRow(label: 'Organisasi', value: item.organisasi ?? ''),
                _DetailRow(
                  label: 'Tanggal Mulai',
                  value: item.tanggalMulai ?? '',
                ),
                _DetailRow(
                  label: 'Tanggal Berakhir',
                  value: item.tanggalBerakhir ?? '',
                ),
                _DetailRow(label: 'Catatan', value: item.catatan ?? ''),
              ],
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
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _confirmDelete(context),
                      child: const Text('Hapus'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        if (mounted) {
                          _showEdit(parentContext, item);
                        }
                      },
                      child: const Text('Edit'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Hapus arsip?'),
          content: const Text('Data arsip akan dihapus.'),
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
      if (!context.mounted) return;
      Navigator.of(context).pop();
    }
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

  Future<void> _showEdit(BuildContext context, _ArsipItem item) async {
    String? organisasi = item.organisasi;
    String? jenisSurat = item.jenisSurat;
    DateTime? tanggal;
    DateTime? tanggalMulai;
    DateTime? tanggalBerakhir;
    String? fileName = item.fileName;

    final nomorController = TextEditingController(text: item.nomorSurat ?? '');
    final penerimaController = TextEditingController(
      text: item.penerimaPengirim ?? '',
    );
    final perihalController = TextEditingController(text: item.perihal ?? '');
    final deskripsiController = TextEditingController(
      text: item.deskripsi ?? '',
    );
    final namaController = TextEditingController(text: item.nama ?? '');
    final catatanController = TextEditingController(text: item.catatan ?? '');
    final namaPimpinanController = TextEditingController(
      text: item.namaPimpinan ?? '',
    );

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
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Edit Arsip',
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
                    if (item.type == _ArsipType.surat) ...[
                      Text(
                        'Nomor Surat',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: nomorController,
                        decoration: InputDecoration(
                          hintText: 'Contoh: 001/PC/2026',
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
                    ] else if (item.type == _ArsipType.pimpinan) ...[
                      Text(
                        'Nama',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: namaController,
                        decoration: InputDecoration(
                          hintText: 'Nama berkas pimpinan',
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
                    ] else ...[
                      Text(
                        'Nama Pimpinan',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: namaPimpinanController,
                        decoration: InputDecoration(
                          hintText: 'Nama pimpinan',
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
                    const SizedBox(height: 12),
                    if (item.type != _ArsipType.pimpinan) ...[
                      LabeledActionField(
                        label: 'Organisasi',
                        valueText: organisasi ?? '',
                        onTap: () async {
                          final val = await showSelectSheet(
                            context: context,
                            title: 'Pilih Organisasi',
                            options: const ['IPNU', 'IPPNU', 'BERSAMA'],
                            initialValue: organisasi,
                          );
                          if (val != null) {
                            setModalState(() => organisasi = val);
                          }
                        },
                      ),
                      const SizedBox(height: 12),
                    ],
                    if (item.type == _ArsipType.surat)
                      LabeledActionField(
                        label: 'Jenis Surat',
                        valueText: jenisSurat ?? '',
                        onTap: () async {
                          final val = await showSelectSheet(
                            context: context,
                            title: 'Pilih Jenis Surat',
                            options: const ['MASUK', 'KELUAR'],
                            initialValue: jenisSurat,
                          );
                          if (val != null) {
                            setModalState(() => jenisSurat = val);
                          }
                        },
                      ),
                    if (item.type == _ArsipType.sp) ...[
                      const SizedBox(height: 12),
                      LabeledActionField(
                        label: 'Tanggal Mulai',
                        valueText: item.tanggalMulai ?? '',
                        onTap: () async {
                          final val = await showDateSheet(
                            context: context,
                            title: 'Pilih Tanggal Mulai',
                            initialValue: tanggalMulai,
                          );
                          if (val != null) {
                            setModalState(() => tanggalMulai = val);
                          }
                        },
                      ),
                      const SizedBox(height: 12),
                      LabeledActionField(
                        label: 'Tanggal Berakhir',
                        valueText: item.tanggalBerakhir ?? '',
                        onTap: () async {
                          final val = await showDateSheet(
                            context: context,
                            title: 'Pilih Tanggal Berakhir',
                            initialValue: tanggalBerakhir,
                          );
                          if (val != null) {
                            setModalState(() => tanggalBerakhir = val);
                          }
                        },
                      ),
                    ] else ...[
                      const SizedBox(height: 12),
                      LabeledActionField(
                        label: item.type == _ArsipType.surat
                            ? 'Tanggal Surat'
                            : 'Tanggal',
                        valueText: item.type == _ArsipType.surat
                            ? (item.tanggalSurat ?? '')
                            : (item.tanggal ?? ''),
                        onTap: () async {
                          final val = await showDateSheet(
                            context: context,
                            title: 'Pilih Tanggal',
                            initialValue: tanggal,
                          );
                          if (val != null) {
                            setModalState(() => tanggal = val);
                          }
                        },
                      ),
                    ],
                    const SizedBox(height: 12),
                    if (item.type == _ArsipType.surat) ...[
                      Text(
                        'Penerima/Pengirim',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: penerimaController,
                        decoration: InputDecoration(
                          hintText: 'Nama penerima atau pengirim',
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
                        'Perihal',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: perihalController,
                        decoration: InputDecoration(
                          hintText: 'Isi perihal surat',
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
                          hintText: 'Deskripsi singkat',
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
                    ] else ...[
                      Text(
                        'Catatan',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: catatanController,
                        decoration: InputDecoration(
                          hintText: 'Tambahkan catatan',
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
                            setModalState(() {
                              fileName = f.name;
                            });
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
              ),
            );
          },
        );
      },
    );
  }
}
