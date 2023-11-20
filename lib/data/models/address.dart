import 'package:faker_api_test/data/entities/person_entity.dart';

class Address {
  int id;
  String? street;
  String? streetName;
  String? buildingNumber;
  String? city;
  String? zipcode;
  String? country;
  String? countyCode;
  double? latitude;
  double? longitude;

  Address({
    required this.id,
    this.street,
    this.streetName,
    this.buildingNumber,
    this.city,
    this.zipcode,
    this.country,
    this.countyCode,
    this.latitude,
    this.longitude,
  });

  String get readableAddress {
    return [
      buildingNumber,
      ",",
      street,
      streetName,
      ",",
      city,
      ",",
      countyCode,
      countyCode,
      ",",
      zipcode
    ].join(" ").trim();
  }

  factory Address.fromEntity(AddressEntity entity) => Address(
        id: entity.id,
        street: entity.street,
        streetName: entity.streetName,
        buildingNumber: entity.buildingNumber,
        city: entity.city,
        zipcode: entity.zipcode,
        country: entity.country,
        countyCode: entity.countyCode,
        latitude: entity.latitude,
        longitude: entity.longitude,
      );
}
