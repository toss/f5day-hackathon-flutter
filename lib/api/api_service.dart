
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

abstract class AbstractApi {
  @protected
  final String baseUrl;

  AbstractApi(this.baseUrl);

  @protected
  Future<http.Response> httpGet(Uri uri) async {
    return http.get(uri, headers: {"Authorization": "Bearer phobobunbo"});
  }
}
