import 'dart:async';

import 'package:flutter/material.dart' show immutable;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tripplanner/services/crud/crud_exceptions.dart';

class TripsService {
  Database? _db;
  List<DatabaseTrip> _trips = [];
  //List<DatabaseRequirements> _requirements = [];
  late final StreamController<List<DatabaseTrip>> _tripsStreamController;
  late final StreamController<List<DatabaseCost>> _costsStreamController;
  // singleton
  factory TripsService() => _instance;
  static final TripsService _instance = TripsService._internal();
  TripsService._internal() {
    _tripsStreamController = StreamController<List<DatabaseTrip>>.broadcast(
      onListen: () {
        _tripsStreamController.sink.add(_trips);
      },
    );
  }

  Stream<List<DatabaseTrip>> get allTrips => _tripsStreamController.stream;

  Stream<List<DatabaseCost>> get allCosts => _costsStreamController.stream;

  Future<Iterable<DatabaseTrip>> getAllTrips() async {
    await _ensureDbIsOpen();
    final db = getDatabase();
    final trips = await db.query(
      tripsTableName,
    );
    final costs = await db.query(
      costsTableName,
    );

    return trips.map((tripRow) => DatabaseTrip.fromRow(tripRow,
        costs.where((cost) => tripRow['id'] == cost['trip_id']).toList()));
  }

  Future<DatabaseTrip> addTrip() async {
    await _ensureDbIsOpen();
    final db = getDatabase();
    DatabaseTrip newTrip = DatabaseTrip(
        id: DateTime.now().microsecondsSinceEpoch,
        name: '',
        destination: '',
        date: '',
        note: '',
        costs: [],
        requirements: []);

    await db.insert(tripsTableName, {
      idColumn: newTrip.id,
      nameColumn: newTrip.name,
      destinationColumn: newTrip.destination,
      dateColumn: newTrip.date,
      noteColumn: newTrip.note
    });

    _trips.add(newTrip);
    _tripsStreamController.add(_trips);

    return newTrip;
  }

  Future<void> updateTrip(int id, String field, value) async {
    await _ensureDbIsOpen();
    final db = getDatabase();
    await db.update(
      tripsTableName,
      {field: value},
      where: 'id = ?',
      whereArgs: [id],
    );
    final updatedTrip = _trips.singleWhere((element) => element.id == id);
    switch (field) {
      case 'name':
        updatedTrip.name = value;
        break;
      case 'destination':
        updatedTrip.destination = value;
        break;
      case 'requirements':
        updatedTrip.requirements = value;
        break;
      case 'date':
        updatedTrip.date = value;
        break;
      case 'note':
        updatedTrip.note = value;
        break;
    }
    _tripsStreamController.add(_trips);
  }

  Future<void> deleteTrip(DatabaseTrip trip) async {
    await _ensureDbIsOpen();
    final db = getDatabase();
    await db.delete(
      tripsTableName,
      where: 'id = ?',
      whereArgs: [trip.id],
    );
    _trips.remove(trip);
    _tripsStreamController.add(_trips);
  }

  Future<void> cacheTrips() async {
    final trips = await getAllTrips();
    _trips = trips.toList();
    _tripsStreamController.add(_trips);
  }

  Future<DatabaseCost> addCost(int tripId) async {
    await _ensureDbIsOpen();
    final db = getDatabase();

    DatabaseCost newCost = DatabaseCost(
        id: DateTime.now().microsecondsSinceEpoch,
        activity: '',
        planned: double.nan,
        real: double.nan,
        tripID: tripId);
    await db.insert(costsTableName, {
      idColumn: newCost.id,
      activityNameColumn: newCost.activity,
      plannedColumn: newCost.planned,
      realColumn: newCost.real,
      tripIdColumn: newCost.tripID
    });

    _trips.singleWhere((element) => element.id == tripId).costs.add(newCost);
    _tripsStreamController.add(_trips);
    return newCost;
  }

  Future<void> updateCost(DatabaseCost cost, String field, value) async {
    await _ensureDbIsOpen();
    final db = getDatabase();
    await db.update(
      costsTableName,
      {field: value},
      where: 'id = ?',
      whereArgs: [cost.id],
    );

    final updatedCosts =
        _trips.singleWhere((trip) => trip.id == cost.tripID).costs;
    final updatedCost =
        updatedCosts.singleWhere((oldCost) => oldCost.id == cost.id);
    switch (field) {
      case 'activity':
        updatedCost.activity = value;
        break;
      case 'planned':
        final parsedDouble = double.tryParse(value) ?? double.nan;

        updatedCost.planned = parsedDouble;
        break;
      case 'real':
        final parsedDouble = double.tryParse(value) ?? double.nan;

        updatedCost.real = parsedDouble;
        break;
    }

    // print('apdejt');
    // updatedCosts.forEach((element) {
    //   print(element.activity);
    // });
    _tripsStreamController.add(_trips);
    //await cacheTrips();
  }

