// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

Future<GeoPoint?> chooseGeoPoint(BuildContext context) async {
  final MapController controller = MapController(
    initMapWithUserPosition:
        const UserTrackingOption(enableTracking: true, unFollowUser: true),
  );

  GeoPoint? point = await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text(
          "اختيار الموقع",
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(25),
          ),
        ),
        contentPadding: const EdgeInsets.all(8),
        content: SizedBox(
          height: MediaQuery.of(context).size.width * 4 / 5,
          child: OSMFlutter(
            osmOption: OSMOption(
              isPicker: true,
              enableRotationByGesture: false,
              zoomOption: const ZoomOption(
                initZoom: 18,
                maxZoomLevel: 18,
                stepZoom: 1.0,
              ),
              userLocationMarker: UserLocationMaker(
                personMarker: const MarkerIcon(
                  icon: Icon(
                    Icons.pin_drop,
                    color: Colors.blue,
                    size: 60,
                  ),
                ),
                directionArrowMarker: const MarkerIcon(
                  icon: Icon(
                    Icons.double_arrow,
                    size: 48,
                  ),
                ),
              ),
              roadConfiguration: const RoadOption(
                roadColor: Colors.yellowAccent,
              ),
              markerOption: MarkerOption(
                defaultMarker: const MarkerIcon(icon: Icon(Icons.circle)),
              ),
            ),
            controller: controller,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "خروج",
              style: TextStyle(color: Colors.black),
            ),
          ),
          GestureDetector(
            onTap: () async {
              final geopoint =
                  await controller.getCurrentPositionAdvancedPositionPicker();
              await controller.cancelAdvancedPositionPicker();
              Navigator.pop(context, geopoint);
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(25),
              ),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "اختيار",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      );
    },
  );

  return point;
}
