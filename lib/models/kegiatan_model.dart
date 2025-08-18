// To parse this JSON data, do
//
//     final kegiatanModel = kegiatanModelFromJson(jsonString);

import 'dart:convert';

KegiatanModel kegiatanModelFromJson(String str) =>
    KegiatanModel.fromJson(json.decode(str));

String kegiatanModelToJson(KegiatanModel data) => json.encode(data.toJson());

class KegiatanModel {
  int idKegiatan;
  String namaKegiatan;
  String temaKegiatan;
  String daftarPanitia;
  int idOrmawa;
  int idMahasiswa;
  int idPeminjam;

  KegiatanModel({
    required this.idKegiatan,
    required this.namaKegiatan,
    required this.temaKegiatan,
    required this.daftarPanitia,
    required this.idOrmawa,
    required this.idMahasiswa,
    required this.idPeminjam,
  });

  factory KegiatanModel.fromJson(Map<String, dynamic> json) => KegiatanModel(
        idKegiatan: json["id_kegiatan"],
        namaKegiatan: json["nama_kegiatan"],
        temaKegiatan: json["tema_kegiatan"],
        daftarPanitia: json["daftar_panitia"],
        idOrmawa: json["id_ormawa"],
        idMahasiswa: json["id_mahasiswa"],
        idPeminjam: json["id_peminjam"],
      );

  Map<String, dynamic> toJson() => {
        "id_kegiatan": idKegiatan,
        "nama_kegiatan": namaKegiatan,
        "tema_kegiatan": temaKegiatan,
        "daftar_panitia": daftarPanitia,
        "id_ormawa": idOrmawa,
        "id_mahasiswa": idMahasiswa,
        "id_peminjam": idPeminjam,
      };
}
