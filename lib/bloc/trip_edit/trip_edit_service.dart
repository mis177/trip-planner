import 'package:share_plus/share_plus.dart';
import 'package:tripplanner/bloc/trip_edit/utils/trip_share_formatter.dart';
import 'package:tripplanner/models/trips.dart';
import 'package:tripplanner/services/crud/trips_repository.dart';

class TripEditService {
  late final _repository = TripsRepository();

  // singleton
  static final TripEditService _instance = TripEditService._internal();
  TripEditService._internal();
  factory TripEditService() {
    return _instance;
  }

  Future<void> updateTrip({
    required String fieldName,
    required String text,
    required DatabaseTrip trip,
  }) async {
    await _repository.updateTrip(
      trip.id,
      fieldName,
      text,
    );
  }

  Future<void> shareTrip({
    required DatabaseTrip trip,
    required List<String> message,
  }) async {
    String sharingText = TripShareFormatter().formatShareMessage(trip, message);
    Share.share(sharingText);
  }
}
