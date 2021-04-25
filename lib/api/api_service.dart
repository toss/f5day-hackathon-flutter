import 'package:flutter/foundation.dart';

abstract class AbstractApi {
  @protected
  final String baseUrl;

  AbstractApi(this.baseUrl);
}
