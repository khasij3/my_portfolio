import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

import 'package:latlong2/latlong.dart';

class MapShow extends StatefulWidget {
  final double zoom;
  final LatLng initPosition;
  final bool? interactable;

  const MapShow({
    required this.zoom,
    required this.initPosition,
    this.interactable,
  });

  @override
  State<MapShow> createState() => _MapShowState();
}

class _MapShowState extends State<MapShow> {
  final mapController = MapController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        center: widget.initPosition,
        zoom: widget.zoom,
        maxZoom: 18,
        //disable map rotation
        interactiveFlags: widget.interactable == false
            ? ~InteractiveFlag.all
            : InteractiveFlag.all & ~InteractiveFlag.rotate,
      ),
      children: [
        TileLayer(
          urlTemplate:
              'https://api.maptiler.com/maps/dataviz/{z}/{x}/{y}@2x.png?key=GYjvqfTPK2UOJxucQu3O',
          retinaMode: true,
          maxZoom: 17,
        )
      ],
    );
  }
}
