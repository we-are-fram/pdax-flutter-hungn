import 'dart:async';

import 'package:flutter/material.dart';

abstract class BaseState<T extends StatefulWidget> extends State<T> {
  bool _isLoading = false;
  StreamController<bool> showLoadingHudStream = StreamController.broadcast();
  double defaultPadding = 16.0;

  bool get isLoading {
    return _isLoading;
  }

  void setIsLoading({required bool isLoading}) {
    setState(() => _isLoading = isLoading);
  }

  void enableLoading() {
    setState(() => _isLoading = true);
  }

  void disableLoading() {
    setState(() => _isLoading = false);
  }

  void showAlertView({required String title, required String body, List<Widget> actions = const []}) => showDialog(
        context: context,
        builder: (BuildContext ctx) => AlertDialog(title: Text(title), content: Text(body), actions: actions),
      );

  PreferredSize? defaultLinearProgressBar(BuildContext context) {
    return _isLoading
        ? PreferredSize(
            preferredSize: const Size.fromHeight(6.0),
            child: LinearProgressIndicator(
              backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.3),
              valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.primary),
            ),
          )
        : null;
  }

  void showError(dynamic e) {
    showAlertView(
        title: "Error",
        body: "Unexpected error: \"${e.toString()}\"",
        actions: [TextButton(onPressed: Navigator.of(context).pop, child: Text("OK"))]);
  }

  void showSnackBar({required dynamic message, IconData? iconData}) {
    SnackBar snackBar = SnackBar(showCloseIcon: true, content: Text(message.toString()));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showLoadingIndicatorHud([String? text]) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
            backgroundColor: Colors.black87,
            content: LoadingIndicator(text: text ?? ""),
          ),
        );
      },
    );
  }

  void hideLoadingIndicatorHud() {
    Navigator.of(context).pop();
  }
}

class LoadingIndicator extends StatelessWidget {
  LoadingIndicator({this.text = ''});

  final String text;

  @override
  Widget build(BuildContext context) {
    var displayedText = text;

    return Container(
        padding: EdgeInsets.all(16),
        color: Colors.black87,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [_getLoadingIndicator(), _getHeading(context), _getText(displayedText)]));
  }

  Padding _getLoadingIndicator() {
    return Padding(
        child: Container(child: CircularProgressIndicator(strokeWidth: 3), width: 32, height: 32),
        padding: EdgeInsets.only(bottom: 16));
  }

  Widget _getHeading(context) {
    return const Padding(
        child: Text(
          'Please wait …',
          style: TextStyle(color: Colors.white, fontSize: 16),
          textAlign: TextAlign.center,
        ),
        padding: EdgeInsets.only(bottom: 4));
  }

  Text _getText(String displayedText) {
    return Text(
      displayedText,
      style: TextStyle(color: Colors.white, fontSize: 14),
      textAlign: TextAlign.center,
    );
  }
}
