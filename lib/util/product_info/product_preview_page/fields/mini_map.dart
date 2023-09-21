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
            osmOption: const OSMOption(
              isPicker: true,
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
