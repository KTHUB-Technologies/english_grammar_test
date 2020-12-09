import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FlutterLocalizations {
  final Locale locale;
  Map<String, dynamic> _localizedStrings;
  Map<String, dynamic> jsonMap;
  final bool isTest;

  FlutterLocalizations(this.locale, {this.isTest = false});

  static FlutterLocalizations of(BuildContext context) {
    return Localizations.of<FlutterLocalizations>(
        context, FlutterLocalizations);
  }

  Future<FlutterLocalizations> loadTest(Locale locale) async {
    return FlutterLocalizations(locale);
  }

  Future<FlutterLocalizations> load2() async {
    String jsonString = await rootBundle.loadString('lib/res/strings/${locale.languageCode}.json');
     jsonMap = json.decode(jsonString);

    _localizedStrings = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });
    return FlutterLocalizations(locale);
  }

  String translate(String key) {
    return _localizedStrings[key];
  }

  String getString(BuildContext context, String key) {
    return _localizedStrings[key];
  }

  List<dynamic> getList(BuildContext context, String key) {
    return jsonMap[key];
  }
}
String buildTranslate(BuildContext context, String key) =>
    FlutterLocalizations.of(context).translate(key);
