import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:samsarah/tab/map_tab/map_page.dart';

import '../../tools/poppers_and_pushers.dart';
import 'ppp_floating_button.dart';
import 'controller.dart';
import 'mini_map.dart';

class LocationPreview extends StatefulWidget {
  final GeoPoint? geopoint;
  final ProductController pc;
  final PPPType type;
  const LocationPreview(
      {super.key, required this.pc, this.geopoint, required this.type});

  @override
  State<LocationPreview> createState() => _LocationPreviewState();
}

class _LocationPreviewState extends State<LocationPreview>
    with AutomaticKeepAliveClientMixin {
  GeoPoint? geopoint;
  late final LocationPreviewData data;

  @override
  void initState() {
    super.initState();
    geopoint = widget.geopoint;
    data = LocationPreviewData.fromType(widget.type,
        widget.type == PPPType.viewExternal ? viewGeoPoint : setGeoPoint);
  }

  viewGeoPoint() {
    push(
        context,
        MapPage(
          geopoint: geopoint!,
          controller: MapController(initPosition: geopoint),
        ));
  }

  setGeoPoint() async {
    var temp = await chooseGeoPoint(context);
    if (temp != null) {
      geopoint = temp;
    }
    if (mounted) {
      setState(() {});
    }
  }

  getChildren() {
    return [
      Icon(
        geopoint != null ? data.iconData : Icons.location_disabled_outlined,
        color: Colors.white,
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          geopoint != null ? data.title : "!اختر الموقع",
          style: const TextStyle(color: Colors.white),
        ),
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FormField(
      validator: (_) {
        if (geopoint == null) {
          return "location is null";
        }
        return null;
      },
      onSaved: (_) => widget.pc.geopoint = geopoint!,
      builder: (_) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: data.onTap,
            child: Container(
              constraints: const BoxConstraints(minWidth: 100, minHeight: 100),
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(blurRadius: 15, color: Colors.grey.shade300)
                  ],
                  color: geopoint != null ? data.color : Colors.red),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: getChildren(),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class LocationPreviewData {
  final Color color;
  final IconData iconData;
  final String title;
  final void Function() onTap;
  LocationPreviewData({
    required this.color,
    required this.iconData,
    required this.title,
    required this.onTap,
  });

  factory LocationPreviewData.fromType(PPPType type, VoidCallback onTap) {
    switch (type) {
      case PPPType.createNew:
        return LocationPreviewData(
            color: Colors.blue,
            iconData: Icons.edit,
            title: "تغيير الموقع",
            onTap: onTap);
      case PPPType.viewExternal:
        return LocationPreviewData(
            color: Colors.green,
            iconData: Icons.map,
            title: "الذهاب الى الموقع",
            onTap: onTap);
      case PPPType.viewInternal:
        return LocationPreviewData(
            color: Colors.blue,
            iconData: Icons.edit,
            title: "تغيير الموقع",
            onTap: onTap);
      default:
        return LocationPreviewData(
            color: Colors.grey,
            iconData: Icons.broken_image,
            title: "",
            onTap: () {});
    }
  }
}
