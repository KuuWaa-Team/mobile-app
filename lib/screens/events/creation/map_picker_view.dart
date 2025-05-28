import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';
import 'package:geocoding/geocoding.dart';
import 'package:kuuwaa/common/app_colors.dart';
import 'package:kuuwaa/common/common_widget.dart';
import 'package:kuuwaa/responsive/responsive_flutter.dart';

class MapPickerPage extends StatefulWidget {
  final String initialAddress;

  const MapPickerPage({super.key, required this.initialAddress});

  @override
  State<MapPickerPage> createState() => _MapPickerPageState();
}

class _MapPickerPageState extends State<MapPickerPage> {
  AppColors appColors = AppColors();

  GoogleMapController? _controller;
  LatLng? _pickedLocation;

  static const LatLng _defaultPosition = LatLng(-4.325, 15.322); // Kinshasa

  late GooglePlace googlePlace;
  List<AutocompletePrediction> predictions = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    googlePlace = GooglePlace("AIzaSyAvXtXVRVf5OMYoeRtzGc-6TIKc_TnL8ys");
  }

  void autoCompleteSearch(String value) async {
    if (value.isNotEmpty) {
      var result = await googlePlace.autocomplete.get(value);
      if (result != null && result.predictions != null) {
        setState(() {
          predictions = result.predictions!;
        });
      }
    } else {
      setState(() {
        predictions = [];
      });
    }
  }

  Future<void> moveCameraToPlace(String placeId) async {
    var details = await googlePlace.details.get(placeId);
    if (details != null && details.result != null) {
      var loc = details.result!.geometry!.location!;
      final newPos = LatLng(loc.lat!, loc.lng!);
      _controller?.animateCamera(CameraUpdate.newLatLngZoom(newPos, 16));
      setState(() {
        _pickedLocation = newPos;
        predictions.clear();
        _searchController.text = details.result!.name ?? "";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: MyTextView(
        "Choisir l'emplacememnt",
        textAligntNew: TextAlign.start,
        maxLineWrap: true,
        styleNew: MyTextStyle(
          colorNew: Colors.black,
          fontWeightNew: FontWeight.w500,
          size: ResponsiveFlutter.of(context).fontSize(2.2),
        ),
      ),),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: _defaultPosition,
              zoom: 14,
            ),
            onMapCreated: (controller) {
              _controller = controller;
            },
            onTap: (latLng) {
              setState(() {
                _pickedLocation = latLng;
              });
            },
            markers: _pickedLocation != null
                ? {
              Marker(
                markerId: const MarkerId('picked'),
                position: _pickedLocation!,
              ),
            }
                : {},
            mapType: MapType.normal,
            myLocationEnabled: true,
            zoomControlsEnabled: false,
          ),
          // Barre de recherche
          Positioned(
            top: 10,
            left: 15,
            right: 15,
            child: Column(
              children: [
                Material(
                  elevation: 5,
                  borderRadius: BorderRadius.circular(8),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: "Rechercher une adresse...",
                      contentPadding: const EdgeInsets.all(12),
                      border: InputBorder.none,
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            predictions = [];
                          });
                        },
                      ),
                    ),
                    onChanged: autoCompleteSearch,
                  ),
                ),
                if (predictions.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(top: 5),
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: const [
                        BoxShadow(color: Colors.black26, blurRadius: 5)
                      ],
                    ),
                    child: ListView.builder(
                      itemCount: predictions.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(predictions[index].description ?? ""),
                          onTap: () {
                            moveCameraToPlace(predictions[index].placeId!);
                          },
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: ElevatedButton.icon(
              onPressed: _pickedLocation != null
                  ? () => Navigator.pop(context, _pickedLocation)
                  : null,
              icon: const Icon(Icons.check, color: Colors.white,),
              label: MyTextView(
                "Confirmer ce lieu",
                textAligntNew: TextAlign.start,
                maxLineWrap: true,
                styleNew: MyTextStyle(
                  colorNew: Colors.white,
                  fontWeightNew: FontWeight.w500,
                  size: ResponsiveFlutter.of(context).fontSize(1.8),
                ),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                backgroundColor:
                _pickedLocation != null ? appColors.btnColor : Colors.grey,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
