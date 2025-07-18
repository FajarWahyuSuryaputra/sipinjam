class RuanganModel {
  int idRuangan;
  String namaRuangan;
  String namaGedung;
  int idGedung;
  String? deskripsiRuangan;
  int kapasitas;
  String namaPeminjam;
  String? namaFasilitas;
  List<String>? fotoRuangan;

  RuanganModel({
    required this.idRuangan,
    required this.namaRuangan,
    required this.namaGedung,
    required this.idGedung,
    this.deskripsiRuangan,
    required this.kapasitas,
    required this.namaPeminjam,
    this.namaFasilitas,
    this.fotoRuangan,
  });

  factory RuanganModel.fromJson(Map<String, dynamic> json) => RuanganModel(
        idRuangan: json["id_ruangan"],
        namaRuangan: json["nama_ruangan"],
        namaGedung: json["nama_gedung"],
        idGedung: json["id_gedung"],
        deskripsiRuangan: json["deskripsi_ruangan"],
        kapasitas: json["kapasitas"],
        namaPeminjam: json["nama_peminjam"],
        namaFasilitas: json["nama_fasilitas"] ?? '',
        fotoRuangan: json["foto_ruangan"] != null
            ? List<String>.from(json["foto_ruangan"].map((x) => x))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "id_ruangan": idRuangan,
        "nama_ruangan": namaRuangan,
        "nama_gedung": namaGedung,
        "id_gedung": idGedung,
        "deskripsi_ruangan": deskripsiRuangan,
        "kapasitas": kapasitas,
        "nama_peminjam": namaPeminjam,
        "nama_fasilitas": namaFasilitas ?? '',
        "foto_ruangan": fotoRuangan != null
            ? List<dynamic>.from(fotoRuangan!.map((x) => x))
            : [],
      };
}
