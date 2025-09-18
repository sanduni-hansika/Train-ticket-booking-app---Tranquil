import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'data.dart'; 
class LiveLocationPage extends StatefulWidget {
  final Train selectedTrain;

  const LiveLocationPage({super.key, required this.selectedTrain});

  @override
  State<LiveLocationPage> createState() => _LiveLocationPageState();
}

class _LiveLocationPageState extends State<LiveLocationPage> {
  GoogleMapController? mapController;
  LatLng _currentPosition = const LatLng(0, 0);
  Timer? _timer;
  int _currentStationIndex = 0;

  
  final int _animationSteps = 300; 
  int _currentStep = 0;

  @override
  void initState() {
    super.initState();
    _currentPosition = widget.selectedTrain.startStation.coordinates;
    _startSimulation();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startSimulation() {
    _timer = Timer.periodic(const Duration(milliseconds: 300), (timer) {
      if (!mounted) return;

      setState(() {
        if (_currentStationIndex >=
            widget.selectedTrain.routeStations.length - 1) {
          _timer?.cancel();
          return;
        }

        Station fromStation =
            widget.selectedTrain.routeStations[_currentStationIndex];
        Station toStation =
            widget.selectedTrain.routeStations[_currentStationIndex + 1];

        double t = _currentStep / _animationSteps;
        double lat =
            fromStation.coordinates.latitude +
                t *
                    (toStation.coordinates.latitude -
                        fromStation.coordinates.latitude);
        double lng =
            fromStation.coordinates.longitude +
                t *
                    (toStation.coordinates.longitude -
                        fromStation.coordinates.longitude);

        _currentPosition = LatLng(lat, lng);

        _currentStep++;

        if (_currentStep > _animationSteps) {
          _currentStep = 0;
          _currentStationIndex++;
        }
      });
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    final train = widget.selectedTrain;

    final Set<Marker> markers = {
      Marker(
        markerId: const MarkerId('train_marker'),
        position: _currentPosition,
        infoWindow: InfoWindow(
          title: train.trainName,
          snippet: "${train.startStation.name} → ${train.endStation.name}",
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      ),
    };

    final Set<Polyline> polylines = {
      Polyline(
        polylineId: const PolylineId('train_route'),
        points: train.routeStations.map((s) => s.coordinates).toList(),
        color: Colors.indigo,
        width: 5,
      ),
    };

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF58A2F7),
        foregroundColor: Colors.white,
        leading: TextButton(
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            alignment: Alignment.center,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text(
            '<',
            style: TextStyle(
              fontSize: 28,
              color: Colors.white,
              fontWeight: FontWeight.bold,
              height: 1,
            ),
          ),
        ),
        title: Text('${train.trainName} Live Location'),
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _currentPosition,
          zoom: 9.5,
        ),
        markers: markers,
        polylines: polylines,
      ),
    );
  }
}
