// import 'dart:async';
// import 'dart:math';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:custom_floating_action_button/custom_floating_action_button.dart';
// import 'package:flutter/material.dart' hide Theme;
// import 'package:flutter/rendering.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:jointheway/widgets/buttons.dart';
// import 'package:latlong2/latlong.dart' hide Path;
// import 'package:vector_map_tiles/vector_map_tiles.dart';
// import 'package:vector_tile_renderer/vector_tile_renderer.dart' hide TileLayer;

// import '../services/painter.dart';
// import '../shared/colors.dart';
// import '../shared/text_styles.dart';

// class MapScreen extends StatefulWidget {
//   final LatLng? initPosition;
//   final Position? cuurentPosition;

//   final bool? interactive;

//   MapScreen({
//     this.initPosition,
//     this.interactive,
//     this.cuurentPosition,
//   });

//   @override
//   _MapScreenState createState() => _MapScreenState();
// }

// enum Type { main, pin }

// class _MapScreenState extends State<MapScreen> with TickerProviderStateMixin {
//   MapController mapController = MapController();
//   StreamController<Map> indicatorStreamCtrl = StreamController();
//   late AnimationController _animationController;

//   Position? currentPosition;
//   Marker? selectedMarker;
//   LatLng? selectedPosition;

//   bool onMapReady = false;
//   List<Map> users = [];
//   List<Map> places = [];
//   List<Map> plans = [];

//   Style? _style;
//   Object? _error;

//   @override
//   void initState() {
//     getCurrentPosition();
//     super.initState();

//     initMapStyle();
//     initSelectedMarker();
//   }

//   @override
//   void dispose() {
//     // _animationController.dispose();
//     super.dispose();
//   }

//   Stream<Map> indicatorStream() {
//     Timer.periodic(const Duration(milliseconds: 100), (timer) {
//       Map positions = {
//         'pin': selectedPosition,
//         'current': LatLng(
//           currentPosition!.latitude,
//           currentPosition!.longitude,
//         ),
//       };

//       indicatorStreamCtrl.add(positions);
//     });

//     return indicatorStreamCtrl.stream;
//   }

//   getCurrentPosition() async {
//     final hasPermission = await handleLocationPermission();

//     if (hasPermission) {
//       await Geolocator.getCurrentPosition(
//               desiredAccuracy: LocationAccuracy.high)
//           .then((Position position) {
//         setState(() {
//           currentPosition = position;
//         });
//       }).catchError((e) {
//         debugPrint(e);
//       });
//     }
//   }

//   initMapStyle() async {
//     try {
//       _style = await readMapStyle();
//     } catch (e, stack) {
//       print(e);

//       print(stack);
//       _error = e;
//     }
//     setState(() {});
//   }

//   initSelectedMarker() {
//     if (widget.initPosition != null) {
//       MarkPosition(widget.initPosition!);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {


//     return LayoutBuilder(builder: (context, BoxConstraints constraints) {
//       return Container(
//         constraints: BoxConstraints(
//           minHeight: 0,
//           minWidth: 0,
//         ),
//         child: _error != null
//             ? Text(_error!.toString())
//             : _style == null || currentPosition == null
//                 ? Container(
//                     width: constraints.maxWidth,
//                     height: constraints.maxHeight,
//                     child: Align(
//                       heightFactor: 1,
//                       widthFactor: 1,
//                       child: CircularProgressIndicator(),
//                     ),
//                   )
//                 : Stack(
//                     children: [
//                       FlutterMap(
//                         mapController: mapController,
//                         options: MapOptions(
//                             onMapReady: () {
//                               setState(() {
//                                 onMapReady = true;
//                               });
//                             },
//                             center: widget.initPosition ??
//                                 LatLng(
//                                   currentPosition!.latitude,
//                                   currentPosition!.longitude,
//                                 ),
//                             zoom: 17,
//                             //position changed
//                             onPositionChanged: (position, hasGesture) {
//                               try {
//                                 if (hasGesture) {
//                                   indicatorStreamCtrl.onResume;
//                                 } else {
//                                   indicatorStreamCtrl.onPause;
//                                 }
//                               } on StateError catch (e) {
//                                 print(e);
//                               }
//                             },
//                             // position tap
//                             onTap: (tapPosition, point) {
                            
