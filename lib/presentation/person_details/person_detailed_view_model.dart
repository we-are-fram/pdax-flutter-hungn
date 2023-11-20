import 'dart:async';
import 'dart:io';

import 'package:faker_api_test/data/models/person.dart';
import 'package:faker_api_test/domain/model/typealiases.dart';
import 'package:faker_api_test/presentation/bases/base_view_model.dart';
import 'package:url_launcher/url_launcher.dart';

class PersonDetailedViewModel implements BaseViewModel {
  final Person person;
  PersonDetailedViewModel({required this.person});

  void bindViewModel({
    required StreamController<String> openWebTrigger,
    required StreamController<String> phoneCallTrigger,
    required StreamController<String> sendWhatsAppTrigger,
    required StreamController<String> sendSMSTrigger,
    required StreamController<String> sendEmailTrigger,
  }) {
    _openWebTrigger = openWebTrigger;
    _phoneCallTrigger = phoneCallTrigger;
    _sendWhatsAppTrigger = sendWhatsAppTrigger;
    _sendSMSTrigger = sendSMSTrigger;
    _sendEmailTrigger = sendEmailTrigger;

    handleObservers();
  }

  // Inputs from view
  late Trigger<String> _openWebTrigger;
  late Trigger<String> _phoneCallTrigger;
  late Trigger<String> _sendWhatsAppTrigger;
  late Trigger<String> _sendSMSTrigger;
  late Trigger<String> _sendEmailTrigger;

  // Outputs to view
  final Subject<Uri> _openWebSubject = StreamController.broadcast();
  Publisher<Uri> get openWebPublisher => _openWebSubject.stream;

  final Subject<String> _phoneCallSubject = StreamController.broadcast();
  Stream<String> get phoneCallPublisher => _phoneCallSubject.stream;

  final Subject<String> _sendWhatsAppSubject = StreamController.broadcast();
  Stream<String> get sendWhatsAppPublisher => _sendWhatsAppSubject.stream;

  final Subject<String> _sendSMSSubject = StreamController.broadcast();
  Stream<String> get sendSMSPublisher => _sendSMSSubject.stream;

  final Subject<Uri> _sendEmailSubject = StreamController.broadcast();
  Stream<Uri> get sendEmailPublisher => _sendEmailSubject.stream;

  StreamController<bool> _isLoadingStream = StreamController.broadcast();
  @override
  get isLoading => _isLoadingStream.stream;

  @override
  void handleObservers() {
    _openWebTrigger.stream.listen((String event) {
      openWebBrowser(event).then((Uri launchableUrl) => _openWebSubject.add(launchableUrl));
    });

    _sendEmailTrigger.stream.listen((String event) {
      makeEmailUrlString(email: event).then((Uri launchableUrl) => _sendEmailSubject.add(launchableUrl));
    });

    _phoneCallTrigger.stream.listen((String event) {
      String phoneCallUrl = makePhoneCallUrlString(toPhoneNum: event);
      _phoneCallSubject.add(phoneCallUrl);
    });

    _sendSMSTrigger.stream.listen((String event) {
      String url = makeSmsLaunchableString(toPhoneNum: event);
      _sendSMSSubject.add(url);
    });

    _sendWhatsAppTrigger.stream.listen((String event) {
      _sendWhatsAppSubject.add(makeWhatsAppUrlString(toPhoneNum: event));
    });
  }

  Future<Uri> openWebBrowser(String? webUrl) async {
    if (webUrl?.isEmpty ?? true) {
      throw Exception('Could not launch $webUrl because it is empty!');
    }

    final Uri url = Uri.parse(webUrl!);

    if (await canLaunchUrl(url)) {
      return url;
    } else {
      throw Exception('Could not launch $webUrl');
    }
  }

  String makeSmsLaunchableString({required String? toPhoneNum}) {
    String url = "";
    if (toPhoneNum?.isEmpty ?? true) throw 'Phone is empty';

    if (Platform.isAndroid) {
      url = 'sms:$toPhoneNum?body=Hello'; // FOR Android
    } else if (Platform.isIOS) {
      url = 'sms:$toPhoneNum&body=Hello'; // FOR IOS
    }

    return url;
  }

  Future<Uri> makeEmailUrlString({required String? email}) async {
    if (email?.isEmpty ?? true) throw 'Email is empty';

    Uri params = Uri(
      scheme: 'mailto',
      path: email,
      query: 'subject=HelloI&body=Hello', //add subject and body here
    );

    if (await canLaunchUrl(params)) {
      return params;
    } else {
      throw 'Could not launch $params';
    }
  }

  String makeWhatsAppUrlString({required String? toPhoneNum}) {
    if (toPhoneNum?.isEmpty ?? true) throw 'Phone number is empty';
    return "whatsapp://send?phone=$toPhoneNum?text=Hello";
  }

  String makePhoneCallUrlString({required String? toPhoneNum}) {
    if (toPhoneNum?.isEmpty ?? true) throw 'Phone number is empty';
    return "tel://$toPhoneNum";
  }

  void enableLoading() {
    _isLoadingStream.add(true);
  }

  void disableLoading() {
    _isLoadingStream.add(false);
  }
}
