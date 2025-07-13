import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:sipinjam/config/app_constans.dart';
import 'package:sipinjam/config/app_response.dart';
import 'package:sipinjam/config/failure.dart';

class RuanganDatasource {
  static Future<Either<Failure, Map>> getAllRuangan() async {
    Uri url = Uri.parse("${AppConstans.baseUrl}/routes/ruangan.php");
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