//                             },
//                             minZoom: 15,
//                             maxZoom: 18,
//                             interactiveFlags: widget.interactive == false
//                                 ? ~InteractiveFlag.all
//                                 : InteractiveFlag.drag |
//                                     InteractiveFlag.flingAnimation |
//                                     InteractiveFlag.pinchMove |
//                                     InteractiveFlag.pinchZoom |
//                                     InteractiveFlag.doubleTapZoom),
//                         children: [
//                           // map loaded
//                           VectorTileLayer(
//                             theme: _style!.theme,
//                             backgroundTheme: _style!.theme.copyWith(types: {
//                               ThemeLayerType.background,
//                               ThemeLayerType.fill
//                             }),
//                             tileProviders: _style!.providers,
//                             fileCacheMaximumSizeInBytes: 256,
//                           ),

//                           // current user marker
//                           CurrentLocationLayer(
//                             style: LocationMarkerStyle(
//                               headingSectorColor: AppColors.primary,
//                               accuracyCircleColor:
//                                   AppColors.primary.withOpacity(0.2),
//                             ),
//                           ),

//                           // set selected marker
//                           selectedMarker != null
//                               ? MarkerLayer(
//                                   markers: [selectedMarker!],
//                                 )
//                               : SizedBox(),

//                           // set place marker
//                           StreamBuilder<QuerySnapshot>(
//                                   stream:
//                                       groupRef.collection('places').snapshots(),
//                                   builder: (context, AsyncSnapshot snapshot) {
//                                     if (!snapshot.hasData) {
//                                       return SizedBox();
//                                     }

//                                     final data = snapshot.data.data();
//                                     IconData icon = IconData(
//                                         int.parse('0x${data.docs[0]['sym']}}',
//                                             radix: 16),
//                                         fontFamily:
//                                             'MaterialIcons'); // Create an instance of IconData using the icon's name

//                                     return MarkerLayer(
//                                       markers: [
//                                         Marker(
//                                           point: LatLng(
//                                               data.docs[0]['loc'].latitude,
//                                               data.docs[0]['loc'].longitude),
//                                           builder: (context) {
//                                             return Icon(
//                                               icon,
//                                               color: AppColors.secondary,
//                                             );
//                                           },
//                                         )
//                                       ],
//                                     );
//                                   })
                       

//                           // set user marker
//                          StreamBuilder<QuerySnapshot>(
//                                   stream:
//                                       groupRef.collection('users').snapshots(),
//                                   builder: (context, AsyncSnapshot snapshot) {
//                                     if (!snapshot.hasData) {
//                                       return SizedBox();
//                                     }
//                                     final data = snapshot.data!.data();
//                                     return MarkerLayer(
//                                       markers: [
//                                         Marker(
//                                           width: 45,
//                                           height: 45,
//                                           point: LatLng(
//                                               data.docs[0]['loc'].latitude,
//                                               data.docs[0]['loc'].longitude),
//                                           builder: (context) {
//                                             return CircleAvatar(
//                                               backgroundColor:
//                                                   AppColors.neutralWhite,
//                                               child: Container(
//                                                 padding:
//                                                     const EdgeInsets.all(3),
//                                                 decoration: BoxDecoration(
//                                                     shape: BoxShape.circle,
//                                                     color: AppColors
//                                                         .foregroundLight,
//                                                     boxShadow: [
//                                                       BoxShadow(
//                                                         color: AppColors
//                                                             .neutralBlack
//                                                             .withOpacity(0.3),
//                                                         blurRadius: 3,
//                                                         offset: Offset(0, 3),
//                                                       )
//                                                     ]),
//                                                 child: CircleAvatar(
//                                                   foregroundImage: NetworkImage(
//                                                       data['avatar']),
//                                                 ),
//                                               ),
//                                             );
//                                           },
//                                         )
//                                       ],
//                                     );
//                                   })
                         
//                         ],
//                       ),

                      

//                       // set user indicator
//                       StreamBuilder<QuerySnapshot>(
//                               stream: groupRef
//                                   .collection('users')
//                                   .where('uid',
//                                       isNotEqualTo: FirebaseAuth
//                                           .instance.currentUser!.uid)
//                                   .snapshots(),
//                               builder: (context, AsyncSnapshot snapshot) {
//                                 if (!snapshot.hasData) {
//                                   return SizedBox();
//                                 }
//                                 var data = snapshot.data!.data();
//                                 return Stack(
//                                   fit: StackFit.expand,
//                                   children: [
//                                     // user indicator
//                                     indicator(
//                                       constraints: constraints,
//                                       target: LatLng(
//                                           data.docs[0]['loc'].latitude,
//                                           data.docs[0]['loc'].longitude),
//                                       backGroundColor: AppColors.primaryDarker,
//                                       child: CircleAvatar(
//                                         backgroundImage: NetworkImage(
//                                             data.docs[0]['avatar']),
//                                       ),
//                                     ),

