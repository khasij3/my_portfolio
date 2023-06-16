import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_floating_action_button/custom_floating_action_button.dart';
import 'package:flutter/material.dart' hide Theme;
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:jointheway/widgets/buttons.dart';
import 'package:latlong2/latlong.dart' hide Path;
import 'package:vector_map_tiles/vector_map_tiles.dart';
import 'package:vector_tile_renderer/vector_tile_renderer.dart' hide TileLayer;

import 'package:jointheway/services/math.dart';
import 'package:jointheway/services/drawer.dart';

import '../services/drawer.dart';
import '../shared/colors.dart';
import '../shared/text_styles.dart';

class MapScreen extends StatefulWidget {
  final Function? tapMap;
  final LatLng? initPosition;
  final double? zoom;
  final double? width;
  final double? height;

  final bool? indicator;
  final bool? interactive;

  MapScreen({
    this.tapMap,
    this.initPosition,
    this.zoom,
    this.interactive,
    this.width,
    this.height,
    this.indicator,
  });

  @override
  _MapScreenState createState() => _MapScreenState();
}

enum Type { main, pin }

class _MapScreenState extends State<MapScreen> with TickerProviderStateMixin {
  MapController mapController = MapController();
  StreamController<Map> indicatorStreamCtrl = StreamController();
  late AnimationController _animationController;

  Position? currentPosition;
  Marker? selectedMarker;
  LatLng? selectedPosition;

  bool onMapReady = false;
  List<Map> users = [];
  List<Map> places = [];
  List<Map> plans = [];

  MathService math = MathService();

  Style? _style;
  Object? _error;

  @override
  void initState() {
    getCurrentPosition();
    super.initState();

    initMapStyle();
    initSelectedMarker();
  }

  @override
  void dispose() {
    // _animationController.dispose();
    super.dispose();
  }

  Stream<Map> indicatorStream() {
    Timer.periodic(const Duration(milliseconds: 100), (timer) {
      Map positions = {
        'pin': selectedPosition,
        'current': LatLng(
          currentPosition!.latitude,
          currentPosition!.longitude,
        ),
      };

      indicatorStreamCtrl.add(positions);
    });

    return indicatorStreamCtrl.stream;
  }

