import 'dart:async';
import 'dart:convert';

import 'package:faker_api_test/data/entities/person_entity.dart';
import 'package:faker_api_test/data/response/persons_responses.dart';
import 'package:faker_api_test/services/api_domain_url.dart';
import 'package:faker_api_test/services/api_service.dart';
import 'package:flutter/cupertino.dart';

abstract class PersonRepositoryInterface {
  late APIService apiService;
  Future<PersonResponse?> getPersons({int numberOfItems});
}

class PersonsRepository implements PersonRepositoryInterface {
  final String getPersonsPath = "/persons";

  @override
  APIService apiService = APIService(baseUrl: APIDomain.apiDomainUrl);

  @override
  Future<PersonResponse?> getPersons({int numberOfItems = 10}) async {
    PersonResponse? personsResponse;

    Map<String, dynamic> params = {"_quantity": numberOfItems};
    params.removeWhere((key, value) => value == null || value.toString().isEmpty);

    final response = await apiService.get(url: getPersonsPath, queryParams: params);
    try {
      dynamic res = await response;
      String jsonString = res.toString();
      Map<String, dynamic> toReturn = jsonDecode(jsonString);

      personsResponse = PersonResponse.fromJson(toReturn);

      debugPrint(">>> Results retrieved: $personsResponse");
    } catch (e) {
      debugPrint(">>> Error when parsing data: $e");
    }

    return personsResponse;
  }
}