  Future<void> deleteCost(DatabaseCost cost) async {
    await _ensureDbIsOpen();
    final db = getDatabase();
    await db.delete(
      costsTableName,
      where: 'id = ?',
      whereArgs: [cost.id],
    );
    _trips
        .where((element) => element.id == cost.tripID)
        .first
        .costs
        .remove(cost);
    _tripsStreamController.add(_trips);
  }

  Future<void> openDb() async {
    //await _db!.query('DROP TABLE IF EXISTS trips');
    if (_db == null) {
      try {
        final appDocsPath = await getApplicationDocumentsDirectory();
        final dbPath = join(appDocsPath.path, dbName);
        final db = await openDatabase(dbPath);
        _db = db;
        await db.execute(createCostsTable);
        await db.execute(createRequirementsTable);
        await db.execute(createTripsTable);
      } on MissingPlatformDirectoryException {
        throw UnableToGetDocumentsDirectory();
      }
    }

    await cacheTrips();
  }

  Future<void> closeDb() async {
    final db = _db;
    if (db == null) {
      throw DatabaseNotOpenException();
    } else {
      await db.close();
      _db = null;
    }
  }

  Future<void> _ensureDbIsOpen() async {
    final db = _db;
    if (db == null) {
      await openDb();
    }
  }

  Database getDatabase() {
    final db = _db;
    if (db == null) {
      throw DatabaseNotFoundException;
    }
    return db;
  }
}

class DatabaseTrip {
  int id;
  String name;
  String destination;
  List<DatabaseCost> costs;
  List<String> requirements;
  String date;
  String note;

  DatabaseTrip({
    required this.id,
    required this.name,
    required this.destination,
    required this.date,
    required this.note,
    required this.costs,
    required this.requirements,
  });

  DatabaseTrip.fromRow(
      Map<String, Object?> map, List<Map<String, Object?>> costs)
      : id = map[idColumn] as int,
        name = map[nameColumn] as String,
        destination = map[destinationColumn] as String,
        date = map[dateColumn] as String,
        note = map[noteColumn] as String,
        costs = costs
            .map((e) => DatabaseCost(
                  id: e[idColumn] as int,
                  activity: e[activityNameColumn] as String,
                  planned: (double.tryParse(e[plannedColumn].toString()) ??
                      double.nan),
                  real:
                      (double.tryParse(e[realColumn].toString()) ?? double.nan),
                  tripID: e[tripIdColumn] as int,
                ))
            .toList(),
        requirements = [];

  @override
  bool operator ==(covariant DatabaseTrip other) => name == other.name;

  @override
  int get hashCode => name.hashCode;
}

class DatabaseCost {
  final int id;
  String activity;
  double planned;
  double real;
  int tripID;

  DatabaseCost({
    required this.id,
    required this.activity,
    required this.planned,
    required this.real,
    required this.tripID,
  });
}

@immutable
class DatabaseRequirements {
  final int id;
  final String name;
  final bool isDone;
  final int tripFk;

  const DatabaseRequirements({
    required this.id,
    required this.name,
    required this.isDone,
    required this.tripFk,
  });

  DatabaseRequirements.fromRow(Map<String, Object> map)
      : id = map[idColumn] as int,
        name = map[nameColumn] as String,
        isDone = (map[isDoneColumn] as int) == 1 ? true : false,
        tripFk = map[tripIdColumn] as int;
}

const idColumn = "id";
const nameColumn = "name";
const isDoneColumn = "is_done";
const plannedColumn = "planned";
const realColumn = "real";
const tripsTableName = "trips";
const dbName = 'trips.db';
const destinationColumn = 'destination';
const dateColumn = 'date';
const noteColumn = 'note';
const tripIdColumn = 'trip_id';
const activityNameColumn = 'activity';
const costsTableName = 'costs';
//sqlite create tables
const createTripsTable = ''' CREATE TABLE IF NOT EXISTS "trips" (
	"id"	INTEGER NOT NULL UNIQUE,
	"name"	TEXT NOT NULL,
	"destination"	TEXT,
	"date"	TEXT,
	"note"	TEXT,
	PRIMARY KEY("id" AUTOINCREMENT)
);
''';
const createCostsTable = ''' CREATE TABLE IF NOT EXISTS "costs" (
	"id"	INTEGER NOT NULL UNIQUE,
  "activity"	TEXT,
	"planned"	TEXT,
	"real"	TEXT,
	"trip_id"	INTEGER NOT NULL,
	PRIMARY KEY("id" AUTOINCREMENT)
);
''';

const createRequirementsTable = '''CREATE TABLE IF NOT EXISTS  "requirements" (
	"id"	INTEGER NOT NULL UNIQUE,
	"name"	TEXT NOT NULL,
	"is_done"	INTEGER NOT NULL DEFAULT 0,
	"trip_id"	INTEGER NOT NULL,
	PRIMARY KEY("id" AUTOINCREMENT)
);
''';
