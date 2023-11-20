import 'dart:async';

import 'package:faker_api_test/data/models/person.dart';
import 'package:faker_api_test/data/response/persons_responses.dart';
import 'package:faker_api_test/domain/model/typealiases.dart';
import 'package:faker_api_test/domain/usecases/get_persons_usecase.dart';
import 'package:faker_api_test/presentation/bases/base_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class HomeScreenViewModel implements BaseViewModel {
// Inputs:
  late Trigger<dynamic> _loadMoreTrigger;
  late StreamController<dynamic> _loadFromBeginningTrigger;

  // Outputs:
  Subject<List<Person>> _personsStreamController = StreamController.broadcast();
  Publisher<List<Person>> get personsStream => _personsStreamController.stream;

  Subject<int> _currentPageStreamController = StreamController.broadcast();
  Stream<int> get currentPageStream => _currentPageStreamController.stream;

  StreamController<bool> _isLoadingStream = StreamController.broadcast();
  @override
  get isLoading => _isLoadingStream.stream;

  GetPersonsUseCaseInterface getPersonsUseCase = GetIt.instance<GetPersonsUseCaseInterface>();

  int currentPage = 0;
  final int maxFetches = 3;

  void bindViewModel({
    required StreamController<dynamic> loadFromBeginningTrigger,
    required StreamController<dynamic> loadMoreTrigger,
  }) {
    _loadFromBeginningTrigger = loadFromBeginningTrigger;
    _loadMoreTrigger = loadMoreTrigger;

    handleObservers();
  }

  @override
  void handleObservers() {
    // the first fetch (10 items):
    _loadFromBeginningTrigger.stream.listen((event) {
      _resetCurrentPage();
      _personsStreamController.add([]);
      getPersons(numberOfItems: 10);
    });

    // the other fetches (20 items per fetch):
    _loadMoreTrigger.stream.listen((event) {
      getPersons(numberOfItems: 20);
    });
  }

  void _incrementCurrentPage({int increment = 1}) {
    currentPage += increment;
  }

  void _resetCurrentPage() {
    currentPage = 0;
  }

  List<Person> parsePersons({PersonResponse? personResponse}) {
    if (personResponse == null) return [];
    return personResponse.data?.map((e) => Person.fromEntity(e)).toList() ?? [];
  }

  void getPersons({required int numberOfItems}) {
    if (currentPage > maxFetches) {
      _personsStreamController.addError(Exception("No more data, please refresh instead"));
      return;
    }

    enableLoading();
    getPersonsUseCase.getPersons(numberOfItems: numberOfItems).then(
      (PersonResponse? personResponse) {
        disableLoading();
        _personsStreamController.add(parsePersons(personResponse: personResponse));

        _incrementCurrentPage(increment: 1);
        _currentPageStreamController.add(currentPage);
      },
      onError: (dynamic error) {
        disableLoading();
        debugPrint(">>> error when get personResponse: ${error.toString()}}");
      },
    );
  }

  void enableLoading() {
    _isLoadingStream.add(true);
  }

  void disableLoading() {
    _isLoadingStream.add(false);
  }
}
