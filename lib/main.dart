import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Importe as traduções geradas
import 'todo_list_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) {
      final String defaultLocale = Platform.localeName; // Returns locale string in the form 'en_US'
      log(defaultLocale, name: 'defaultLocale');
      changeLocale(Locale(defaultLocale.split('_').first));
    }
    return ListenableBuilder(
        listenable: localeNotifier,
        builder: (context, _) {
          return MaterialApp(
            title: 'To Do',
            locale: localeNotifier.value,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: TodoListScreen(),
          );
        });
  }
}

final localeNotifier = ValueNotifier<Locale>(const Locale('en'));

void changeLocale(Locale locale) {
  localeNotifier.value = locale;
}
