import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

abstract class AbstractApi {
  @protected
  final String baseUrl;

  AbstractApi(this.baseUrl);

  @protected
  Future<http.Response> httpGet(Uri uri) {
    return http.get(uri, headers: {"Authorization": "Bearer phobobunbo"});
  }

  @protected
  Future<http.Response> httpPost(Uri uri, Object body) {
    return http.post(uri,
        headers: {
          "Authorization": "Bearer phobobunbo",
          HttpHeaders.contentTypeHeader: "application/json"
        },
        body: body);
  }
}
