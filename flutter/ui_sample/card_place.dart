import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jointheway/screens/map_show.dart';
import 'package:jointheway/services/user.dart';
import 'package:latlong2/latlong.dart';
import 'package:intl/intl.dart';
import 'package:jointheway/shared/colors.dart';
import 'package:jointheway/shared/text_styles.dart';
import 'package:jointheway/widgets/buttons.dart';
import 'package:jointheway/widgets/map_screen.dart';

class PlaceCard extends StatefulWidget {
  final String title;
  final String created_by;
  final String desc;
  final GeoPoint loc;
  final List? pics;
  const PlaceCard({
    required this.title,
    required this.created_by,
    required this.desc,
    required this.loc,
    this.pics,
  });

  @override
  State<PlaceCard> createState() => _PlaceCardState();
}

class _PlaceCardState extends State<PlaceCard> {
  UserService userService = UserService();
  Map author = {};

  bool mapVisible = false;

  @override
  void initState() {
    super.initState();
    //Fetch author
    fetchUser();
  }

  Future fetchUser() async {
    if (!mounted) return;

    author = await userService.getUser(widget.created_by);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double lat = widget.loc.latitude;
    double lng = widget.loc.longitude;
    LatLng initPostion = LatLng(lat, lng);

    return author.isEmpty
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Container(
            color: AppColors.neutralWhite,
            margin: EdgeInsets.only(top: 10),
            padding: EdgeInsets.all(15),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //title
                    Flexible(
                      child: RichText(
                        text: TextSpan(
                          style: TextStyles.titleT2.copyWith(
                            color: AppColors.primary,
                          ),
                          children: [
                            WidgetSpan(
                              child: Icon(
                                Icons.location_on_rounded,
                                color: AppColors.primary,
                              ),
                            ),
                            WidgetSpan(
                              child: SizedBox(width: 5),
                            ),
                            TextSpan(
                              text: widget.title,
                            ),
                          ],
                        ),
                      ),
                    ),
                    MyButton(
                      text: "บันทึก",
                      icon: Icon(
                        Icons.bookmark_border,
                        color: AppColors.secondary,
                        size: 18,
                      ),
                      xPadding: 10,
                      circularRadius: 20,
                      borderColor: AppColors.secondary,
                      color: Colors.transparent,
                      textStyle: TextStyles.buttonBtn2
                          .copyWith(color: AppColors.secondary),
                      onTap: () => print('Join'),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                //profile
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    AvatarButton(
                      image: NetworkImage(author['d_pic']),
                      borderSize: 4,
                      backgroundColor: AppColors.secondary,
                      radius: 16,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Pinned by",
                                style: TextStyles.subtitleS1
                                    .copyWith(color: AppColors.neutralGrey500)),
                            InkWell(
                              child: Text(
                                "${author['d_name']}",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyles.subtitleS2
                                    .copyWith(color: AppColors.secondary),
                              ),
                              onTap: (() => print('Display Name check')),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),

                //description
                widget.desc == ""
                    ? SizedBox()
                    : Container(
                        margin: EdgeInsets.only(top: 15),
                        width: MediaQuery.of(context).size.width,
                        child: RichText(
                          text: TextSpan(
                            text: widget.desc,
                            style: TextStyles.bodyB2.copyWith(
                              color: AppColors.textDark,
                            ),
                          ),
                        ),
                      ),
                const SizedBox(height: 15),

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
                                                    builder: ((context) =>
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
                                                      initPosition: initPostion,
                                                      interactive: false,
                                                    ),
                                                    Container(
                                                      color: Colors.transparent,
                                                      width: double.infinity,
                                                      height: double.infinity,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          )
                                        : Material(
                                            child: InkWell(
                                              onTap: () => setState(() {
                                                mapVisible = true;
                                              }),
                                              child: Ink(
                                                width: 170,
                                                height: 100,
                                                color: AppColors.neutralGrey300,
                                                child: Icon(
                                                  Icons.remove_red_eye,
                                                  color: AppColors.neutralWhite,
                                                  size: 38,
                                                ),
                                              ),
                                            ),
                                          ),
                                    Positioned.fill(
                                      child: Container(
                                        alignment: Alignment.bottomCenter,
                                        child: Text(
                                          "${lat.toStringAsFixed(6)}, ${lng.toStringAsFixed(6)}",
                                          style: TextStyles.titleT0.copyWith(
                                              color: AppColors.neutralGrey500),
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
                                      image:
                                          NetworkImage(widget.pics![index - 1]),
                                      fit: BoxFit.fitHeight,
                                    ),
                                  ),
                                ),
                              );
                      }),
                ),
                const SizedBox(height: 20),

                //status
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      RichText(
                        text: TextSpan(
                          style: TextStyles.subtitleS2.copyWith(
                            color: AppColors.neutralGrey500,
                          ),
                          children: [
                            WidgetSpan(
                              child: Icon(
                                Icons.bookmark,
                                color: AppColors.neutralGrey500,
                                size: 18,
                              ),
                            ),
                            WidgetSpan(
                              child: SizedBox(width: 3),
                            ),
                            TextSpan(
                              text: "2,000",
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 15),
                      RichText(
                        text: TextSpan(
                          style: TextStyles.subtitleS2.copyWith(
                            color: AppColors.neutralGrey500,
                          ),
                          children: [
                            WidgetSpan(
                              child: Icon(
                                Icons.remove_red_eye,
                                color: AppColors.neutralGrey500,
                                size: 18,
                              ),
                            ),
                            WidgetSpan(
                              child: SizedBox(width: 3),
                            ),
                            TextSpan(
                              text: "2,000",
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
  }
}
