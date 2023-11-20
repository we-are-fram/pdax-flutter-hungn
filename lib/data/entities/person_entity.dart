import 'dart:convert';

class PersonEntity {
  int id;
  String firstname;
  String lastname;
  String email;
  String phone;
  String birthday;
  String gender;
  AddressEntity address;
  String website;
  String image;

  PersonEntity({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.phone,
    required this.birthday,
    required this.gender,
    required this.address,
    required this.website,
    required this.image,
  });

  factory PersonEntity.fromJson(Map<String, dynamic> json) => PersonEntity(
        id: json["id"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        email: json["email"],
        phone: json["phone"],
        birthday: json["birthday"],
        gender: json["gender"],
        address: AddressEntity.fromJson(json["address"]),
        website: json["website"],
        image: json["image"],
      );
}

class AddressEntity {
  int id;
  String street;
  String streetName;
  String buildingNumber;
  String city;
  String zipcode;
  String country;
  String countyCode;
  double latitude;
  double longitude;

  AddressEntity({
    required this.id,
    required this.street,
    required this.streetName,
    required this.buildingNumber,
    required this.city,
    required this.zipcode,
    required this.country,
    required this.countyCode,
    required this.latitude,
    required this.longitude,
  });

  factory AddressEntity.fromJson(Map<String, dynamic> json) => AddressEntity(
        id: json["id"],
        street: json["street"],
        streetName: json["streetName"],
        buildingNumber: json["buildingNumber"],
        city: json["city"],
        zipcode: json["zipcode"],
        country: json["country"],
        countyCode: json["county_code"],
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
      );
}
