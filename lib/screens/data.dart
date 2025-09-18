import 'package:google_maps_flutter/google_maps_flutter.dart';

enum RunDays { weekday, weekend }

// Station model
class Station {
  final String name;
  final LatLng coordinates;

  Station({required this.name, required this.coordinates});
}

// Train model
class Train {
  final String trainName;
  final String trainNo;
  final Station startStation;
  final Station endStation;
  final List<Station> routeStations;
  final RunDays runDays;

  Train({
    required this.trainName,
    required this.trainNo,
    required this.startStation,
    required this.endStation,
    required this.routeStations,
    required this.runDays,
  });
}

// Master station list
final stations = <Station>[
  Station(name: 'Maradana', coordinates: LatLng(6.9248, 79.8654)),
  Station(name: 'Matara', coordinates: LatLng(5.9554, 80.5376)),
  Station(name: 'Anuradhapura', coordinates: LatLng(8.3392, 80.4357)),
  Station(name: 'Jaffna', coordinates: LatLng(9.6647, 80.0163)),
  Station(name: 'Colombo Fort', coordinates: LatLng(6.9320, 79.8458)),
];


final allTrains = <Train>[
  Train(
    trainName: 'Galu Kumari',
    trainNo: '8050',
    startStation: stations[0],
    endStation: stations[1],
    routeStations: [stations[0], stations[1]],
    runDays: RunDays.weekday,
  ),
  Train(
    trainName: 'Ruhunu Kumari',
    trainNo: 'Weekend Ruhunu',
    startStation: stations[0],
    endStation: stations[1],
    routeStations: [stations[0], stations[1]],
    runDays: RunDays.weekend,
  ),
  Train(
    trainName: 'Yal Rani',
    trainNo: '4443',
    startStation: stations[2],
    endStation: stations[3],
    routeStations: [stations[2], stations[3]],
    runDays: RunDays.weekday,
  ),
  Train(
    trainName: 'Colombo Commuter',
    trainNo: '4441',
    startStation: stations[2],
    endStation: stations[3],
    routeStations: [stations[2], stations[3]],
    runDays: RunDays.weekend,
  ),
  Train(
    trainName: 'Uttara Devi',
    trainNo: '4021',
    startStation: stations[2],
    endStation: stations[3],
    routeStations: [stations[2], stations[3]],
    runDays: RunDays.weekend,
  ),
  Train(
    trainName: 'Express',
    trainNo: '8766',
    startStation: stations[4],
    endStation: stations[1],
    routeStations: [stations[4], stations[1]],
    runDays: RunDays.weekend,
  ),
  Train(
    trainName: 'Long Distance',
    trainNo: '8094',
    startStation: stations[4],
    endStation: stations[1],
    routeStations: [stations[4], stations[1]],
    runDays: RunDays.weekday,
  ),
  Train(
    trainName: 'Ruhunu Kumari',
    trainNo: '8058',
    startStation: stations[4],
    endStation: stations[1],
    routeStations: [stations[4], stations[1]],
    runDays: RunDays.weekday,
  ),
  Train(
    trainName: '8050',
    trainNo: '8050-Colombo',
    startStation: stations[4],
    endStation: stations[1],
    routeStations: [
      stations[4],
      Station(name: 'Beliaththa', coordinates: LatLng(6.0567, 80.7224)),
      stations[1],
    ],
    runDays: RunDays.weekday,
  ),
];
