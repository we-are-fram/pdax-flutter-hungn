import 'package:faker_api_test/domain/usecases/get_persons_usecase.dart';
import 'package:faker_api_test/presentation/home/home_coordinator.dart';
import 'package:faker_api_test/presentation/home/home_view.dart';
import 'package:faker_api_test/repositories/persons_respository/persons_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late HomeCoordinator homeCoordinator;
  ThemeData lightTheme = ThemeData(
    textTheme: GoogleFonts.latoTextTheme(),
    useMaterial3: true,
  );

  @override
  void initState() {
    super.initState();
    prepareDependencyInjection();
    homeCoordinator = HomeCoordinator();
  }

  void prepareDependencyInjection() {
    GetIt.instance.registerSingleton<PersonRepositoryInterface>(PersonsRepository());
    GetIt.instance.registerSingleton<GetPersonsUseCaseInterface>(GetPersonUseCase());

    // GetIt.instance.registerFactory<GetPersonsUseCaseInterface>(() => GetPersonUseCase());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: lightTheme,
      home: homeCoordinator.getActivePage(),
    );
  }
}
