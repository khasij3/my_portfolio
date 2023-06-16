import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:jointheway/widgets/buttons.dart';
import 'package:latlong2/latlong.dart' hide Path;
import 'dart:math';

import '../shared/colors.dart';

class LocationIndicator extends StatefulWidget {
  final Position targetPosition;

  final Stream<Map> positionStream;
  final BoxConstraints constraints;
  final Function()? onTap;

  LocationIndicator({
    required this.targetPosition,
    required this.positionStream,
    required this.constraints,
    this.onTap,
  });

  @override
  State<LocationIndicator> createState() => _LocationIndicatorState();
}

class _LocationIndicatorState extends State<LocationIndicator> {
  @override
  void initState() {
    super.initState();

    // _initStream();
  }

  // _initStream() {
  //   Timer.periodic(Duration(seconds: 1), (timer) {
  //     LatLng targetPosition = LatLng(
  //         widget.targetPosition.latitude, widget.targetPosition.longitude);

  //     double direction = calculateAngleBetweenPoints(
  //       widget.mapController.center.latitude,
  //       widget.mapController.center.longitude,
  //       targetPosition.latitude,
  //       targetPosition.longitude,
  //     );

  //     Map<String, dynamic> data = {
  //       'direction': direction,
  //       'targetPosition': targetPosition,
  //       'bounds': widget.mapController.bounds,
  //     };
  //     _streamController.add(data);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Map>(
        stream: widget.positionStream,
        builder: (context, AsyncSnapshot<Map> snapshot) {
          if (!snapshot.hasData) {
            return SizedBox();
          }
          Map data = snapshot.data!;

          double direction = calculateAngleBetweenPoints(
            data['focus'],
            data['target'],
          );

          Offset screenPosition = setScreenPosition(
            widget.constraints,
            data['target'],
            data['north'],
            data['east'],
            data['west'],
            data['south'],
          );

          return Positioned(
            top: screenPosition.dy < 0
                ? 0
                : screenPosition.dy > widget.constraints.maxHeight - 74
                    ? widget.constraints.maxHeight - 74
                    : screenPosition.dy,
            left: screenPosition.dx < 0
                ? 0
                : screenPosition.dx > widget.constraints.maxWidth - 74
                    ? widget.constraints.maxWidth - 74
                    : screenPosition.dx,
            child: Stack(
              children: [
                Transform.rotate(
                  angle: direction,
                  child: CustomPaint(
                    painter: CircleArrowPainter(
                      radius: 24,
                      color: AppColors.secondaryLighter,
                    ),
                    size: Size(74, 74),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(17),
                  child: AvatarButton(
                    onTap: widget.onTap,
                    radius: 20,
                    backgroundColor: AppColors.foregroundSecondary,
                    child: Icon(
                      Icons.my_location,
                      color: AppColors.secondary,
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }

  double radians(double degrees) {
    return degrees * pi / 180.0;
  }

  double degrees(double radians) {
    return radians * 180.0 / pi;
  }

  double calculateAngleBetweenPoints(LatLng position1, LatLng position2) {
    // Convert latitude and longitude to radians
    double lat1Rad = radians(position1.latitude);
    double lon1Rad = radians(position1.longitude);
    double lat2Rad = radians(position2.latitude);
    double lon2Rad = radians(position2.longitude);

    // Calculate difference in longitudes
    double dLon = lon2Rad - lon1Rad;

    // Calculate angle using atan2 function
    double y = sin(dLon) * cos(lat2Rad);
    double x =
        cos(lat1Rad) * sin(lat2Rad) - sin(lat1Rad) * cos(lat2Rad) * cos(dLon);
    double angle = atan2(y, x);

    // Convert angle from radians to degrees
    double angleInDegrees = degrees(angle);

    // Normalize the angle to the range [0, 360)
    angleInDegrees = (angleInDegrees + 360) % 360;

    return angleInDegrees;
  }

  Offset setScreenPosition(
    BoxConstraints constraints,
    LatLng target,
    double north,
    double east,
    double west,
    double south,
  ) {
    // Get the dimensions of the screen
    final Size screenSize = Size(constraints.maxWidth, constraints.maxHeight);

    // Calculate the horizontal and vertical ratios
    final double horizontalRatio = (target.longitude - west) / (east - west);
    final double verticalRatio = (target.latitude - north) / (south - north);

    // Calculate the on-screen position using the ratios and screen dimensions
    final double screenX = screenSize.width * horizontalRatio;
    final double screenY = screenSize.height * verticalRatio;

    return Offset(screenX, screenY);
  }
}

class CircleArrowPainter extends CustomPainter {
  final double radius;
  final Color color;

  CircleArrowPainter({
    required this.radius,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final center = Offset(size.width / 2, size.height / 2);
    final halfWidth = size.width / 2;

    final path = Path()
      ..moveTo(halfWidth, 0)
      ..lineTo(halfWidth + 15, 15)
      ..quadraticBezierTo(halfWidth, 5, halfWidth - 15, 15)
      ..close();

    canvas.drawCircle(center, radius, paint);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CircleArrowPainter oldDelegate) {
    return oldDelegate.radius != radius || oldDelegate.color != color;
  }
}
