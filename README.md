# Faker API Flutter Project

A Flutter project.

## Introduction

This project is made under context of an assignment for Flutter recruitment. The project is mainly about getting data from a remote API URL and map it responded data to the app, accompanied with a simple but adequate UI.

### Structure
The project has been applied as much as possible the principles of Clean Architecture which includes these main entries:
- Data
- Domain
- Presentation
- Services

The Presentation classes, mainly classes for UI, were also split into view model and view, which adapt MVVM pattern for the best data handling and debugging.
The Data layer includes "entities" which means the raw data from API fetching. These raw things are later mapped to ready-to-use models in Data > Models.

The data flow of the app was mainly employing Stream and StreamController from pure Flutter SDK. The reason is I believe in the performance and readiness of built-in tools and APIs of Flutter for uncomplicated tasks before using any advanced and external libs such as Mobx, Provider or RxDart.

## A little bit about myself

I am a Flutter developer with a background in iOS Swift engineering. I have started to learn and use Flutter from the beginning of 2019. Some of the theories of iOS programming have been brought to my practices of Flutter.

## How to run the app

Just being straightforward, in the cloned folder of this project, run `flutter pub get` to make sure all libs updated, then:
- open the project in Android Studio (yes, the Studio can later trigger iOS Simulator if Flutter plugin is installed), 
- plug in a device or use a simulator/emulator, 
- press Start button on the toolbar. 

Then, the project should be built and run on the plugged device. 

### Need to run for web?
Just very simple, in the project's directory, run the command `flutter run -d chrome` and then the project should be built and run Chrome. 

The project cannot be built for web? It is time not only to check if you've installed Chrome or any Chromium browser but also to check with `flutter doctor` to make sure your Flutter are in the right branch with web support.

## Limitation(s)

Sorry, I cannot bring any suitable implementation of `unit testing` in this project, this is the domain which still has a big room for me to improve. Since I know well that the basement is to make class with its interface for facilitating unit testing (and also dependency injection) that the Clean Architecture has covered a lot, I still need more time to get my hands dirty with this domain. 
