import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/l10n/app_localizations.dart';
import 'theme/theme_notifier.dart';
import 'todo/todo_list_screen.dart';

final ThemeNotifier themeNotifier = ThemeNotifier();

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

    // Carregar o tema apenas uma vez
    WidgetsBinding.instance.addPostFrameCallback((_) {
      themeNotifier.loadTheme();
    });

    return ListenableBuilder(
        listenable: themeNotifier,
        builder: (context, _) {
          return ListenableBuilder(
              listenable: localeNotifier,
              builder: (context, _) {
                return MaterialApp(
                  title: 'To Do',
                  theme: themeNotifier.isDarkMode ? ThemeData.dark() : ThemeData.light(),
                  locale: localeNotifier.value,
                  localizationsDelegates: AppLocalizations.localizationsDelegates,
                  supportedLocales: AppLocalizations.supportedLocales,
                  home: TodoListScreen(),
                );
              });
        });
  }
}

final localeNotifier = ValueNotifier<Locale>(const Locale('en'));

void changeLocale(Locale locale) {
  localeNotifier.value = locale;
}
