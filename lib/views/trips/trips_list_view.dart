import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tripplanner/bloc/language/language_bloc.dart';
import 'package:tripplanner/bloc/language/language_event.dart';
import 'package:tripplanner/bloc/trip_list/trip_list_service.dart';
import 'package:tripplanner/bloc/trip_list/trip_list_bloc.dart';
import 'package:tripplanner/bloc/trip_list/trip_list_event.dart';
import 'package:tripplanner/bloc/trip_list/trip_list_state.dart';
import 'package:tripplanner/extensions/buildcontext/loc.dart';
import 'package:tripplanner/utilities/dialogs/confirmation_dialog.dart';
import 'package:tripplanner/utilities/dialogs/error_dialog.dart';
import 'package:tripplanner/utilities/loading_screen/loading_screen.dart';

enum LanguageMenu { polish, english }

class TripsView extends StatefulWidget {
  const TripsView({super.key});

  @override
  State<TripsView> createState() => _TripsViewState();
}

class _TripsViewState extends State<TripsView> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TripListBloc(
        TripListService(),
      ),
      child: const TripsListView(),
    );
  }
}

class TripsListView extends StatefulWidget {
  const TripsListView({super.key});

  @override
  State<TripsListView> createState() => _TripsListViewState();
}

class _TripsListViewState extends State<TripsListView> {
  void showSnackBar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        duration: const Duration(milliseconds: 400),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.loc.trips_list_title,
        ),
        titleTextStyle: Theme.of(context).textTheme.titleLarge,
        actions: [
          PopupMenuButton<LanguageMenu>(
            icon: const Icon(Icons.settings),
            onSelected: (value) async {
              switch (value) {
                case LanguageMenu.polish:
                  BlocProvider.of<LanguageBloc>(context)
                      .add(const ChangeLanguage(localeName: 'pl'));

                  break;
                case LanguageMenu.english:
                  BlocProvider.of<LanguageBloc>(context)
                      .add(const ChangeLanguage(localeName: 'en'));
                  break;
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<LanguageMenu>(
                    value: LanguageMenu.polish,
                    child: Text(context.loc.trip_lang_pl)),
                PopupMenuItem<LanguageMenu>(
                    value: LanguageMenu.english,
                    child: Text(context.loc.trip_lang_en))
              ];
            },
          ),
        ],
      ),
      body: BlocConsumer<TripListBloc, TripListState>(
        listener: (context, state) async {
          if (state is TripListAdded) {
            if (state.exception == null) {
              Navigator.of(context)
                  .pushNamed(
                    state.route,
                    arguments: state.trip,
                  )
                  .then((value) => context.read<TripListBloc>().add(
                        const TripListLoadAll(),
                      ));
            } else {
              await showErrorDialog(
                  context: context,
                  content: context.loc.trip_list_error_load_trips);
            }
          } else if (state is TripListClicked) {
            if (state.exception == null) {
              Navigator.of(context)
                  .pushNamed(
                    state.route,
                    arguments: state.trip,
                  )
                  .then((value) => context.read<TripListBloc>().add(
                        const TripListLoadAll(),
                      ));
            } else {
              await showErrorDialog(
                  context: context,
                  content: context.loc.trip_list_error_load_list);
            }
          } else if (state is TripListRemoved) {
            if (state.exception == null) {
              showSnackBar(context.loc.trips_list_removed);
            } else {
              await showErrorDialog(
                  context: context,
                  content: context.loc.trip_list_error_remove);
            }
          }
          if (state is TripListAddInProgress) {
            if (context.mounted) {
              LoadingScreen().show(
                  context: context, text: context.loc.trips_list_creating);
            }
          } else if (state is TripListRemoveInProgress) {
            if (context.mounted) {
              LoadingScreen().show(
                  context: context, text: context.loc.trips_list_deleting);
            }
          } else if (state is TripListRemoveInProgress) {
            if (context.mounted) {
              LoadingScreen()
                  .show(context: context, text: context.loc.trips_list_loading);
            }
          } else {
            LoadingScreen().hide();
          }
        },
        builder: (context, state) {
          if (state is TripListInitial) {
            context.read<TripListBloc>().add(
                  const TripListLoadAll(),
                );
          }

          return ListView.builder(
            itemCount: state.allTrips.length,
            itemBuilder: (context, index) {
              final trip = state.allTrips.elementAt(index);
              return Card(
                  child: ListTile(
                leading: const Icon(Icons.place_outlined),
                title: Text(
                  trip.name,
                  maxLines: 1,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    final shouldDelete = await showConfirmationDialog(
                      context: context,
                      title: context.loc.trips_list_dialog_title,
                      content: context.loc.trips_list_dialog_content,
                    );
                    if (mounted) {
                      context.read<TripListBloc>().add(
                            TripListRemove(
                              trip: trip,
                              shouldDelete: shouldDelete,
                            ),
                          );
                    }
                  },
                ),
                onTap: () {
                  context.read<TripListBloc>().add(
                        TripListTripClick(trip: trip),
                      );
                },
              ));
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          context.read<TripListBloc>().add(const TripListAdd());
        },
      ),
    );
  }
}
