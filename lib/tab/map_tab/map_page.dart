import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

class MapPage extends StatefulWidget {
  final GeoPoint geopoint;
  final MapController controller;
  const MapPage({super.key, required this.geopoint, required this.controller});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  @override
  initState() {
    super.initState();
    controller = MapController(initPosition: widget.geopoint);
  }

  late MapController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: OSMFlutter(
        controller: controller,
        initZoom: 16,
        staticPoints: [
          StaticPositionGeoPoint(
              "",
              const MarkerIcon(
                icon: Icon(Icons.location_on),
              ),
              [widget.geopoint])
        ],
      ),
    );
  }
}
