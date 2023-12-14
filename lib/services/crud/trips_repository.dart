import 'dart:async';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tripplanner/models/trips.dart';
import 'package:tripplanner/services/crud/crud_exceptions.dart';

class TripsRepository {
  Database? _db;
  List<DatabaseTrip> _trips = [];
  late final StreamController<List<DatabaseTrip>> _tripsStreamController;
  // singleton
  factory TripsRepository() => _instance;
  static final TripsRepository _instance = TripsRepository._internal();
  TripsRepository._internal() {
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
    final costs = await db.query(
      costsTableName,
    );

    final requirements = await db.query(
      requirementsTableName,
    );

    return trips.map(
      (tripRow) => DatabaseTrip.fromRow(
        tripRow,
        costs.where((cost) => tripRow['id'] == cost['trip_id']).toList(),
        requirements
            .where((requirement) => tripRow['id'] == requirement['trip_id'])
            .toList(),
      ),
    );
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

    await db.insert(
      tripsTableName,
      {
        idColumn: newTrip.id,
        nameColumn: newTrip.name,
        destinationColumn: newTrip.destination,
        dateColumn: newTrip.date,
        noteColumn: newTrip.note
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    _trips.add(newTrip);
    _tripsStreamController.add(_trips);

    return newTrip;
  }

  Future<void> updateTrip(int id, String field, value) async {
    await _ensureDbIsOpen();
    final db = getDatabase();
    int count = await db.update(
      tripsTableName,
      {field: value},
      where: 'id = ?',
      whereArgs: [id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    if (count == 0) {
      throw CouldNotUpdateDatabaseException;
    }
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
    int count = await db.delete(
      tripsTableName,
      where: 'id = ?',
      whereArgs: [trip.id],
    );
    if (count == 0) {
      throw CouldNotDeleteDatabaseException;
    }
    _trips.remove(trip);
    _tripsStreamController.add(_trips);
  }

  DatabaseTrip getTrip(int id) {
    return _trips.where((trip) => trip.id == id).first;
  }

  Future<void> cacheTrips() async {
    final trips = await getAllTrips();
    _trips = trips.toList();
    _tripsStreamController.add(_trips);
  }

  Future<void> addCost(int tripId) async {
    await _ensureDbIsOpen();
    final db = getDatabase();
    DatabaseCost newCost = DatabaseCost(
        id: DateTime.now().microsecondsSinceEpoch,
        activity: '',
        planned: double.nan,
        real: double.nan,
        tripID: tripId);
    await db.insert(
      costsTableName,
      {
        idColumn: newCost.id,
        nameColumn: newCost.activity,
        plannedColumn: newCost.planned,
        realColumn: newCost.real,
        tripIdColumn: newCost.tripID
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    _trips.singleWhere((element) => element.id == tripId).costs.add(newCost);
    //return newCost;
  }

  Future<void> updateCost(DatabaseCost cost, String field, value) async {
    await _ensureDbIsOpen();
    final db = getDatabase();
    int count = await db.update(
      costsTableName,
      {field: value},
      where: 'id = ?',
      whereArgs: [cost.id],
    );

    if (count == 0) {
      throw CouldNotUpdateDatabaseException;
    }

    final updatedCosts =
        _trips.singleWhere((trip) => trip.id == cost.tripID).costs;
    final updatedCost =
        updatedCosts.singleWhere((oldCost) => oldCost.id == cost.id);
    switch (field) {
      case 'name':
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
  }

  Future<void> deleteCost(DatabaseCost cost) async {
    await _ensureDbIsOpen();
    final db = getDatabase();
    int count = await db.delete(
      costsTableName,
      where: 'id = ?',
      whereArgs: [cost.id],
    );

    if (count == 0) {
      throw CouldNotDeleteDatabaseException;
    }
    _trips
        .where((element) => element.id == cost.tripID)
        .first
        .costs
        .remove(cost);
  }

  Future<DatabaseRequirement> addRequirement(int tripId) async {
    await _ensureDbIsOpen();
    final db = getDatabase();
    DatabaseRequirement newRequirement = DatabaseRequirement(
      id: DateTime.now().microsecondsSinceEpoch,
      name: '',
      isDone: false,
      tripID: tripId,
    );
    await db.insert(
      requirementsTableName,
      {
        idColumn: newRequirement.id,
        nameColumn: newRequirement.name,
        isDoneColumn: (newRequirement.isDone) == false ? 0 : 1,
        tripIdColumn: newRequirement.tripID
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    _tripsStreamController.add(_trips);
    _trips
        .singleWhere((element) => element.id == tripId)
        .requirements
        .add(newRequirement);

    return newRequirement;
  }

  Future<void> updateRequirement(
      DatabaseRequirement requirement, String field, value) async {
    await _ensureDbIsOpen();
    final db = getDatabase();
    int count = await db.update(
      requirementsTableName,
      {field: value},
      where: 'id = ?',
      whereArgs: [requirement.id],
    );

    if (count == 0) {
      throw CouldNotUpdateDatabaseException;
    }

    final updatedRequirements = _trips
        .singleWhere((trip) => trip.id == requirement.tripID)
        .requirements;
    final updatedRequirement = updatedRequirements
        .singleWhere((oldRequirement) => oldRequirement.id == requirement.id);

    switch (field) {
      case 'name':
        updatedRequirement.name = value;
        break;
      case 'is_done':
        final parsedBool = value == 1 ? true : false;
        updatedRequirement.isDone = parsedBool;

        break;
    }
  }

  Future<void> deleteRequirement(DatabaseRequirement requirement) async {
    await _ensureDbIsOpen();
    final db = getDatabase();
    int count = await db.delete(
      requirementsTableName,
      where: 'id = ?',
      whereArgs: [requirement.id],
    );

    if (count == 0) {
      throw CouldNotDeleteDatabaseException;
    }
    _trips
        .where((element) => element.id == requirement.tripID)
        .first
        .requirements
        .remove(requirement);
  }

  Future<void> openDb() async {
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
        throw UnableToGetDocumentsDirectoryException();
      } catch (e) {
        throw UnknownDatabaseException();
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
      throw DatabaseNotFoundException();
    }
    return db;
  }
}

const dbName = 'trips.db';
const idColumn = "id";
const nameColumn = "name";
const isDoneColumn = "is_done";
const plannedColumn = "planned";
const realColumn = "real";
const destinationColumn = 'destination';
const dateColumn = 'date';
const noteColumn = 'note';
const tripsTableName = "trips";
const costsTableName = 'costs';
const requirementsTableName = 'requirements';
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
  "name"	TEXT,
	"planned"	TEXT,
	"real"	TEXT,
	"trip_id"	INTEGER NOT NULL,
	PRIMARY KEY("id" AUTOINCREMENT)
);
''';

const createRequirementsTable = '''CREATE TABLE IF NOT EXISTS  "requirements" (
	"id"	INTEGER NOT NULL UNIQUE,
	"name"	TEXT,
	"is_done"	INTEGER NOT NULL,
	"trip_id"	INTEGER NOT NULL,
	PRIMARY KEY("id" AUTOINCREMENT)
);
''';
