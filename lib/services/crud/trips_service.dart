import 'dart:async';
import 'dart:ffi';

import 'package:flutter/material.dart' show immutable;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tripplanner/services/crud/crud_exceptions.dart';

class TripsService {
  Database? _db;
  List<DatabaseTrip> _trips = [];
  //List<DatabaseCosts> _costs = [];
  //List<DatabaseRequirements> _requirements = [];

  late final StreamController<List<DatabaseTrip>> _tripsStreamController;

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

  Future<Iterable<DatabaseTrip>> getAllTrips() async {
    await _ensureDbIsOpen();
    final db = getDatabase();
    final trips = await db.query(
      tripsTableName,
    );
    return trips.map((tripRow) => DatabaseTrip.fromRow(tripRow));
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
      case 'costs':
        updatedTrip.costs = value;
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
  List<String> costs;
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

  DatabaseTrip.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        name = map[nameColumn] as String,
        destination = map[destinationColumn] as String,
        date = map[dateColumn] as String,
        note = map[noteColumn] as String,
        costs = [],
        requirements = [];

  @override
  bool operator ==(covariant DatabaseTrip other) => name == other.name;

  @override
  int get hashCode => name.hashCode;
}

@immutable
class DatabaseCosts {
  final int id;
  final String activity;
  final Float planned;
  final Float real;
  final int tripsFk;

  const DatabaseCosts({
    required this.id,
    required this.activity,
    required this.planned,
    required this.real,
    required this.tripsFk,
  });

  DatabaseCosts.fromRow(Map<String, Object> map)
      : id = map[idColumn] as int,
        activity = map[activityNameColumn] as String,
        planned = map[plannedColumn] as Float,
        real = map[realColumn] as Float,
        tripsFk = map[tripsFkColumn] as int;
}

@immutable
class DatabaseRequirements {
  final int id;
  final String name;
  final bool isDone;
  final int tripsFk;

  const DatabaseRequirements({
    required this.id,
    required this.name,
    required this.isDone,
    required this.tripsFk,
  });

  DatabaseRequirements.fromRow(Map<String, Object> map)
      : id = map[idColumn] as int,
        name = map[nameColumn] as String,
        isDone = (map[isDoneColumn] as int) == 1 ? true : false,
        tripsFk = map[tripsFkColumn] as int;
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
const tripsFkColumn = 'trips_fk';
const activityNameColumn = 'activity';

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
	"planned"	NUMERIC,
	"real"	NUMERIC,
	"trip_fk"	INTEGER NOT NULL,
	PRIMARY KEY("id" AUTOINCREMENT)
);
''';

const createRequirementsTable = '''CREATE TABLE IF NOT EXISTS  "requirements" (
	"id"	INTEGER NOT NULL UNIQUE,
	"name"	TEXT NOT NULL,
	"is_done"	INTEGER NOT NULL DEFAULT 0,
	"trips_fk"	INTEGER NOT NULL,
	PRIMARY KEY("id" AUTOINCREMENT)
);
''';
