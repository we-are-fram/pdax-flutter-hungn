import 'dart:convert';

import 'package:faker_api_test/data/entities/person_entity.dart';
import 'package:faker_api_test/data/models/viewable_person.dart';

import 'address.dart';

class Person implements ViewablePerson {
  int id;
  String? firstname;
  String? lastname;
  String? email;
  String? phone;
  DateTime? birthday;
  String? gender;
  Address? address;
  String? website;
  String? image;

  @override
  String? get name => (this.firstname ?? "") + " " + (this.lastname ?? "");

  @override
  String get initialiserLetters =>
      ((this.firstname ?? " ").substring(0, 1).toUpperCase() + (this.lastname ?? " ").substring(0, 1).toUpperCase())
          .trim();

  @override
  String? get emailAddress => this.email ?? "";

  @override
  String? get imageUrl => this.image;

  Person({
    required this.id,
    this.firstname,
    this.lastname,
    this.email,
    this.phone,
    this.birthday,
    this.gender,
    this.address,
    this.website,
    this.image,
  });

  factory Person.fromEntity(PersonEntity entity) => Person(
        id: entity.id,
        firstname: entity.firstname,
        lastname: entity.lastname,
        email: entity.email,
        phone: entity.phone,
        birthday: DateTime.parse(entity.birthday),
        gender: entity.gender,
        address: Address.fromEntity(entity.address),
        website: entity.website,
        image: entity.image,
      );
}
