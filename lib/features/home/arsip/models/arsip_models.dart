part of '../screens/arsip_screen.dart';

class _ArsipCategory {
  const _ArsipCategory({
    required this.type,
    required this.label,
    required this.subtitle,
  });

  final _ArsipType type;
  final String label;
  final String subtitle;
}

enum _ArsipType { surat, pimpinan, sp }

class _ArsipItem {
  const _ArsipItem._({
    required this.type,
    required this.title,
    required this.subtitle,
    required this.dateLabel,
    required this.fileUrl,
    required this.fileName,
    required this.fileMime,
    required this.fileSize,
    required this.periodeId,
    this.jenisSurat,
    this.organisasi,
    this.nomorSurat,
    this.tanggalSurat,
    this.penerimaPengirim,
    this.perihal,
    this.deskripsi,
    this.nama,
    this.tanggal,
    this.catatan,
    this.namaPimpinan,
    this.tanggalMulai,
    this.tanggalBerakhir,
    this.localPath,
  });

  const _ArsipItem.surat({
    required String nomorSurat,
    required String jenisSurat,
    required String organisasi,
    required String tanggalSurat,
    required String penerimaPengirim,
    required String perihal,
    required String deskripsi,
    required String fileUrl,
    required String fileName,
    required String fileMime,
    required int fileSize,
    required String periodeId,
  }) : this._(
         type: _ArsipType.surat,
         title: nomorSurat,
         subtitle: perihal,
         dateLabel: tanggalSurat,
         fileUrl: fileUrl,
         fileName: fileName,
         fileMime: fileMime,
         fileSize: fileSize,
         periodeId: periodeId,
         jenisSurat: jenisSurat,
         organisasi: organisasi,
         nomorSurat: nomorSurat,
         tanggalSurat: tanggalSurat,
         penerimaPengirim: penerimaPengirim,
         perihal: perihal,
         deskripsi: deskripsi,
       );

  const _ArsipItem.pimpinan({
    required String nama,
    required String tanggal,
    required String catatan,
    required String fileUrl,
    required String fileName,
    required String fileMime,
    required int fileSize,
    required String periodeId,
  }) : this._(
         type: _ArsipType.pimpinan,
         title: nama,
         subtitle: catatan,
         dateLabel: tanggal,
         fileUrl: fileUrl,
         fileName: fileName,
         fileMime: fileMime,
         fileSize: fileSize,
         periodeId: periodeId,
         nama: nama,
         tanggal: tanggal,
         catatan: catatan,
       );

  const _ArsipItem.sp({
    required String namaPimpinan,
    required String organisasi,
    required String tanggalMulai,
    required String tanggalBerakhir,
    required String catatan,
    required String fileUrl,
    required String fileName,
    required String fileMime,
    required int fileSize,
    required String periodeId,
  }) : this._(
         type: _ArsipType.sp,
         title: namaPimpinan,
         subtitle: catatan,
         dateLabel: tanggalMulai,
         fileUrl: fileUrl,
         fileName: fileName,
         fileMime: fileMime,
         fileSize: fileSize,
         periodeId: periodeId,
         organisasi: organisasi,
         namaPimpinan: namaPimpinan,
         tanggalMulai: tanggalMulai,
         tanggalBerakhir: tanggalBerakhir,
         catatan: catatan,
       );

  final _ArsipType type;
  final String title;
  final String subtitle;
  final String dateLabel;
  final String fileUrl;
  final String fileName;
  final String fileMime;
  final int fileSize;
  final String periodeId;
  final String? jenisSurat;
  final String? organisasi;
  final String? nomorSurat;
  final String? tanggalSurat;
  final String? penerimaPengirim;
  final String? perihal;
  final String? deskripsi;
  final String? nama;
  final String? tanggal;
  final String? catatan;
  final String? namaPimpinan;
  final String? tanggalMulai;
  final String? tanggalBerakhir;
  final String? localPath;
}
