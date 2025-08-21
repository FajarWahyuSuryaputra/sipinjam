import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:sipinjam/config/app_constans.dart';
import 'package:sipinjam/config/app_response.dart';
import 'package:sipinjam/config/failure.dart';
import 'package:http/http.dart' as http;

class PeminjamanDatasource {
  static Future<Either<Failure, Map>> peminjamanByOrmawa(int idOrmawa) async {
    Uri url =
        Uri.parse("${AppConstans.baseUrl}/routes/peminjaman.php/$idOrmawa");
    try {
      final response = await http.get(url);
      final data = AppResponse.data(response);
      return Right(data);
    } catch (e) {
      if (e is Failure) {
        return Left(e);
      }

      return Left(FetchFailure(e.toString()));
    }
  }

  static Future<Either<Failure, Map>> getAllPeminjaman() async {
    Uri url = Uri.parse("${AppConstans.baseUrl}/routes/peminjaman.php");
    try {
      final response = await http.get(url);
      final data = AppResponse.data(response);
      return Right(data);
    } catch (e) {
      if (e is Failure) {
        return Left(e);
      }

      return Left(FetchFailure(e.toString()));
    }
  }

  static Future<Either<Failure, Map>> postPeminjaman(
    int? idKegiatan,
    int? idRuangan,
    DateTime? tglPeminjaman,
    String? sesiPeminjaman,
    String? keterangan,
  ) async {
    Uri url = Uri.parse("${AppConstans.baseUrl}/routes/peminjaman.php");

    try {
      final body = [
        {
          "id_kegiatan": idKegiatan,
          "id_ruangan": idRuangan,
          "tgl_peminjaman": tglPeminjaman
              ?.toIso8601String()
              .split("T")
              .first, // format YYYY-MM-DD
          "sesi_peminjaman": int.tryParse(sesiPeminjaman ?? "0"),
          "id_status": 1,
          "keterangan": keterangan,
        }
      ];

      final response = await http.post(
        url,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json"
        },
        body: jsonEncode(body),
      );

      final data = AppResponse.data(response);
      return Right(data);
    } catch (e) {
      if (e is Failure) {
        return Left(e);
      }
      return Left(FetchFailure(e.toString()));
    }
  }
}
