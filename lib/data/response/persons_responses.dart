import 'package:faker_api_test/data/entities/person_entity.dart';

class PersonResponse {
  String? status;
  int? code;
  int? total;
  List<PersonEntity>? data;

  PersonResponse({
    this.status,
    this.code,
    this.total,
    this.data,
  });

  factory PersonResponse.fromJson(Map<String, dynamic> json) => PersonResponse(
        status: json["status"],
        code: json["code"],
        total: json["total"],
        data: json["data"] == null
            ? []
            : List<PersonEntity>.from(
                json["data"]!.map((x) => PersonEntity.fromJson(x))),
      );
}
