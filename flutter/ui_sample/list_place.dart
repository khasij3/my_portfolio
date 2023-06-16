import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jointheway/screens/select_group.dart';
import 'package:jointheway/shared/colors.dart';
import 'package:jointheway/shared/text_styles.dart';
import 'package:jointheway/widgets/buttons.dart';
import 'package:jointheway/widgets/map_screen.dart';
import 'package:latlong2/latlong.dart';

import '../screens/map_show.dart';

class PlaceList extends StatefulWidget {
  final String title;
  final String desc;
  final GeoPoint loc;
  final List? pics;
  final bool selected;
  final Function()? onTap;

  PlaceList({
    required this.title,
    required this.desc,
    required this.loc,
    this.pics,
    required this.selected,
    this.onTap,
  });

  @override
  State<PlaceList> createState() => _PlaceListState();
}

class _PlaceListState extends State<PlaceList> {
  bool mapVisible = false;
  @override
  void initState() {
    // getUserPic();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double lat = widget.loc.latitude;
    double lng = widget.loc.longitude;
    LatLng initPostion = LatLng(lat, lng);

    return InkWell(
      onTap: widget.onTap,
      child: Stack(
        children: [
          Container(
            color: widget.selected
                ? AppColors.neutralGrey100
                : AppColors.neutralWhite,
            padding: EdgeInsets.all(15),
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      WidgetSpan(
                        alignment: PlaceholderAlignment.bottom,
                        child: Icon(
                          Icons.pin_drop_rounded,
                          color: AppColors.primary,
                          size: 20,
                        ),
                      ),
                      WidgetSpan(
                        child: SizedBox(width: 2),
                      ),
                      TextSpan(
                        style: TextStyles.titleT3
                            .copyWith(color: AppColors.primary),
                        text: widget.title,
                      ),
                      WidgetSpan(
                        child: SizedBox(width: 15),
                      ),
                      !widget.selected
                          ? TextSpan(
                              style: TextStyles.subtitleS2
                                  .copyWith(color: AppColors.neutralGrey500),
                              text:
                                  "(${lat.toStringAsFixed(6)}, ${lng.toStringAsFixed(6)})",
                            )
                          : WidgetSpan(
                              child: SizedBox(),
                            ),
                    ],
                  ),
                ),
                widget.selected
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          //description
                          RichText(
                            overflow: TextOverflow.clip,
                            text: TextSpan(
                              style: TextStyles.bodyB2
                                  .copyWith(color: AppColors.textDark),
                              text: widget.desc,
                            ),
                          ),
                          const SizedBox(height: 10),
                          //preview
                          Container(
                            height: 100,
                            child: ListView.builder(
                                physics: BouncingScrollPhysics(),
                                itemCount: widget.pics!.length + 1,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return index == 0
                                      //map
                                      ? Container(
                                          margin: EdgeInsets.only(right: 10),
                                          width: 170,
                                          child: Stack(
                                            children: [
                                              mapVisible == true
                                                  ? Material(
                                                      child: InkWell(
                                                        onTap: () {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder:
                                                                  ((context) =>
                                                                      MapShowPage(
                                                                        initPosition:
                                                                            initPostion,
                                                                      )),
                                                            ),
                                                          );
                                                        },
                                                        child: Ink(
                                                          child: Stack(
                                                            children: [
                                                              MapScreen(
                                                                initPosition:
                                                                    initPostion,
                                                                interactive:
                                                                    false,
                                                              ),
                                                              Container(
                                                                color: Colors
                                                                    .transparent,
                                                                width: double
                                                                    .infinity,
                                                                height: double
                                                                    .infinity,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  : Material(
                                                      child: InkWell(
                                                        onTap: () =>
                                                            setState(() {
                                                          mapVisible = true;
                                                        }),
                                                        child: Ink(
                                                          width: 170,
                                                          height: 100,
                                                          color: AppColors
                                                              .neutralGrey300,
                                                          child: Icon(
                                                            Icons
                                                                .remove_red_eye,
                                                            color: AppColors
                                                                .neutralWhite,
                                                            size: 38,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                              Positioned.fill(
                                                child: Container(
                                                  alignment:
                                                      Alignment.bottomCenter,
                                                  child: Text(
                                                    "${lat.toStringAsFixed(6)}, ${lng.toStringAsFixed(6)}",
                                                    style: TextStyles.titleT0
                                                        .copyWith(
                                                            color: AppColors
                                                                .neutralGrey500),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      //pictures
                                      : Container(
                                          margin: index == widget.pics!.length
                                              ? EdgeInsets.zero
                                              : EdgeInsets.only(right: 10),
                                          child: InkWell(
                                            child: ClipRect(
                                              child: Image(
                                                image: NetworkImage(
                                                    widget.pics![index - 1]),
                                                fit: BoxFit.fitHeight,
                                              ),
                                            ),
                                          ),
                                        );
                                }),
                          ),
                        ],
                      )
                    : SizedBox(),
              ],
            ),
          ),
          widget.selected
              ? Positioned(
                  top: 15,
                  right: 15,
                  child: Icon(
                    Icons.check_circle,
                    color: AppColors.primary,
                  ),
                )
              : SizedBox(),
        ],
      ),
    );
  }

  // getUserPic() async {
  //   var user = FirebaseFirestore.instance.collection('users');

  //   for (int i = 0; i < widget.users.length; i++) {
  //     DocumentSnapshot snapshot = await user.doc(widget.users[i]['user']).get();
  //     widget.users[i]['d_pic'] = snapshot['d_pic'];
  //   }
  // }
}
