import 'package:flutter/material.dart';
import 'package:tripplanner/const/routes.dart';
import 'package:tripplanner/services/crud/trips_service.dart';
import 'package:tripplanner/utilities/get_argument.dart';

typedef TripUpdateCallback = void Function()?;

class CreateUpdateTripView extends StatefulWidget {
  const CreateUpdateTripView({super.key});

  @override
  State<CreateUpdateTripView> createState() => _CreateUpdateTripViewState();
}

class _CreateUpdateTripViewState extends State<CreateUpdateTripView> {
  DatabaseTrip? _trip;

  late final TextEditingController _nameTextController;
  late final TextEditingController _destinationTextController;
  late final TextEditingController _dateTextController;
  late final TextEditingController _noteTextController;
  late final TripsService _tripsService;

  _CreateUpdateTripViewState();

  @override
  void initState() {
    _tripsService = TripsService();
    _nameTextController = TextEditingController();
    _destinationTextController = TextEditingController();
    _dateTextController = TextEditingController();
    _noteTextController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _nameTextController.dispose();
    _destinationTextController.dispose();
    _dateTextController.dispose();
    _noteTextController.dispose();
    super.dispose();
  }

  void _textControllerListener(String text, String fieldName) async {
    final trip = _trip;

    await _tripsService.updateTrip(
      trip!.id,
      fieldName,
      text,
    );
  }

  void _setupTextControllerListener() {
    _nameTextController.addListener(
      () => _textControllerListener(
        _nameTextController.text,
        'name',
      ),
    );

    _destinationTextController.addListener(
      () => _textControllerListener(
        _destinationTextController.text,
        'destination',
      ),
    );

    _dateTextController.addListener(
      () => _textControllerListener(
        _dateTextController.text,
        'date',
      ),
    );

    _noteTextController.addListener(
      () => _textControllerListener(
        _noteTextController.text,
        'note',
      ),
    );
  }

  Future<void> getOrCreateTrip(BuildContext context) async {
    final widgetTrip = context.getArgument<DatabaseTrip>();
    _trip = widgetTrip;

    if (widgetTrip != null) {
      _dateTextController.text = widgetTrip.date;
      _destinationTextController.text = widgetTrip.destination;
      _nameTextController.text = widgetTrip.name;
      _noteTextController.text = widgetTrip.note;
    } else {
      _trip = await _tripsService.addTrip();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your trip')),
      body: FutureBuilder(
        future: getOrCreateTrip(context),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              _setupTextControllerListener();
              return Column(
                children: [
                  TextField(
                    controller: _nameTextController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: const InputDecoration(
                      hintText: 'Name of a trip',
                      helperText: 'Name of your trip',
                    ),
                  ),
                  TextField(
                    controller: _destinationTextController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: const InputDecoration(
                      hintText: 'Trip destination',
                      helperText: 'Destination of your trip',
                    ),
                  ),
                  TextField(
                    controller: _dateTextController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: const InputDecoration(
                      hintText: 'Trip date',
                      helperText: 'Date of your trip',
                    ),
                  ),
                  TextField(
                    controller: _noteTextController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: const InputDecoration(
                      hintText: 'My notes',
                      helperText: 'Your notes',
                    ),
                  ),
                  TextField(
                    decoration: const InputDecoration(
                      hintText: 'Trip costs [.....]',
                      helperText: 'Cost of your trip',
                    ),
                    readOnly: true,
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        tripCostRoute,
                        arguments: _trip,
                      );
                    },
                  ),
                  TextField(
                    decoration: const InputDecoration(
                      hintText: 'Trip requirements [.....]',
                      helperText: 'Requirements before your trip',
                    ),
                    readOnly: true,
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        tripRequirementsRoute,
                        arguments: _trip,
                      );
                    },
                  ),
                ],
              );
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