//                                     // user indicator
//                                     indicator(
//                                       constraints: constraints,
//                                       target: LatLng(
//                                           data.docs[1]['loc'].latitude,
//                                           data.docs[1]['loc'].longitude),
//                                       backGroundColor: AppColors.primaryDarker,
//                                       child: CircleAvatar(
//                                         backgroundImage: NetworkImage(
//                                             data.docs[1]['avatar']),
//                                       ),
//                                     )
//                                   ],
//                                 );
//                               },
//                             )
                    
//                     ],
//                   ),
//       );
//     });
//   }

//   Widget indicator({
//     required BoxConstraints constraints,
//     required LatLng target,
//     Color? backGroundColor,
//     Widget? child,
//   }) {
//     bool targetFound = mapController.bounds!.contains(target);

//     double direction = calculateAngleBetweenPoints(
//       mapController.center.latitude,
//       mapController.center.longitude,
//       target.latitude,
//       target.longitude,
//     );

//     Offset screenPosition = getScreenPositionFromLatLng(
//       constraints.maxWidth,
//       constraints.maxHeight,
//       target,
//     );

//     return targetFound == false
//         ? Positioned(
//             top: screenPosition.dy < 0
//                 ? 0
//                 : screenPosition.dy > constraints.maxHeight - 74
//                     ? constraints.maxHeight - 74
//                     : screenPosition.dy,
//             left: screenPosition.dx < 0
//                 ? 0
//                 : screenPosition.dx > constraints.maxWidth - 74
//                     ? constraints.maxWidth - 74
//                     : screenPosition.dx,
//             child: Transform.rotate(
//               angle: radians(direction),
//               child: CustomPaint(
//                 painter: CircleArrowPainter(
//                   radius: 24,
//                   color: backGroundColor ?? AppColors.secondary,
//                 ),
//                 size: Size(74, 74),
//                 child: Padding(
//                   padding: EdgeInsets.all(17),
//                   child: Transform.rotate(
//                     angle: radians(direction) * -1,
//                     child: GestureDetector(
//                       onTap: () => animatedMapMove(
//                         target,
//                         mapController.zoom,
//                       ),
//                       child: CircleAvatar(
//                         radius: 20,
//                         backgroundColor: AppColors.foregroundLight,
//                         child: child ??
//                             Icon(
//                               Icons.location_pin,
//                               color: backGroundColor ?? AppColors.secondary,
//                             ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           )
//         : SizedBox();
//   }

//   double calculateDistance(lat1, lng1, lat2, lng2) {
//     var p = 0.017453292519943295;
//     var a = 0.5 -
//         cos((lat2 - lat1) * p) / 2 +
//         cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lng2 - lng1) * p)) / 2;
//     return 12742 * asin(sqrt(a));
//   }

//   double radians(double degrees) {
//     return degrees * pi / 180.0;
//   }

//   double degrees(double radians) {
//     return radians * 180.0 / pi;
//   }

//   double calculateAngleBetweenPoints(
//       double lat1, double lon1, double lat2, double lon2) {
//     // Convert latitude and longitude to radians
//     double lat1Rad = radians(lat1);
//     double lon1Rad = radians(lon1);
//     double lat2Rad = radians(lat2);
//     double lon2Rad = radians(lon2);

//     // Calculate difference in longitudes
//     double dLon = lon2Rad - lon1Rad;

//     // Calculate angle using atan2 function
//     double y = sin(dLon) * cos(lat2Rad);
//     double x =
//         cos(lat1Rad) * sin(lat2Rad) - sin(lat1Rad) * cos(lat2Rad) * cos(dLon);
//     double angle = atan2(y, x);

//     // Convert angle from radians to degrees
//     double angleInDegrees = degrees(angle);

//     // Normalize the angle to the range [0, 360)
//     angleInDegrees = (angleInDegrees + 360) % 360;

//     return angleInDegrees;
//   }

//   Offset getScreenPositionFromLatLng(
//     double width,
//     double height,
//     LatLng target,
//   ) {
//     final LatLngBounds bounds = mapController.bounds!;

//     // Get the dimensions of the screen
//     final Size screenSize = Size(width, height);

