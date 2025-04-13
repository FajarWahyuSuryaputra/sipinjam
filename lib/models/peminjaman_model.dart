class PeminjamanModel {
  int idPeminjaman;
  String namaKegiatan;
  String temaKegiatan;
  int idPeminjam;
  int idOrmawa;
  DateTime tglPeminjaman;
  String sesiPeminjaman;
  String daftarPanitia;
  String namaRuangan;
  String namaKetuaOrmawa;
  String namaKetuaPelaksana;
  String namaStatus;
  dynamic keterangan;
  String namaOrmawa;
  String namaLengkap;

  PeminjamanModel({
    required this.idPeminjaman,
    required this.namaKegiatan,
    required this.temaKegiatan,
    required this.idPeminjam,
    required this.idOrmawa,
    required this.tglPeminjaman,
    required this.sesiPeminjaman,
    required this.daftarPanitia,
    required this.namaRuangan,
    required this.namaKetuaOrmawa,
    required this.namaKetuaPelaksana,
    required this.namaStatus,
    required this.keterangan,
    required this.namaOrmawa,
    required this.namaLengkap,
  });

  factory PeminjamanModel.fromJson(Map<String, dynamic> json) =>
      PeminjamanModel(
        idPeminjaman: json["id_peminjaman"],
        namaKegiatan: json["nama_kegiatan"],
        temaKegiatan: json["tema_kegiatan"],
        idPeminjam: json["id_peminjam"],
        idOrmawa: json["id_ormawa"],
        tglPeminjaman: DateTime.parse(json["tgl_peminjaman"]).toLocal(),
        sesiPeminjaman: json["sesi_peminjaman"],
        daftarPanitia: json["daftar_panitia"],
        namaRuangan: json["nama_ruangan"],
        namaKetuaOrmawa: json["nama_ketua_ormawa"],
        namaKetuaPelaksana: json["nama_ketua_pelaksana"],
        namaStatus: json["nama_status"],
        keterangan: json["keterangan"],
        namaOrmawa: json["nama_ormawa"],
        namaLengkap: json["nama_lengkap"],
      );

  Map<String, dynamic> toJson() => {
        "id_peminjaman": idPeminjaman,
        "nama_kegiatan": namaKegiatan,
        "tema_kegiatan": temaKegiatan,
        "id_peminjam": idPeminjam,
        "id_ormawa": idOrmawa,
        "tgl_peminjaman": tglPeminjaman.toIso8601String(),
        "sesi_peminjaman": sesiPeminjaman,
        "daftar_panitia": daftarPanitia,
        "nama_ruangan": namaRuangan,
        "nama_ketua_ormawa": namaKetuaOrmawa,
        "nama_ketua_pelaksana": namaKetuaPelaksana,
        "nama_status": namaStatus,
        "keterangan": keterangan,
        "nama_ormawa": namaOrmawa,
        "nama_lengkap": namaLengkap,
      };
}
