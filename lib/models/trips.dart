class DatabaseTrip {
  int id;
  String name;
  String destination;
  List<DatabaseCost> costs;
  List<DatabaseRequirement> requirements;
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

  DatabaseTrip.fromRow(Map<String, Object?> map,
      List<Map<String, Object?>> costs, List<Map<String, Object?>> requirements)
      : id = map[idColumn] as int,
        name = map[nameColumn] as String,
        destination = map[destinationColumn] as String,
        date = map[dateColumn] as String,
        note = map[noteColumn] as String,
        costs = costs
            .map((e) => DatabaseCost(
                  id: e[idColumn] as int,
                  activity: e[nameColumn] as String,
                  planned: (double.tryParse(e[plannedColumn].toString()) ??
                      double.nan),
                  real:
                      (double.tryParse(e[realColumn].toString()) ?? double.nan),
                  tripID: e[tripIdColumn] as int,
                ))
            .toList(),
        requirements = requirements
            .map((e) => DatabaseRequirement(
                  id: e[idColumn] as int,
                  name: e[nameColumn] as String,
                  isDone: (e[isDoneColumn] as int) == 1 ? true : false,
                  tripID: e[tripIdColumn] as int,
                ))
            .toList();

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

class DatabaseRequirement {
  final int id;
  String name;
  bool isDone;
  int tripID;

  DatabaseRequirement({
    required this.id,
    required this.name,
    required this.isDone,
    required this.tripID,
  });
}

const idColumn = "id";
const nameColumn = "name";
const isDoneColumn = "is_done";
const plannedColumn = "planned";
const realColumn = "real";
const destinationColumn = 'destination';
const dateColumn = 'date';
const noteColumn = 'note';
const tripIdColumn = 'trip_id';
