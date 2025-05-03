import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:sipinjam/config/app_constans.dart';
import 'package:sipinjam/config/app_response.dart';
import 'package:sipinjam/config/failure.dart';
import 'package:http/http.dart' as http;

class UserDatasource {
  static Future<Either<Failure, Map>> login(
      String username, String password) async {
    Uri url = Uri.parse('${AppConstans.baseUrl}/routes/authentications.php');
    try {
      final response = await http.post(url,
          headers: {"Accept": "application/json"},
          body: jsonEncode({
            "nama_peminjam": username,
            "password": password,
          }));
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
