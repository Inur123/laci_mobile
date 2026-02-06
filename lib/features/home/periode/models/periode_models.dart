part of '../screens/periode_screen.dart';

class Periode {
  const Periode({required this.nama, required this.isActive});

  final String nama;
  final bool isActive;

  Periode copyWith({String? nama, bool? isActive}) {
    return Periode(
      nama: nama ?? this.nama,
      isActive: isActive ?? this.isActive,
    );
  }
}
