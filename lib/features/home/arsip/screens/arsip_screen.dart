import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:open_filex/open_filex.dart';
import '../../../../app/app.dart';
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
  late List<_ArsipItem> _itemsSurat;
  late List<_ArsipItem> _itemsPimpinan;
  late List<_ArsipItem> _itemsSp;

  @override
  void initState() {
    super.initState();
    _itemsSurat = [
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
    _itemsPimpinan = [
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
    _itemsSp = [
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
        return _itemsSurat;
      case _ArsipType.pimpinan:
        return _itemsPimpinan;
      case _ArsipType.sp:
        return _itemsSp;
    }
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];
    final m = months[date.month - 1];
    final d = date.day.toString().padLeft(2, '0');
    return '$d $m ${date.year}';
  }

  void _addItem(_ArsipItem item) {
    setState(() {
      if (item.type == _ArsipType.surat) {
        _itemsSurat = [item, ..._itemsSurat];
      } else if (item.type == _ArsipType.pimpinan) {
        _itemsPimpinan = [item, ..._itemsPimpinan];
      } else {
        _itemsSp = [item, ..._itemsSp];
      }
    });
  }

  void _updateItem(_ArsipItem original, _ArsipItem updated) {
    setState(() {
      List<_ArsipItem> list;
      if (original.type == _ArsipType.surat) {
        list = _itemsSurat;
        final idx = list.indexOf(original);
        final index = idx != -1
            ? idx
            : list.indexWhere((e) => e.nomorSurat == original.nomorSurat);
        if (index != -1) {
          list[index] = updated;
          _itemsSurat = List<_ArsipItem>.from(list);
        }
      } else if (original.type == _ArsipType.pimpinan) {
        list = _itemsPimpinan;
        final idx = list.indexOf(original);
        final index = idx != -1
            ? idx
            : list.indexWhere((e) => e.nama == original.nama);
        if (index != -1) {
          list[index] = updated;
          _itemsPimpinan = List<_ArsipItem>.from(list);
        }
      } else {
        list = _itemsSp;
        final idx = list.indexOf(original);
        final index = idx != -1
            ? idx
            : list.indexWhere((e) => e.namaPimpinan == original.namaPimpinan);
        if (index != -1) {
          list[index] = updated;
          _itemsSp = List<_ArsipItem>.from(list);
        }
      }
    });
  }

  void _deleteItem(_ArsipItem item) {
    setState(() {
      if (item.type == _ArsipType.surat) {
        _itemsSurat = _itemsSurat.where((e) => e != item).toList();
      } else if (item.type == _ArsipType.pimpinan) {
        _itemsPimpinan = _itemsPimpinan.where((e) => e != item).toList();
      } else {
        _itemsSp = _itemsSp.where((e) => e != item).toList();
      }
    });
  }

  Future<bool> _confirmDeleteItem(BuildContext context, _ArsipItem item) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Hapus data?'),
          content: Text('"${item.title}" akan dihapus.'),
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
    return result == true;
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
    final parentContext = context;
    final title = switch (type) {
      _ArsipType.surat => 'Form Arsip Surat',
      _ArsipType.pimpinan => 'Form Berkas Pimpinan',
      _ArsipType.sp => 'Form Berkas SP',
    };
    final successLabel = switch (type) {
      _ArsipType.surat => 'Arsip surat',
      _ArsipType.pimpinan => 'Berkas pimpinan',
      _ArsipType.sp => 'Berkas SP',
    };
    String? organisasi;
    String? jenisSurat;
    DateTime? tanggal;
    DateTime? tanggalMulai;
    DateTime? tanggalBerakhir;
    String? fileName;
    final nomorController = TextEditingController();
    final namaController = TextEditingController();
    final namaPimpinanController = TextEditingController();
    final penerimaController = TextEditingController();
    final perihalController = TextEditingController();
    final deskripsiController = TextEditingController();
    final catatanController = TextEditingController();
    String? nomorError,
        namaError,
        namaPimpinanError,
        penerimaError,
        perihalError,
        fileError,
        organisasiError,
        jenisSuratError,
        tanggalError,
        tanggalMulaiError,
        tanggalBerakhirError;

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
                    if (type == _ArsipType.surat) ...[
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
                              : 'Contoh: 001/PC/2026',
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
                    ] else if (type == _ArsipType.pimpinan) ...[
                      const Row(
                        children: [
                          Text(
                            'Nama',
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
                        controller: namaController,
                        onChanged: (value) {
                          if (namaError != null && value.trim().isNotEmpty) {
                            setModalState(() => namaError = null);
                          }
                        },
                        decoration: InputDecoration(
                          hintText: namaError != null
                              ? 'Wajib diisi'
                              : 'Nama berkas pimpinan',
                          hintStyle: namaError != null
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
                              color: namaError != null
                                  ? AppPalette.error
                                  : AppPalette.border,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(
                              color: namaError != null
                                  ? AppPalette.error
                                  : AppPalette.border,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(
                              color: namaError != null
                                  ? AppPalette.error
                                  : AppPalette.border,
                            ),
                          ),
                        ),
                      ),
                    ] else ...[
                      const Row(
                        children: [
                          Text(
                            'Nama Pimpinan',
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
                        controller: namaPimpinanController,
                        onChanged: (value) {
                          if (namaPimpinanError != null &&
                              value.trim().isNotEmpty) {
                            setModalState(() => namaPimpinanError = null);
                          }
                        },
                        decoration: InputDecoration(
                          hintText: namaPimpinanError != null
                              ? 'Wajib diisi'
                              : 'Nama pimpinan',
                          hintStyle: namaPimpinanError != null
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
                              color: namaPimpinanError != null
                                  ? AppPalette.error
                                  : AppPalette.border,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(
                              color: namaPimpinanError != null
                                  ? AppPalette.error
                                  : AppPalette.border,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(
                              color: namaPimpinanError != null
                                  ? AppPalette.error
                                  : AppPalette.border,
                            ),
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 12),
                    if (type != _ArsipType.pimpinan) ...[
                      LabeledActionField(
                        label: 'Organisasi',
                        valueText: organisasi ?? '',
                        placeholder: 'Pilih Organisasi',
                        isError: organisasiError != null,
                        isRequired: true,
                        onTap: () async {
                          final val = await showSelectSheet(
                            context: context,
                            title: 'Pilih Organisasi',
                            options: const ['IPNU', 'IPPNU', 'BERSAMA'],
                            initialValue: organisasi,
                          );
                          if (val != null) {
                            setModalState(() {
                              organisasi = val;
                              organisasiError = null;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 12),
                    ],
                    if (type == _ArsipType.surat)
                      LabeledActionField(
                        label: 'Jenis Surat',
                        valueText: jenisSurat ?? '',
                        placeholder: 'Pilih Jenis Surat',
                        isError: jenisSuratError != null,
                        isRequired: true,
                        onTap: () async {
                          final val = await showSelectSheet(
                            context: context,
                            title: 'Pilih Jenis Surat',
                            options: const ['MASUK', 'KELUAR'],
                            initialValue: jenisSurat,
                          );
                          if (val != null) {
                            setModalState(() {
                              jenisSurat = val;
                              jenisSuratError = null;
                            });
                          }
                        },
                      ),
                    const SizedBox(height: 12),
                    if (type == _ArsipType.sp) ...[
                      const SizedBox(height: 12),
                      LabeledActionField(
                        label: 'Tanggal Mulai',
                        valueText: tanggalMulai == null
                            ? ''
                            : '${tanggalMulai!.year}-${tanggalMulai!.month.toString().padLeft(2, '0')}-${tanggalMulai!.day.toString().padLeft(2, '0')}',
                        placeholder: 'Pilih Tanggal Mulai',
                        isError: tanggalMulaiError != null,
                        isRequired: true,
                        onTap: () async {
                          final val = await showDateSheet(
                            context: context,
                            title: 'Pilih Tanggal Mulai',
                            initialValue: tanggalMulai,
                          );
                          if (val != null) {
                            setModalState(() {
                              tanggalMulai = val;
                              tanggalMulaiError = null;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 12),
                      const SizedBox(height: 12),
                      LabeledActionField(
                        label: 'Tanggal Berakhir',
                        valueText: tanggalBerakhir == null
                            ? ''
                            : '${tanggalBerakhir!.year}-${tanggalBerakhir!.month.toString().padLeft(2, '0')}-${tanggalBerakhir!.day.toString().padLeft(2, '0')}',
                        placeholder: 'Pilih Tanggal Berakhir',
                        isError: tanggalBerakhirError != null,
                        isRequired: true,
                        onTap: () async {
                          final val = await showDateSheet(
                            context: context,
                            title: 'Pilih Tanggal Berakhir',
                            initialValue: tanggalBerakhir,
                          );
                          if (val != null) {
                            setModalState(() {
                              tanggalBerakhir = val;
                              tanggalBerakhirError = null;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 12),
                    ] else ...[
                      const SizedBox(height: 12),
                      LabeledActionField(
                        label: type == _ArsipType.surat
                            ? 'Tanggal Surat'
                            : 'Tanggal',
                        valueText: tanggal == null
                            ? ''
                            : '${tanggal!.year}-${tanggal!.month.toString().padLeft(2, '0')}-${tanggal!.day.toString().padLeft(2, '0')}',
                        placeholder: type == _ArsipType.surat
                            ? 'Pilih Tanggal Surat'
                            : 'Pilih Tanggal',
                        isError: tanggalError != null,
                        isRequired: true,
                        onTap: () async {
                          final val = await showDateSheet(
                            context: context,
                            title: type == _ArsipType.surat
                                ? 'Pilih Tanggal Surat'
                                : 'Pilih Tanggal',
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
                    ],
                    const SizedBox(height: 12),
                    if (type == _ArsipType.surat) ...[
                      const Row(
                        children: [
                          Text(
                            'Penerima/Pengirim',
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
                        controller: penerimaController,
                        onChanged: (value) {
                          if (penerimaError != null &&
                              value.trim().isNotEmpty) {
                            setModalState(() => penerimaError = null);
                          }
                        },
                        decoration: InputDecoration(
                          hintText: penerimaError != null
                              ? 'Wajib diisi'
                              : 'Nama penerima atau pengirim',
                          hintStyle: penerimaError != null
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
                              color: penerimaError != null
                                  ? AppPalette.error
                                  : AppPalette.border,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(
                              color: penerimaError != null
                                  ? AppPalette.error
                                  : AppPalette.border,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(
                              color: penerimaError != null
                                  ? AppPalette.error
                                  : AppPalette.border,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Row(
                        children: [
                          Text(
                            'Perihal',
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
                        controller: perihalController,
                        onChanged: (value) {
                          if (perihalError != null && value.trim().isNotEmpty) {
                            setModalState(() => perihalError = null);
                          }
                        },
                        decoration: InputDecoration(
                          hintText: perihalError != null
                              ? 'Wajib diisi'
                              : 'Isi perihal surat',
                          hintStyle: perihalError != null
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
                              color: perihalError != null
                                  ? AppPalette.error
                                  : AppPalette.border,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(
                              color: perihalError != null
                                  ? AppPalette.error
                                  : AppPalette.border,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(
                              color: perihalError != null
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
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(color: AppPalette.border),
                          ),
                        ),
                      ),
                    ] else ...[
                      const Text(
                        'Catatan',
                        style: TextStyle(fontWeight: FontWeight.w600),
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
                      placeholder: fileError != null
                          ? 'Wajib diisi'
                          : 'Pilih File',
                      isError: fileError != null,
                      isRequired: type == _ArsipType.pimpinan,
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
                              if (type == _ArsipType.surat) {
                                final nomor = nomorController.text.trim();
                                final penerima = penerimaController.text.trim();
                                final perihal = perihalController.text.trim();
                                final valid =
                                    nomor.isNotEmpty &&
                                    (organisasi != null &&
                                        organisasi!.isNotEmpty) &&
                                    (jenisSurat != null &&
                                        jenisSurat!.isNotEmpty) &&
                                    tanggal != null &&
                                    penerima.isNotEmpty &&
                                    perihal.isNotEmpty;
                                if (!valid) {
                                  setModalState(() {
                                    nomorError = nomor.isEmpty
                                        ? 'Wajib diisi'
                                        : null;
                                    organisasiError =
                                        (organisasi == null ||
                                            organisasi!.isEmpty)
                                        ? 'Harap pilih'
                                        : null;
                                    jenisSuratError =
                                        (jenisSurat == null ||
                                            jenisSurat!.isEmpty)
                                        ? 'Harap pilih'
                                        : null;
                                    tanggalError = tanggal == null
                                        ? 'Harap pilih'
                                        : null;
                                    penerimaError = penerima.isEmpty
                                        ? 'Wajib diisi'
                                        : null;
                                    perihalError = perihal.isEmpty
                                        ? 'Wajib diisi'
                                        : null;
                                  });
                                  return;
                                }
                                final tanggalStr = _formatDate(tanggal!);
                                final newItem = _ArsipItem.surat(
                                  nomorSurat: nomor,
                                  jenisSurat: jenisSurat!,
                                  organisasi: organisasi!,
                                  tanggalSurat: tanggalStr,
                                  penerimaPengirim: penerima,
                                  perihal: perihal,
                                  deskripsi: deskripsiController.text.trim(),
                                  fileUrl: fileName ?? '',
                                  fileName: fileName ?? '',
                                  fileMime: 'application/octet-stream',
                                  fileSize: 0,
                                  periodeId: 'periode-2026',
                                );
                                _addItem(newItem);
                                if (parentContext.mounted) {
                                  AppNotify.info(
                                    parentContext,
                                    '$successLabel berhasil ditambahkan',
                                  );
                                }
                              } else if (type == _ArsipType.sp) {
                                final namaP = namaPimpinanController.text
                                    .trim();
                                final valid =
                                    namaP.isNotEmpty &&
                                    (organisasi != null &&
                                        organisasi!.isNotEmpty) &&
                                    tanggalMulai != null &&
                                    tanggalBerakhir != null;
                                if (!valid) {
                                  setModalState(() {
                                    namaPimpinanError = namaP.isEmpty
                                        ? 'Wajib diisi'
                                        : null;
                                    organisasiError =
                                        (organisasi == null ||
                                            organisasi!.isEmpty)
                                        ? 'Harap pilih'
                                        : null;
                                    tanggalMulaiError = tanggalMulai == null
                                        ? 'Harap pilih'
                                        : null;
                                    tanggalBerakhirError =
                                        tanggalBerakhir == null
                                        ? 'Harap pilih'
                                        : null;
                                  });
                                  return;
                                }
                                final mulaiStr = _formatDate(tanggalMulai!);
                                final akhirStr = _formatDate(tanggalBerakhir!);
                                final newItem = _ArsipItem.sp(
                                  namaPimpinan: namaP,
                                  organisasi: organisasi!,
                                  tanggalMulai: mulaiStr,
                                  tanggalBerakhir: akhirStr,
                                  catatan: catatanController.text.trim(),
                                  fileUrl: fileName ?? '',
                                  fileName: fileName ?? '',
                                  fileMime: 'application/octet-stream',
                                  fileSize: 0,
                                  periodeId: 'periode-2026',
                                );
                                _addItem(newItem);
                                if (parentContext.mounted) {
                                  AppNotify.info(
                                    parentContext,
                                    '$successLabel berhasil ditambahkan',
                                  );
                                }
                              } else {
                                final nama = namaController.text.trim();
                                final valid =
                                    nama.isNotEmpty &&
                                    tanggal != null &&
                                    (fileName ?? '').trim().isNotEmpty;
                                if (!valid) {
                                  setModalState(() {
                                    namaError = nama.isEmpty
                                        ? 'Wajib diisi'
                                        : null;
                                    tanggalError = tanggal == null
                                        ? 'Harap pilih'
                                        : null;
                                    fileError = (fileName ?? '').trim().isEmpty
                                        ? 'Wajib diisi'
                                        : null;
                                  });
                                  return;
                                }
                                final tanggalStr = _formatDate(tanggal!);
                                final newItem = _ArsipItem.pimpinan(
                                  nama: nama,
                                  tanggal: tanggalStr,
                                  catatan: catatanController.text.trim(),
                                  fileUrl: fileName ?? '',
                                  fileName: fileName ?? '',
                                  fileMime: 'application/octet-stream',
                                  fileSize: 0,
                                  periodeId: 'periode-2026',
                                );
                                _addItem(newItem);
                                if (parentContext.mounted) {
                                  AppNotify.info(
                                    parentContext,
                                    '$successLabel berhasil ditambahkan',
                                  );
                                }
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
                      onPressed: () async {
                        Navigator.of(context).pop();
                        final deleted = await _confirmDeleteItem(
                          parentContext,
                          item,
                        );
                        if (!parentContext.mounted) return;
                        if (deleted) {
                          _deleteItem(item);
                          AppNotify.info(
                            parentContext,
                            'Data berhasil dihapus',
                          );
                        }
                      },
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

  // placeholder to satisfy part directives

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

  Future<void> _showEdit(BuildContext context, _ArsipItem item) async {
    String? organisasi = item.organisasi;
    String? jenisSurat = item.jenisSurat;
    DateTime? tanggal;
    DateTime? tanggalMulai;
    DateTime? tanggalBerakhir;
    String? fileName = item.fileName;
    String? organisasiError,
        nomorError,
        namaError,
        namaPimpinanError,
        penerimaError,
        perihalError,
        fileError,
        jenisSuratError,
        tanggalError,
        tanggalMulaiError,
        tanggalBerakhirError;

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
                              : 'Contoh: 001/PC/2026',
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
                    ] else if (item.type == _ArsipType.pimpinan) ...[
                      const Row(
                        children: [
                          Text(
                            'Nama',
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
                        controller: namaController,
                        onChanged: (value) {
                          if (namaError != null && value.trim().isNotEmpty) {
                            setModalState(() => namaError = null);
                          }
                        },
                        decoration: InputDecoration(
                          hintText: namaError != null
                              ? 'Wajib diisi'
                              : 'Nama berkas pimpinan',
                          hintStyle: namaError != null
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
                              color: namaError != null
                                  ? AppPalette.error
                                  : AppPalette.border,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(
                              color: namaError != null
                                  ? AppPalette.error
                                  : AppPalette.border,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(
                              color: namaError != null
                                  ? AppPalette.error
                                  : AppPalette.border,
                            ),
                          ),
                        ),
                      ),
                    ] else ...[
                      const Row(
                        children: [
                          Text(
                            'Nama Pimpinan',
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
                        controller: namaPimpinanController,
                        onChanged: (value) {
                          if (namaPimpinanError != null &&
                              value.trim().isNotEmpty) {
                            setModalState(() => namaPimpinanError = null);
                          }
                        },
                        decoration: InputDecoration(
                          hintText: namaPimpinanError != null
                              ? 'Wajib diisi'
                              : 'Nama pimpinan',
                          hintStyle: namaPimpinanError != null
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
                              color: namaPimpinanError != null
                                  ? AppPalette.error
                                  : AppPalette.border,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(
                              color: namaPimpinanError != null
                                  ? AppPalette.error
                                  : AppPalette.border,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(
                              color: namaPimpinanError != null
                                  ? AppPalette.error
                                  : AppPalette.border,
                            ),
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 12),
                    if (item.type != _ArsipType.pimpinan) ...[
                      LabeledActionField(
                        label: 'Organisasi',
                        valueText: organisasi ?? '',
                        placeholder: 'Pilih Organisasi',
                        isError: organisasiError != null,
                        isRequired: true,
                        onTap: () async {
                          final val = await showSelectSheet(
                            context: context,
                            title: 'Pilih Organisasi',
                            options: const ['IPNU', 'IPPNU', 'BERSAMA'],
                            initialValue: organisasi,
                          );
                          if (val != null) {
                            setModalState(() {
                              organisasi = val;
                              organisasiError = null;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 12),
                    ],
                    if (item.type == _ArsipType.surat)
                      LabeledActionField(
                        label: 'Jenis Surat',
                        valueText: jenisSurat ?? '',
                        placeholder: 'Pilih Jenis Surat',
                        isError: jenisSuratError != null,
                        isRequired: true,
                        onTap: () async {
                          final val = await showSelectSheet(
                            context: context,
                            title: 'Pilih Jenis Surat',
                            options: const ['MASUK', 'KELUAR'],
                            initialValue: jenisSurat,
                          );
                          if (val != null) {
                            setModalState(() {
                              jenisSurat = val;
                              jenisSuratError = null;
                            });
                          }
                        },
                      ),
                    const SizedBox(height: 12),
                    if (item.type == _ArsipType.sp) ...[
                      const SizedBox(height: 12),
                      LabeledActionField(
                        label: 'Tanggal Mulai',
                        valueText: item.tanggalMulai ?? '',
                        placeholder: 'Pilih Tanggal Mulai',
                        isError: tanggalMulaiError != null,
                        isRequired: true,
                        onTap: () async {
                          final val = await showDateSheet(
                            context: context,
                            title: 'Pilih Tanggal Mulai',
                            initialValue: tanggalMulai,
                          );
                          if (val != null) {
                            setModalState(() {
                              tanggalMulai = val;
                              tanggalMulaiError = null;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 12),
                      const SizedBox(height: 12),
                      LabeledActionField(
                        label: 'Tanggal Berakhir',
                        valueText: item.tanggalBerakhir ?? '',
                        placeholder: 'Pilih Tanggal Berakhir',
                        isError: tanggalBerakhirError != null,
                        isRequired: true,
                        onTap: () async {
                          final val = await showDateSheet(
                            context: context,
                            title: 'Pilih Tanggal Berakhir',
                            initialValue: tanggalBerakhir,
                          );
                          if (val != null) {
                            setModalState(() {
                              tanggalBerakhir = val;
                              tanggalBerakhirError = null;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 12),
                    ] else ...[
                      const SizedBox(height: 12),
                      LabeledActionField(
                        label: item.type == _ArsipType.surat
                            ? 'Tanggal Surat'
                            : 'Tanggal',
                        valueText: item.type == _ArsipType.surat
                            ? (item.tanggalSurat ?? '')
                            : (item.tanggal ?? ''),
                        placeholder: item.type == _ArsipType.surat
                            ? 'Pilih Tanggal Surat'
                            : 'Pilih Tanggal',
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
                    ],
                    const SizedBox(height: 12),
                    if (item.type == _ArsipType.surat) ...[
                      const Row(
                        children: [
                          Text(
                            'Penerima/Pengirim',
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
                        controller: penerimaController,
                        onChanged: (value) {
                          if (penerimaError != null &&
                              value.trim().isNotEmpty) {
                            setModalState(() => penerimaError = null);
                          }
                        },
                        decoration: InputDecoration(
                          hintText: penerimaError != null
                              ? 'Wajib diisi'
                              : 'Nama penerima atau pengirim',
                          hintStyle: penerimaError != null
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
                              color: penerimaError != null
                                  ? AppPalette.error
                                  : AppPalette.border,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(
                              color: penerimaError != null
                                  ? AppPalette.error
                                  : AppPalette.border,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(
                              color: penerimaError != null
                                  ? AppPalette.error
                                  : AppPalette.border,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Row(
                        children: [
                          Text(
                            'Perihal',
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
                        controller: perihalController,
                        onChanged: (value) {
                          if (perihalError != null && value.trim().isNotEmpty) {
                            setModalState(() => perihalError = null);
                          }
                        },
                        decoration: InputDecoration(
                          hintText: perihalError != null
                              ? 'Wajib diisi'
                              : 'Isi perihal surat',
                          hintStyle: perihalError != null
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
                              color: perihalError != null
                                  ? AppPalette.error
                                  : AppPalette.border,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(
                              color: perihalError != null
                                  ? AppPalette.error
                                  : AppPalette.border,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(
                              color: perihalError != null
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
                      placeholder: fileError != null
                          ? 'Wajib diisi'
                          : 'Pilih File',
                      isError: fileError != null,
                      isRequired: item.type == _ArsipType.pimpinan,
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
                              bool valid = true;
                              if (item.type == _ArsipType.surat) {
                                final nomor = nomorController.text.trim();
                                final penerima = penerimaController.text.trim();
                                final perihal = perihalController.text.trim();
                                final effOrganisasi =
                                    (organisasi ?? item.organisasi ?? '')
                                        .trim();
                                final effJenis =
                                    (jenisSurat ?? item.jenisSurat ?? '')
                                        .trim();
                                final effTanggal =
                                    (tanggal != null
                                            ? '${tanggal!.year}'
                                            : (item.tanggalSurat ?? ''))
                                        .trim();
                                valid =
                                    nomor.isNotEmpty &&
                                    effOrganisasi.isNotEmpty &&
                                    effJenis.isNotEmpty &&
                                    effTanggal.isNotEmpty &&
                                    penerima.isNotEmpty &&
                                    perihal.isNotEmpty;
                              } else if (item.type == _ArsipType.sp) {
                                final namaP = namaPimpinanController.text
                                    .trim();
                                final effOrganisasi =
                                    (organisasi ?? item.organisasi ?? '')
                                        .trim();
                                final effMulai =
                                    (tanggalMulai != null
                                            ? '${tanggalMulai!.year}'
                                            : (item.tanggalMulai ?? ''))
                                        .trim();
                                final effAkhir =
                                    (tanggalBerakhir != null
                                            ? '${tanggalBerakhir!.year}'
                                            : (item.tanggalBerakhir ?? ''))
                                        .trim();
                                valid =
                                    namaP.isNotEmpty &&
                                    effOrganisasi.isNotEmpty &&
                                    effMulai.isNotEmpty &&
                                    effAkhir.isNotEmpty;
                              } else {
                                final nama = namaController.text.trim();
                                final effFile = (fileName ?? item.fileName)
                                    .trim();
                                final effTanggal =
                                    (tanggal != null
                                            ? '${tanggal!.year}'
                                            : (item.tanggal ?? ''))
                                        .trim();
                                valid =
                                    nama.isNotEmpty &&
                                    effTanggal.isNotEmpty &&
                                    effFile.isNotEmpty;
                              }
                              if (!valid) {
                                setModalState(() {
                                  if (item.type == _ArsipType.surat) {
                                    nomorError =
                                        nomorController.text.trim().isEmpty
                                        ? 'Wajib diisi'
                                        : null;
                                    penerimaError =
                                        penerimaController.text.trim().isEmpty
                                        ? 'Wajib diisi'
                                        : null;
                                    perihalError =
                                        perihalController.text.trim().isEmpty
                                        ? 'Wajib diisi'
                                        : null;
                                  } else if (item.type == _ArsipType.sp) {
                                    namaPimpinanError =
                                        namaPimpinanController.text
                                            .trim()
                                            .isEmpty
                                        ? 'Wajib diisi'
                                        : null;
                                  } else {
                                    namaError =
                                        namaController.text.trim().isEmpty
                                        ? 'Wajib diisi'
                                        : null;
                                    fileError =
                                        (fileName ?? item.fileName)
                                            .trim()
                                            .isEmpty
                                        ? 'Wajib diisi'
                                        : null;
                                  }
                                  organisasiError =
                                      (organisasi ?? item.organisasi ?? '')
                                          .trim()
                                          .isEmpty
                                      ? 'Harap pilih'
                                      : null;
                                  jenisSuratError =
                                      item.type == _ArsipType.surat &&
                                          (jenisSurat ?? item.jenisSurat ?? '')
                                              .trim()
                                              .isEmpty
                                      ? 'Harap pilih'
                                      : null;
                                  if (item.type == _ArsipType.sp) {
                                    final hasMulai =
                                        (tanggalMulai != null) ||
                                        (item.tanggalMulai ?? '').isNotEmpty;
                                    final hasAkhir =
                                        (tanggalBerakhir != null) ||
                                        (item.tanggalBerakhir ?? '').isNotEmpty;
                                    tanggalMulaiError = hasMulai
                                        ? null
                                        : 'Harap pilih';
                                    tanggalBerakhirError = hasAkhir
                                        ? null
                                        : 'Harap pilih';
                                  } else {
                                    final hasTanggal =
                                        (tanggal != null) ||
                                        ((item.type == _ArsipType.surat
                                                    ? item.tanggalSurat
                                                    : item.tanggal) ??
                                                '')
                                            .isNotEmpty;
                                    tanggalError = hasTanggal
                                        ? null
                                        : 'Harap pilih';
                                  }
                                });
                                return;
                              }
                              if (item.type == _ArsipType.surat) {
                                final updated = _ArsipItem.surat(
                                  nomorSurat: nomorController.text.trim(),
                                  jenisSurat:
                                      (jenisSurat ?? item.jenisSurat ?? '')
                                          .trim(),
                                  organisasi:
                                      (organisasi ?? item.organisasi ?? '')
                                          .trim(),
                                  tanggalSurat: tanggal != null
                                      ? _formatDate(tanggal!)
                                      : (item.tanggalSurat ?? ''),
                                  penerimaPengirim: penerimaController.text
                                      .trim(),
                                  perihal: perihalController.text.trim(),
                                  deskripsi: deskripsiController.text.trim(),
                                  fileUrl: item.fileUrl,
                                  fileName: item.fileName,
                                  fileMime: item.fileMime,
                                  fileSize: item.fileSize,
                                  periodeId: item.periodeId,
                                );
                                _updateItem(item, updated);
                              } else if (item.type == _ArsipType.sp) {
                                final updated = _ArsipItem.sp(
                                  namaPimpinan: namaPimpinanController.text
                                      .trim(),
                                  organisasi:
                                      (organisasi ?? item.organisasi ?? '')
                                          .trim(),
                                  tanggalMulai: tanggalMulai != null
                                      ? _formatDate(tanggalMulai!)
                                      : (item.tanggalMulai ?? ''),
                                  tanggalBerakhir: tanggalBerakhir != null
                                      ? _formatDate(tanggalBerakhir!)
                                      : (item.tanggalBerakhir ?? ''),
                                  catatan: catatanController.text.trim(),
                                  fileUrl: item.fileUrl,
                                  fileName: item.fileName,
                                  fileMime: item.fileMime,
                                  fileSize: item.fileSize,
                                  periodeId: item.periodeId,
                                );
                                _updateItem(item, updated);
                              } else {
                                final updated = _ArsipItem.pimpinan(
                                  nama: namaController.text.trim(),
                                  tanggal: tanggal != null
                                      ? _formatDate(tanggal!)
                                      : (item.tanggal ?? ''),
                                  catatan: catatanController.text.trim(),
                                  fileUrl: item.fileUrl,
                                  fileName: item.fileName,
                                  fileMime: item.fileMime,
                                  fileSize: item.fileSize,
                                  periodeId: item.periodeId,
                                );
                                _updateItem(item, updated);
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
}
