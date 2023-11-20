import 'dart:async';
import 'dart:io';

import 'package:faker_api_test/data/entities/person_entity.dart';
import 'package:faker_api_test/data/models/person.dart';
import 'package:faker_api_test/data/models/viewable_person.dart';
import 'package:faker_api_test/domain/model/typealiases.dart';
import 'package:faker_api_test/presentation/bases/base_state.dart';
import 'package:faker_api_test/presentation/person_details/person_detailed_view.dart';
import 'package:faker_api_test/presentation/person_details/person_detailed_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'home_view_model.dart';

class HomeOutputValue {
  final BuildContext context;
  final Person person;
  final HomeOutputEvent eventType;
  HomeOutputValue({required this.person, required this.eventType, required this.context});
}

enum HomeOutputEvent { goToDetails, goToOtherScreen, goToSomewhereElse }

class MyHomePage extends StatefulWidget {
  final String title;
  final HomeScreenViewModel viewModel;
  MyHomePage({super.key, required this.title, required this.viewModel});

  Trigger<HomeOutputValue> _outputTrigger = StreamController.broadcast();
  Publisher<HomeOutputValue> get outputPublisher => _outputTrigger.stream;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends BaseState<MyHomePage> {
  Subject<HomeOutputValue> outputSubject = StreamController.broadcast();
  List<ViewablePerson> persons = [];

  // for pull to refresh:
  Completer completerListViewablePerson = Completer<List<ViewablePerson>>();

  late HomeScreenViewModel viewModel;
  final ScrollController _scrollController = ScrollController();

  StreamSubscription? personsSubscriber;
  StreamSubscription? isLoadingSubscriber;

  Trigger<dynamic> loadFromStartTrigger = StreamController.broadcast();
  Trigger<dynamic> loadMoreTrigger = StreamController.broadcast();

  @override
  void initState() {
    super.initState();
    viewModel = widget.viewModel;
    outputSubject.stream.listen((event) {
      widget._outputTrigger.add(event);
    });
    bindViewModel();
  }

  @override
  void dispose() {
    personsSubscriber?.cancel();
    isLoadingSubscriber?.cancel();

    super.dispose();
  }

  Future<void> loadFromBeginning() {
    setState(() => persons = []);
    loadFromStartTrigger.add("");
    return completerListViewablePerson.future;
  }

  void bindViewModel() {
    personsSubscriber = viewModel.personsStream.listen((vals) {
      setState(() => persons.addAll(vals));

      // for pull-to-refresh function:
      if (persons.isNotEmpty) completerListViewablePerson.complete(persons);
    }, onError: (dynamic error) {
      showSnackBar(message: "Oops. $error");
    });

    isLoadingSubscriber = viewModel.isLoading.listen((val) {
      if (val) {
        // showSnackBar(message: "Loading...");
        enableLoading();
      } else {
        disableLoading();
      }
    });

    // Start the view model:
    viewModel.bindViewModel(loadFromBeginningTrigger: loadFromStartTrigger, loadMoreTrigger: loadMoreTrigger);

    // Start getting list:
    loadFromBeginning();
  }

  void loadMore() {
    if (isLoading) return;
    loadMoreTrigger.add("");
  }

  Widget footerView() {
    if (kIsWeb) {
      return TextButton(child: const Text("Load more"), onPressed: isLoading ? null : () => loadMore());
    }
    return Container();
  }

  Widget appbarActionButton({required Function refreshAction}) {
    return IconButton(onPressed: () => refreshAction(), icon: const Icon(Icons.refresh));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: defaultLinearProgressBar(context),
        title: Text('Persons (${persons.length})'),
        actions: [appbarActionButton(refreshAction: () => loadFromBeginning())],
      ),
      body: Center(
        child: persons.isEmpty
            ? const Text("No persons found")
            : NotificationListener(
                onNotification: (Notification t) {
                  if (kIsWeb) return true;

                  if (t is ScrollEndNotification) {
                    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
                      debugPrint(">>>  This is the end of the list");
                      loadMore();
                    }
                  } else if (t is ScrollUpdateNotification) {}
                  return true;
                },
                child: RefreshIndicator(
                  onRefresh: loadFromBeginning,
                  child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      controller: _scrollController,
                      itemCount: persons.length + 1,
                      itemBuilder: (BuildContext ctx, int index) {
                        if (persons.length == index) {
                          return footerView();
                        }

                        ViewablePerson person = persons[index];
                        String userAvatarUrl = person.imageUrl ?? "";

                        return ListTile(
                          onTap: () => navigateToDetails(person as Person),
                          leading: CircleAvatar(
                            foregroundImage: NetworkImage(userAvatarUrl),
                            backgroundColor: Colors.grey.shade800,
                            child: Text(
                              person.initialiserLetters,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.background,
                              ),
                            ),
                          ),
                          subtitle: Text(person.emailAddress ?? "No email"),
                          title: Text(person.name ?? "No name"),
                        );
                      }),
                ),
              ),
      ),
    );
  }

  void navigateToDetails(Person person) {
    outputSubject.add(
      HomeOutputValue(context: context, person: person, eventType: HomeOutputEvent.goToDetails),
    );
  }
}
