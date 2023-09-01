import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:samsarah/util/database/database.dart';

import 'geopoint_preview.dart';

class MapTab extends StatefulWidget {
  const MapTab({super.key});

  @override
  State<MapTab> createState() => _MapTabState();
}

class _MapTabState extends State<MapTab> with AutomaticKeepAliveClientMixin {
  var db = DataBase();

  @override
  bool wantKeepAlive = true;
  bool advancedOn = false;
  MapController mapController = MapController(
    initMapWithUserPosition:
        const UserTrackingOption(enableTracking: true, unFollowUser: true),
  );

  void onPressed() async {
    mapController
        .enableTracking(
          enableStopFollow: true,
        )
        .then((value) => mapController.setZoom(zoomLevel: 16));
  }

  smallPressed() async {
    /// To Start assisted Selection
    if (!advancedOn) {
      await mapController.advancedPositionPicker();
      setState(() {
        advancedOn = true;
      });
    } else {
      mapController.addMarker(
          await mapController.getCurrentPositionAdvancedPositionPicker(),
          markerIcon: const MarkerIcon(
            icon: Icon(
              Icons.location_on,
              size: 80,
              color: Colors.red,
            ),
          ));
      mapController.cancelAdvancedPositionPicker();
      setState(() {
        advancedOn = false;
      });
    }
  }

  smallerPressed() async {
    mapController.cancelAdvancedPositionPicker();
    setState(() {
      advancedOn = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Stack(children: [
      OSMFlutter(
        osmOption: OSMOption(
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
        //enableRotationByGesture: true,
        onGeoPointClicked: (geoPoint) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => GeoPointPreview(geoPoint: geoPoint)));
        },
        controller: mapController,
      ),
      Positioned(
        right: 0,
        bottom: 0,
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 10, bottom: 20, right: 10),
              width: 50,
              child: advancedOn
                  ? FloatingActionButton(
                      heroTag: "1",
                      shape: const CircleBorder(eccentricity: 0),
                      backgroundColor: Colors.red,
                      onPressed: smallerPressed,
                      isExtended: false,
                      child: const Text(
                        "X",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    )
                  : null,
            ),
            Container(
              margin: const EdgeInsets.only(left: 10, bottom: 20, right: 10),
              width: 50,
              child: FloatingActionButton(
                heroTag: "2",
                shape: const CircleBorder(eccentricity: 0),
                backgroundColor: Colors.green,
                onPressed: smallPressed,
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 10, bottom: 20, right: 10),
              child: FloatingActionButton(
                heroTag: "3",
                shape: const CircleBorder(eccentricity: 0),
                backgroundColor: Colors.blue,
                onPressed: onPressed,
                child: const Icon(
                  Icons.gps_fixed,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    ]);
  }
}
