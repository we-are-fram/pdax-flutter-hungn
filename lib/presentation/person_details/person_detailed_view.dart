import 'dart:async';

import 'package:faker_api_test/data/models/person.dart';
import 'package:faker_api_test/domain/model/typealiases.dart';
import 'package:faker_api_test/presentation/bases/base_state.dart';
import 'package:faker_api_test/presentation/person_details/person_detailed_view_model.dart';
import 'package:faker_api_test/utils/theme_constant.dart';
import 'package:faker_api_test/utils/time_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class PersonDetailedPage extends StatefulWidget {
  final Person viewablePerson;
  final PersonDetailedViewModel viewModel;
  PersonDetailedPage({super.key, required this.viewablePerson, required this.viewModel});

  @override
  State<PersonDetailedPage> createState() => _PersonDetailedPageState();
}

class _PersonDetailedPageState extends BaseState<PersonDetailedPage> {
  @override
  void initState() {
    super.initState();
    bindViewModel();
  }

  Trigger<String> openWebTrigger = StreamController.broadcast();
  Trigger<String> phoneCallTrigger = StreamController.broadcast();
  Trigger<String> sendWhatsAppTrigger = StreamController.broadcast();
  Trigger<String> sendSMSTrigger = StreamController.broadcast();
  Trigger<String> sendEmailTrigger = StreamController.broadcast();

  void bindViewModel() {
    widget.viewModel.bindViewModel(
        openWebTrigger: openWebTrigger,
        phoneCallTrigger: phoneCallTrigger,
        sendWhatsAppTrigger: sendWhatsAppTrigger,
        sendSMSTrigger: sendSMSTrigger,
        sendEmailTrigger: sendEmailTrigger);

    widget.viewModel.openWebPublisher.listen((Uri webUri) => onLaunchUri(webUri));
    widget.viewModel.sendEmailPublisher.listen((Uri emailUri) => onLaunchUri(emailUri));

    widget.viewModel.phoneCallPublisher.listen((String url) => onLaunchUrlString(url));
    widget.viewModel.sendWhatsAppPublisher.listen((String url) => onLaunchUrlString(url));
    widget.viewModel.sendSMSPublisher.listen((String url) => onLaunchUrlString(url));
  }

  Widget InfoTile({
    required String title,
    required String? subtitle,
    List<Widget> trailingWidgets = const [],
  }) {
    return Container(
      padding: ThemeConstant.padding16(horizontal: false, vertical: true),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700)),
                ThemeConstant.sizedBox8,
                Text(subtitle ?? "N/A", style: Theme.of(context).textTheme.bodyLarge),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: trailingWidgets,
          )
        ],
      ),
    );
  }

  void copyToClipboard(String? text) async {
    if (text == null) return;
    await Clipboard.setData(ClipboardData(text: text));
    showSnackBar(message: "Copied!");
  }

  @override
  Widget build(BuildContext context) {
    Person person = widget.viewablePerson;
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        padding: ThemeConstant.padding16(),
        children: [
          SizedBox(height: 100),
          Text("Get in touch\nwith ${person.name}",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
          ThemeConstant.sizedBox16,
          InfoTile(title: "Person ID", subtitle: "#${person.id}"),
          InfoTile(
            title: "Full name",
            subtitle: person.name,
            trailingWidgets: [
              IconButton(onPressed: () => copyToClipboard(person.name), icon: const Icon(Icons.copy)),
            ],
          ),
          InfoTile(
            title: "Email address",
            subtitle: person.email,
            trailingWidgets: [
              IconButton(onPressed: () => sendEmail(email: person.email), icon: const Icon(Icons.email_outlined)),
              IconButton(onPressed: () => copyToClipboard(person.email), icon: const Icon(Icons.copy)),
            ],
          ),
          InfoTile(title: "Address", subtitle: person.address?.readableAddress),
          InfoTile(
            title: "Phone number",
            subtitle: person.phone,
            trailingWidgets: [
              IconButton(
                  onPressed: () => showContactBottomSheet(
                        context: context,
                        makeCall: () => makePhoneCall(toPhoneNum: person.phone),
                        sendWhatsApp: () => sendWhatsApp(toPhoneNum: person.phone),
                        sendSMS: () => sendSMSMessage(toPhoneNum: person.phone),
                      ),
                  icon: const Icon(Icons.share)),
            ],
          ),
          InfoTile(title: "DOB", subtitle: TimeStringUtil.makeDateStringWithCurrentLocale(person.birthday)),
          InfoTile(
            title: "Website",
            subtitle: person.website,
            trailingWidgets: [
              IconButton(onPressed: () => openWebBrowser(person.website), icon: const Icon(Icons.open_in_new)),
              IconButton(onPressed: () => copyToClipboard(person.website), icon: const Icon(Icons.copy)),
            ],
          )
        ],
      ),
    );
  }

  void showContactBottomSheet({
    required BuildContext context,
    required Function makeCall,
    required Function sendSMS,
    required Function sendWhatsApp,
  }) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          width: MediaQuery.of(context).size.width,
          padding: ThemeConstant.padding16(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ThemeConstant.sizedBox16,
              Text('What would you like to do?',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
              ThemeConstant.sizedBox16,
              ElevatedButton.icon(
                icon: Icon(Icons.phone),
                label: const Text('Make phone call'),
                onPressed: () => makeCall(),
              ),
              ElevatedButton.icon(
                icon: Icon(Icons.message),
                label: const Text('Send SMS'),
                onPressed: () => sendSMS(),
              ),
              ElevatedButton.icon(
                label: const Text('Send WhatsApp message'),
                onPressed: () => sendWhatsApp(),
                icon: Icon(Icons.message),
              ),
              ThemeConstant.sizedBox16,
              TextButton(
                child: const Text('Cancel'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }

  onLaunchUri(Uri uri) async {
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $uri';
    }
  }

  onLaunchUrlString(String url) async {
    if (url.isEmpty) return;
    await launchUrlString(url);
  }

  openWebBrowser(String? webUrl) async {
    if (webUrl?.isEmpty ?? true) return;
    openWebTrigger.add(webUrl!);
  }

  sendSMSMessage({required String? toPhoneNum}) async {
    if (toPhoneNum?.isEmpty ?? true) return;
    sendSMSTrigger.add(toPhoneNum!);
  }

  sendEmail({required String? email}) async {
    if (email?.isEmpty ?? true) return;
    sendEmailTrigger.add(email!);
  }

  sendWhatsApp({required String? toPhoneNum}) async {
    if (toPhoneNum?.isEmpty ?? true) return;
    sendWhatsAppTrigger.add(toPhoneNum!);
  }

  makePhoneCall({required String? toPhoneNum}) async {
    if (toPhoneNum?.isEmpty ?? true) return;
    phoneCallTrigger.add(toPhoneNum!);
  }
}
