class PeminjamModel {
  int idPeminjam;
  String namaPeminjam;
  String password;
  String namaLengkap;
  String email;
  String noTelpon;
  int idJenisPeminjam;
  int idOrmawa;

  PeminjamModel({
    required this.idPeminjam,
    required this.namaPeminjam,
    required this.password,
    required this.namaLengkap,
    required this.email,
    required this.noTelpon,
    required this.idJenisPeminjam,
    required this.idOrmawa,
  });

  factory PeminjamModel.fromJson(Map<String, dynamic> json) => PeminjamModel(
        idPeminjam: json["id_peminjam"],
        namaPeminjam: json["nama_peminjam"],
        password: json["password"],
        namaLengkap: json["nama_lengkap"],
        email: json["email"],
        noTelpon: json["no_telpon"],
        idJenisPeminjam: json["id_jenis_peminjam"],
        idOrmawa: json["id_ormawa"],
      );

  Map<String, dynamic> toJson() => {
        "id_peminjam": idPeminjam,
        "nama_peminjam": namaPeminjam,
        "password": password,
        "nama_lengkap": namaLengkap,
        "email": email,
        "no_telpon": noTelpon,
        "id_jenis_peminjam": idJenisPeminjam,
        "id_ormawa": idOrmawa,
      };
}