//     // Calculate the horizontal and vertical ratios
//     final double horizontalRatio =
//         (target.longitude - bounds.west) / (bounds.east - bounds.west);
//     final double verticalRatio =
//         (target.latitude - bounds.north) / (bounds.south - bounds.north);

//     // Calculate the on-screen position using the ratios and screen dimensions
//     final double screenX = screenSize.width * horizontalRatio;
//     final double screenY = screenSize.height * verticalRatio;

//     return Offset(screenX, screenY);
//   }

//   MarkPosition(LatLng point) {
//     setState(() {
//       selectedPosition = point;
//       selectedMarker = Marker(
//         point: point,
//         builder: (context) {
//           return Stack(
//             children: [
//               Positioned(
//                 bottom: 0,
//                 child: CustomPaint(
//                   painter: Painter(
//                     shape: Shape.Oval,
//                     color: AppColors.neutralBlack.withOpacity(0.2),
//                   ),
//                   size: Size(30, 7),
//                 ),
//               ),
//               Icon(
//                 Icons.location_pin,
//                 color: AppColors.secondary,
//                 size: 30,
//               ),
//             ],
//           );
//         },
//       );
//     });
//   }

//   animatedMapMove(LatLng destLocation, double destZoom) {
//     // Create some tweens. These serve to split up the transition from one location to another.
//     // In our case, we want to split the transition be<tween> our current map center and the destination.
//     _animationController = AnimationController(
//         duration: const Duration(milliseconds: 1000), vsync: this);
//     final latTween = Tween<double>(
//       begin: mapController.center.latitude,
//       end: destLocation.latitude,
//     );
//     final lngTween = Tween<double>(
//       begin: mapController.center.longitude,
//       end: destLocation.longitude,
//     );
//     final zoomTween = Tween<double>(
//       begin: mapController.zoom,
//       end: destZoom,
//     );

//     // Create a animation controller that has a duration and a TickerProvider.

//     // The animation determines what path the animation will take. You can try different Curves values, although I found
//     // fastOutSlowIn to be my favorite.
//     final Animation<double> animation = CurvedAnimation(
//         parent: _animationController, curve: Curves.fastOutSlowIn);

//     _animationController.addListener(() {
//       mapController.move(
//           LatLng(latTween.evaluate(animation), lngTween.evaluate(animation)),
//           zoomTween.evaluate(animation));
//     });

//     animation.addStatusListener((status) {
//       if (status == AnimationStatus.completed) {
//         _animationController.dispose();
//       } else if (status == AnimationStatus.dismissed) {
//         _animationController.dispose();
//       }
//     });

//     _animationController.forward();
//   }

//   readMapStyle() {
//     return StyleReader(
//       uri: 'https://api.maptiler.com/maps/dataviz/style.json?key={key}',
//       // ignore: undefined_identifier
//       apiKey: 'GYjvqfTPK2UOJxucQu3O',
//       logger: const Logger.console(),
//     ).read();
//   }

//   Future<bool> handleLocationPermission() async {
//     bool isMapPrepared = false;
//     bool serviceEnabled;
//     LocationPermission permission;

//     serviceEnabled = await Geolocator.isLocationServiceEnabled();

//     if (!serviceEnabled) {
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//           content: Text(
//               'Location services are disabled. Please enable the services')));
//       return false;
//     }
//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Location permissions are denied')));
//         return false;
//       }
//     }
//     if (permission == LocationPermission.deniedForever) {
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//           content: Text(
//               'Location permissions are permanently denied, we cannot request permissions.')));
//       return false;
//     }

//     return true;
//   }
// }

// class CircleArrowPainter extends CustomPainter {
//   final double radius;
//   final Color color;

//   CircleArrowPainter({
//     required this.radius,
//     required this.color,
//   });

//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()..color = color;
//     final center = Offset(size.width / 2, size.height / 2);
//     final halfWidth = size.width / 2;

//     final path = Path()
//       ..moveTo(halfWidth, 0)
//       ..lineTo(halfWidth + 15, 15)
//       ..quadraticBezierTo(halfWidth, 5, halfWidth - 15, 15)
//       ..close();

//     canvas.drawCircle(center, radius, paint);
//     canvas.drawPath(path, paint);
//   }

//   @override
//   bool shouldRepaint(covariant CircleArrowPainter oldDelegate) {
//     return oldDelegate.radius != radius || oldDelegate.color != color;
//   }
// }
