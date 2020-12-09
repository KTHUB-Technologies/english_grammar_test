import 'dart:async';

import 'package:flutter/material.dart';
import 'package:the_enest_english_grammar_test/localization/flutter_localizations.dart';


class FlutterLocalizationsDelegate extends LocalizationsDelegate<FlutterLocalizations> {

  static List<Locale> get supportedLocales =>
      [const Locale('vi', 'VN'),const Locale('en', 'US'), ];

  final bool isTest;

  const FlutterLocalizationsDelegate({
    this.isTest = false,
  });
  @override
  bool isSupported(Locale locale) {
    return ['en', 'vi', 'ps'].contains(locale.languageCode);
  }


  @override
  Future<FlutterLocalizations> load(Locale locale) async {
    FlutterLocalizations localizations = new FlutterLocalizations(locale);
    await localizations.load2();
    return localizations;
  }

  @override
  bool shouldReload(LocalizationsDelegate<FlutterLocalizations> old) {
    return false;
  }
}
