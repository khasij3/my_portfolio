import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jointheway/shared/colors.dart';
import 'package:jointheway/shared/text_styles.dart';
import 'package:jointheway/widgets/buttons.dart';

import 'package:jointheway/services/user.dart';
import 'package:jointheway/services/group.dart';

import '../services/firebase.dart';

class PlanCard extends StatefulWidget {
  final String title;
  final String created_by;
  final String desc;
  final List timelines;

  final List pics;
  const PlanCard({
    required this.created_by,
    required this.desc,
    required this.timelines,
    required this.title,
    required this.pics,
  });

  @override
  State<PlanCard> createState() => _PlanCardState();
}

class _PlanCardState extends State<PlanCard> {
  UserService _user = UserService();
  FirebaseService _firebase = FirebaseService();

  Map planer = {};
  Map group = {};

  @override
  void initState() {
    super.initState();
    //Fetch author

    fetchData();
  }

  Future fetchData() async {
    if (!mounted) return;

    planer = await _user.getUser(widget.created_by);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return group.isEmpty && planer.isEmpty
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Container(
            padding: EdgeInsets.only(top: 10),
            child: Container(
              color: AppColors.neutralWhite,
              padding: EdgeInsets.all(15),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // title
                      Flexible(
                        child: RichText(
                          text: TextSpan(
                            style: TextStyles.titleT2.copyWith(
                              color: AppColors.primary,
                            ),
                            children: [
                              WidgetSpan(
                                child: Icon(
                                  Icons.event_note,
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
                        text: 'เข้าร่วม',
                        xPadding: 20,
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
                        image: NetworkImage(planer['d_pic']),
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
                              Text("Planned by",
                                  style: TextStyles.subtitleS1.copyWith(
                                      color: AppColors.neutralGrey500)),
                              InkWell(
                                child: Text(
                                  "${planer['d_name']}",
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
                  !widget.desc.isEmpty
                      ? Container(
                          margin: EdgeInsets.symmetric(vertical: 15),
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                            "${widget.desc}",
                            style: TextStyles.bodyB2.copyWith(
                              color: AppColors.textDark,
                            ),
                          ),
                        )
                      : const SizedBox(height: 15),

                  //Timelines
                  Container(
                      alignment: AlignmentDirectional.topStart,
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          color: AppColors.foregroundLight),
                      child: ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: widget.timelines.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: ((context, index) {
                            return TimelineItem(widget.timelines[index]);
                          }))),
                  const SizedBox(height: 20),

                  //preview
                  widget.pics.isEmpty
                      ? SizedBox()
                      : Container(
                          height: 100,
                          child: ListView.builder(
                              physics: BouncingScrollPhysics(),
                              itemCount: widget.pics.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: index == widget.pics.length
                                      ? EdgeInsets.zero
                                      : EdgeInsets.only(right: 10),
                                  child: InkWell(
                                    child: ClipRect(
                                      child: Image(
                                        image: NetworkImage(widget.pics[index]),
                                        fit: BoxFit.fitHeight,
                                      ),
                                    ),
                                  ),
                                );
                              })),
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
                                  Icons.group,
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
            ),
          );
  }
}

class TimelineItem extends StatelessWidget {
  final Map timeline;

  const TimelineItem(this.timeline);

  @override
  Widget build(BuildContext context) {
    DateTime date_time = timeline['date_time'].toDate();
    String time = DateFormat("hh:mm").format(date_time);
    String date = DateFormat("dd-MM-yyyy").format(date_time);

    String latFormat = timeline['loc'].latitude.toStringAsFixed(6);
    String lngFormat = timeline['loc'].longitude.toStringAsFixed(6);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 70,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                RichText(
                    textAlign: TextAlign.start,
                    text: TextSpan(
                        text: "${time}",
                        style: TextStyles.bodyB2
                            .copyWith(color: AppColors.textDark))),
                RichText(
                    textAlign: TextAlign.start,
                    text: TextSpan(
                        text: '${date}',
                        style: TextStyles.bodyB1
                            .copyWith(color: AppColors.textDark))),
              ],
            ),
          ),
          Stack(
            alignment: AlignmentDirectional.topCenter,
            children: [
              Container(
                  padding: EdgeInsets.only(top: 24),
                  child: VerticalDivider(
                    thickness: 2,
                    color: AppColors.secondary,
                    width: 36,
                  )),
              Padding(
                padding: const EdgeInsets.only(top: 3),
                child: Icon(
                  Icons.circle,
                  color: AppColors.secondary,
                  size: 18,
                ),
              ),
            ],
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                    overflow: TextOverflow.clip,
                    textAlign: TextAlign.start,
                    text: TextSpan(
                        style: TextStyles.bodyB2
                            .copyWith(color: AppColors.textDark),
                        text: '${timeline['desc']}')),
                const SizedBox(height: 5),
                RichText(
                    overflow: TextOverflow.clip,
                    textAlign: TextAlign.start,
                    text: TextSpan(children: [
                      WidgetSpan(
                          alignment: PlaceholderAlignment.top,
                          child: Icon(
                            Icons.location_pin,
                            size: 16,
                            color: AppColors.neutralGrey500,
                          )),
                      TextSpan(
                          text: timeline['sub_addr'],
                          style: TextStyles.bodyB1
                              .copyWith(color: AppColors.neutralGrey500)),
                      WidgetSpan(
                          child: const SizedBox(
                        width: 5,
                      )),
                      TextSpan(
                          text: !timeline['place'].isEmpty
                              ? timeline['place']['title']
                              : "$latFormat, $lngFormat",
                          style: TextStyles.bodyB1
                              .copyWith(color: AppColors.primary)),
                    ])),
                const SizedBox(height: 20)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
