import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';

class MapViewScreen extends StatefulWidget {
  final String address;

  const MapViewScreen({Key? key, required this.address}) : super(key: key);

  @override
  _MapViewScreenState createState() => _MapViewScreenState();
}

class _MapViewScreenState extends State<MapViewScreen> {
  LatLng? location;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getLocationFromAddress();
  }

  Future<void> _getLocationFromAddress() async {
    try {
      List<Location> locations = await locationFromAddress(widget.address);
      print(locations);
      if (locations.isNotEmpty) {
        setState(() {
          location = LatLng(locations.first.latitude, locations.first.longitude);
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Adresse introuvable')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Localisation sur la carte')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : location == null
          ? const Center(child: Text("Adresse non localisée"))
          : GoogleMap(
        initialCameraPosition: CameraPosition(
          target: location!,
          zoom: 16,
        ),
        markers: {
          Marker(
            markerId: const MarkerId("event_location"),
            position: location!,
          )
        },
      ),
    );
  }
}
