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
}