  getCurrentPosition() async {
    final hasPermission = await handleLocationPermission();

    if (hasPermission) {
      await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high)
          .then((Position position) {
        setState(() {
          currentPosition = position;
        });
      }).catchError((e) {
        debugPrint(e);
      });
    }
  }

  initMapStyle() async {
    try {
      _style = await readMapStyle();
    } catch (e, stack) {
      print(e);

      print(stack);
      _error = e;
    }
    setState(() {});
  }

  initSelectedMarker() {
    if (widget.initPosition != null) {
      MarkPosition(widget.initPosition!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, BoxConstraints constraints) {
      return Container(
        constraints: BoxConstraints(
          minHeight: 0,
          minWidth: 0,
        ),
        child: _error != null
            ? Text(_error!.toString())
            : _style == null || currentPosition == null
                ? Container(
                    width: constraints.maxWidth,
                    height: constraints.maxHeight,
                    child: Align(
                      heightFactor: 1,
                      widthFactor: 1,
                      child: CircularProgressIndicator(),
                    ),
                  )
                : Stack(
                    children: [
                      FlutterMap(
                        mapController: mapController,
                        options: MapOptions(
                            onMapReady: () {
                              setState(() {
                                onMapReady = true;
                              });
                            },
                            center: widget.initPosition ??
                                LatLng(
                                  currentPosition!.latitude,
                                  currentPosition!.longitude,
                                ),
                            zoom: widget.zoom ?? 17,
                            //position changed
                            onPositionChanged: (position, hasGesture) {
                              try {
                                if (hasGesture) {
                                  indicatorStreamCtrl.onResume;
                                } else {
                                  indicatorStreamCtrl.onPause;
                                }
                              } on StateError catch (e) {
                                print(e);
                              }
                            },
                            // position tap
                            onTap: (tapPosition, point) {
                              if (widget.tapMap != null) {
                                widget.tapMap!(point);
                                MarkPosition(point);
                              }
                            },
                            minZoom: 15,
                            maxZoom: 18,
                            interactiveFlags: widget.interactive == false
                                ? ~InteractiveFlag.all
                                : InteractiveFlag.drag |
                                    InteractiveFlag.flingAnimation |
                                    InteractiveFlag.pinchMove |
                                    InteractiveFlag.pinchZoom |
                                    InteractiveFlag.doubleTapZoom),
                        children: [
                          // map loaded
                          VectorTileLayer(
                            theme: _style!.theme,
                            backgroundTheme: _style!.theme.copyWith(types: {
                              ThemeLayerType.background,
                              ThemeLayerType.fill
                            }),
                            tileProviders: _style!.providers,
                            fileCacheMaximumSizeInBytes: 256,
                          ),

                          // current user marker
                          CurrentLocationLayer(
                            style: LocationMarkerStyle(
                              headingSectorColor: AppColors.primary,
                              accuracyCircleColor:
                                  AppColors.primary.withOpacity(0.2),
                            ),
                          ),

                          // set selected marker
                          selectedMarker != null
                              ? MarkerLayer(
                                  markers: [selectedMarker!],
                                )
                              : SizedBox(),
                        ],
                      ),

                      // set pin indicator
                      onMapReady && widget.indicator == true
                          ? StreamBuilder(
                              stream: indicatorStream(),
                              builder: (context, AsyncSnapshot<Map> snapshot) {
                                if (!snapshot.hasData) {
                                  return SizedBox();
                                }
                                Map data = snapshot.data!;
                                return Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    // cuurent indicator
                                    indicator(
                                      constraints: constraints,
                                      target: data['current'],
                                      backGroundColor: AppColors.primaryDarker,
                                      child: Icon(
                                        Icons.my_location,
                                        color: AppColors.primaryDarker,
                                      ),
                                    ),

                                    // pin indicator
                                    selectedPosition == null
                                        ? widget.initPosition != null
                                            ? indicator(
                                                constraints: constraints,
                                                target: widget.initPosition!)
                                            : SizedBox()
                                        : indicator(
                                            constraints: constraints,
                                            target:
                                                data['pin'] ?? selectedPosition,
                                          )
                                  ],
                                );
                              },
                            )
                          : SizedBox(),
                    ],
                  ),
      );
    });
  }

  Widget indicator({
    required BoxConstraints constraints,
    required LatLng target,
    Color? backGroundColor,
    Widget? child,
  }) {
    bool targetFound = mapController.bounds!.contains(target);

    double direction = MathService().calculateAngleBetweenPoints(
      mapController.center.latitude,
      mapController.center.longitude,
      target.latitude,
      target.longitude,
    );

    Offset screenPosition = math.getScreenPositionFromLatLng(
        constraints.maxWidth, constraints.maxHeight, target, mapController);

    return targetFound == false
        ? Positioned(
            top: screenPosition.dy < 0
                ? 0
                : screenPosition.dy > constraints.maxHeight - 74
                    ? constraints.maxHeight - 74
                    : screenPosition.dy,
            left: screenPosition.dx < 0
                ? 0
                : screenPosition.dx > constraints.maxWidth - 74
                    ? constraints.maxWidth - 74
                    : screenPosition.dx,
            child: Transform.rotate(
              angle: math.radians(direction),
              child: CustomPaint(
                painter: DrawerService(
                  shape: Shape.Indicator,
                  radius: 24,
                  color: backGroundColor ?? AppColors.secondary,
                ),
                size: Size(74, 74),
                child: Padding(
                  padding: EdgeInsets.all(17),
                  child: Transform.rotate(
                    angle: math.radians(direction) * -1,
                    child: GestureDetector(
                      onTap: () => animatedMapMove(
                        target,
                        mapController.zoom,
                      ),
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: AppColors.foregroundLight,
                        child: child ??
                            Icon(
                              Icons.location_pin,
                              color: backGroundColor ?? AppColors.secondary,
                            ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        : SizedBox();
  }

  MarkPosition(LatLng point) {
    setState(() {
      selectedPosition = point;
      selectedMarker = Marker(
        point: point,
        builder: (context) {
          return Stack(
            children: [
              Positioned(
                bottom: 0,
                child: CustomPaint(
                  painter: DrawerService(
                    shape: Shape.Oval,
                    color: AppColors.neutralBlack.withOpacity(0.2),
                  ),
                  size: Size(30, 7),
                ),
              ),
              Icon(
                Icons.location_pin,
                color: AppColors.secondary,
                size: 30,
              ),
            ],
          );
        },
      );
    });
  }

  animatedMapMove(LatLng destLocation, double destZoom) {
    // Create some tweens. These serve to split up the transition from one location to another.
    // In our case, we want to split the transition be<tween> our current map center and the destination.
    _animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    final latTween = Tween<double>(
      begin: mapController.center.latitude,
      end: destLocation.latitude,
    );
    final lngTween = Tween<double>(
      begin: mapController.center.longitude,
      end: destLocation.longitude,
    );
    final zoomTween = Tween<double>(
      begin: mapController.zoom,
      end: destZoom,
    );

    // Create a animation controller that has a duration and a TickerProvider.

    // The animation determines what path the animation will take. You can try different Curves values, although I found
    // fastOutSlowIn to be my favorite.
    final Animation<double> animation = CurvedAnimation(
        parent: _animationController, curve: Curves.fastOutSlowIn);

    _animationController.addListener(() {
      mapController.move(
          LatLng(latTween.evaluate(animation), lngTween.evaluate(animation)),
          zoomTween.evaluate(animation));
    });

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.dispose();
      } else if (status == AnimationStatus.dismissed) {
        _animationController.dispose();
      }
    });

    _animationController.forward();
  }

  Future<Style> readMapStyle() {
    return StyleReader(
      uri: 'https://api.maptiler.com/maps/dataviz/style.json?key={key}',
      // ignore: undefined_identifier
      apiKey: 'GYjvqfTPK2UOJxucQu3O',
      logger: const Logger.console(),
    ).read();
  }

  Future<bool> handleLocationPermission() async {
    bool isMapPrepared = false;
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }

    return true;
  }
}
