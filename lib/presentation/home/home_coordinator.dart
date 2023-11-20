import 'package:faker_api_test/data/models/person.dart';
import 'package:faker_api_test/presentation/person_details/person_detailed_view.dart';
import 'package:faker_api_test/presentation/person_details/person_detailed_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'home_view.dart';
import 'home_view_model.dart';

abstract class BaseCoordinator {
  StatefulWidget getActivePage();
}

class HomeCoordinator implements BaseCoordinator {
  late StatefulWidget entryPage;

  HomeCoordinator() {
    HomeScreenViewModel viewModel = HomeScreenViewModel();
    entryPage = MyHomePage(title: "Home", viewModel: viewModel);

    observeTransition();
  }

  @override
  StatefulWidget getActivePage() {
    return entryPage;
  }

  void observeTransition() {
    if ((entryPage is MyHomePage) == false) return;

    (entryPage as MyHomePage).outputPublisher.listen((HomeOutputValue event) {
      switch (event.eventType) {
        case HomeOutputEvent.goToDetails:
          Person personToTreat = event.person;
          PersonDetailedViewModel viewModel =
              PersonDetailedViewModel(person: personToTreat as Person);

          Navigator.of(event.context).push(MaterialPageRoute(
              builder: (ctx) => PersonDetailedPage(
                    viewablePerson: personToTreat as Person,
                    viewModel: viewModel,
                  )));
          break;
        case HomeOutputEvent.goToOtherScreen:
          break;
        case HomeOutputEvent.goToSomewhereElse:
          break;
      }
    });
  }
}
