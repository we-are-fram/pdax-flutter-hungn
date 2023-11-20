import 'package:flutter/foundation.dart';

class APIDomain {
  static String get apiDomainUrl {
    if (kReleaseMode) {
      return "https://fakerapi.it/api/v1";
    }
    return "https://fakerapi.it/api/v1";
  }
}
