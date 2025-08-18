import 'package:dartz/dartz.dart';
import 'package:sipinjam/config/app_constans.dart';
import 'package:sipinjam/config/app_response.dart';
import 'package:sipinjam/config/failure.dart';
import 'package:http/http.dart' as http;

class KegiatanDatasource {
  static Future<Either<Failure, Map>> getAllKegiatan() async {
    Uri url = Uri.parse("${AppConstans.baseUrl}/routes/kegiatan.php");
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
