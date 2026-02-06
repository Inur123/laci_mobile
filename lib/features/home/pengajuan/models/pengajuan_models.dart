part of '../screens/pengajuan_screen.dart';

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
