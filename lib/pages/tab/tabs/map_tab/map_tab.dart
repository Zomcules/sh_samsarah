import 'package:cloud_firestore/cloud_firestore.dart' as fstore;
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:samsarah/pages/tab/other/distributor_page.dart';
import 'package:samsarah/services/auth_service.dart';
import 'package:samsarah/services/database_service.dart';
import 'package:samsarah/util/product_info/product_preview_page.dart';
import 'package:samsarah/util/product_info/product_preview_page/fields/ppp_floating_button.dart';

import '../../../../util/tools/poppers_and_pushers.dart';

class MapTab extends StatefulWidget {
  const MapTab({super.key});

  @override
  State<MapTab> createState() => _MapTabState();
}

class _MapTabState extends State<MapTab> with AutomaticKeepAliveClientMixin {
  @override
  final wantKeepAlive = true;
  final _auth = AuthService();
  bool advancedOn = false;
  final MapController mapController = MapController(
    initMapWithUserPosition:
        const UserTrackingOption(enableTracking: true, unFollowUser: true),
  );

  Future<void> addGeoPoints() async {
    var prods = (await Database().productCollection.get())
        .docs
        .map((e) => e.data())
        .toList();
    for (var element in prods) {
      mapController.addMarker(element.geopoint,
          markerIcon: const MarkerIcon(
            icon: Icon(
              Icons.location_on,
              size: 45,
              color: Colors.red,
            ),
          ));
    }

    var distr = await Database().getDistributers();
    for (var element in distr) {
      mapController.addMarker(
        element.geoPoint,
        markerIcon: const MarkerIcon(
          icon: Icon(
            Icons.shopping_basket_outlined,
            size: 45,
            color: Colors.yellow,
          ),
        ),
      );
    }
  }

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
      setState(() {
        advancedOn = false;
      });
      if (_auth.isSignedIn) {
        push(
          context,
          ProductPreviewPage(
            type: PPPType.createNew,
            geoPoint:
                await mapController.getCurrentPositionAdvancedPositionPicker(),
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (context) => const AlertDialog(
            content: Text("يجب عليك تسجيل الدخول أولا"),
          ),
        );
      }
      mapController.cancelAdvancedPositionPicker();
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
    return Stack(
      children: [
        OSMFlutter(
          onMapIsReady: (p0) async => p0 ? addGeoPoints() : null,
          osmOption: OSMOption(
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
          //enableRotationByGesture: true,
          onGeoPointClicked: onGeoPointClicked,
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
      ],
    );
  }

  void onGeoPointClicked(GeoPoint p1) async {
    var prod = (await Database()
            .productCollection
            .where("geopointMap", isEqualTo: p1.toMap())
            .get(const fstore.GetOptions(source: fstore.Source.cache)))
        .docs
        .firstOrNull
        ?.data();
    if (prod != null) {
      if (mounted) {
        push(
          context,
          ProductPreviewPage(
            type: PPPType.viewExternal,
            info: prod,
          ),
        );
      }
    } else if (mounted) {
      push(
        context,
        DistrPage(
          distr: (await Database()
                  .distrCollection
                  .where("geopointMap", isEqualTo: p1.toMap())
                  .get(const fstore.GetOptions(source: fstore.Source.cache)))
              .docs
              .first
              .data(),
        ),
      );
    }
  }
}
