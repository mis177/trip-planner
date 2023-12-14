import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tripplanner/bloc/language/language_bloc.dart';
import 'package:tripplanner/bloc/language/language_state.dart';
import 'package:tripplanner/const/routes.dart';
import 'package:tripplanner/utilities/theme.dart';
import 'package:tripplanner/views/trips/trip_edit_view.dart';
import 'package:tripplanner/views/trips/trip_cost_view.dart';
import 'package:tripplanner/views/trips/trip_requirements_view.dart';
import 'package:tripplanner/views/trips/trips_list_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  runApp(
    BlocProvider(
      create: (context) => LanguageBloc(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageBloc, LanguageState>(builder: (context, state) {
      return MaterialApp(
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        locale: Locale(state.localeName),
        theme: appTheme,
        home: const HomePage(),
        routes: {
          tripEditRoute: (context) => const TripView(),
          tripCostRoute: (context) => const CostsView(),
          tripRequirementsRoute: (context) => const RequirementsView(),
        },
      );
    });
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const TripsView();
  }
}
