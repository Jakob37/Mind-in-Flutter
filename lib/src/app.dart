import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mind_flutter/src/database.dart';
import 'package:mind_flutter/src/views/store_view.dart';
import 'package:mind_flutter/src/views/tab_view.dart';

import 'views/entry_view.dart';
import 'views/entries_view.dart';
import 'settings/settings_controller.dart';
import 'settings/settings_view.dart';

/// The Widget that configures your application.
class MindApp extends StatelessWidget {
  final Database db;
  final SettingsController settingsController;

  const MindApp({
    super.key,
    required this.db,
    required this.settingsController,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: settingsController,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          restorationScopeId: 'app',
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''),
          ],
          onGenerateTitle: (BuildContext context) =>
              AppLocalizations.of(context)!.appTitle,
          theme: ThemeData(
              scaffoldBackgroundColor: const Color(0xFF003366),
              appBarTheme: const AppBarTheme(color: Color(0xFF003366))),
          darkTheme: ThemeData.dark().copyWith(
              scaffoldBackgroundColor: const Color(0xFF003366),
              appBarTheme: const AppBarTheme(color: Color(0xFF003366))),
          themeMode: settingsController.themeMode,
          onGenerateRoute: (RouteSettings routeSettings) {
            return MaterialPageRoute<void>(
              settings: routeSettings,
              builder: (BuildContext context) {
                switch (routeSettings.name) {
                  case SettingsView.routeName:
                    return SettingsView(controller: settingsController);
                  case EntryView.routeName:
                    return const EntryView();
                  case StoreView.routeName:
                    return const StoreView();
                  case EntriesView.routeName:
                  default:
                    return appTabsView(db);
                  // return const SampleItemListView();
                }
              },
            );
          },
        );
      },
    );
  }
}
