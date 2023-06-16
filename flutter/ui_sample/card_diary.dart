import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jointheway/shared/colors.dart';
import 'package:jointheway/shared/text_styles.dart';
import 'package:jointheway/widgets/buttons.dart';

class DiaryCard extends StatelessWidget {
  final String created_by;
  final String desc;
  final List timelines;
  const DiaryCard(
      {required this.created_by, required this.desc, required this.timelines});

  @override
  Widget build(BuildContext context) {
    return Container(
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
                Flexible(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Stack(
                        alignment: AlignmentDirectional.bottomEnd,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: AvatarButton(
                              backgroundColor: AppColors.primary,
                              radius: 44,
                            ),
                          ),
                          AvatarButton(
                            backgroundColor: AppColors.secondary,
                            radius: 26,
                          )
                        ],
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InkWell(
                                child: Text(
                                  "${created_by}",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyles.titleT2
                                      .copyWith(color: AppColors.primary),
                                ),
                                onTap: (() => print('Display Name check')),
                              ),
                              RichText(
                                overflow: TextOverflow.ellipsis,
                                text: TextSpan(
                                  children: [
                                    WidgetSpan(
                                      child: Icon(
                                        Icons.group,
                                        color: AppColors.secondary,
                                        size: 18,
                                      ),
                                    ),
                                    WidgetSpan(child: SizedBox(width: 5)),
                                    TextSpan(
                                      text: '${created_by}',
                                      style: TextStyles.titleT1
                                          .copyWith(color: AppColors.secondary),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                MyButton(
                    text: 'เข้าร่วม',
                    xPadding: 20,
                    borderColor: AppColors.secondary,
                    color: Colors.transparent,
                    textStyle: TextStyles.buttonBtn2
                        .copyWith(color: AppColors.secondary),
                    onTap: () => print('Join')),
              ],
            ),
            const SizedBox(height: 15),
            Container(
                width: MediaQuery.of(context).size.width,
                child: Text("${desc}",
                    style: TextStyles.bodyB2.copyWith(
                      color: AppColors.textDark,
                    ))),
            const SizedBox(height: 15),

            //Timelines
            Container(
                alignment: AlignmentDirectional.topStart,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    color: AppColors.foregroundLight),
                child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: timelines.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: ((context, index) {
                      return TimelineItem(timelines[index]);
                    }))),
            const SizedBox(height: 20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                height: 160,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: InkWell(
                        child: ClipRect(
                          child: Image(
                            image: AssetImage('assets/images/leo.jpg'),
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: InkWell(
                        child: ClipRect(
                          child: Image(
                            image: AssetImage('assets/images/leo.jpg'),
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: InkWell(
                        child: ClipRect(
                          child: Image(
                            image: AssetImage('assets/images/leo.jpg'),
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  MyIconButton(
                      icon: Icons.thumb_up_alt_outlined,
                      size: 28,
                      color: AppColors.secondary,
                      onTap: () => print('Action')),
                  const SizedBox(width: 15),
                  MyIconButton(
                      icon: Icons.bookmark_border_outlined,
                      size: 28,
                      color: AppColors.secondary,
                      onTap: () => print('Action')),
                  const SizedBox(width: 15),
                  MyIconButton(
                      icon: Icons.my_location,
                      size: 28,
                      color: AppColors.secondary,
                      onTap: () => print('Action')),
                ],
              ),
            )
          ],
        ),
      ),
    );
    ;
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
                          text: '${timeline['sub_addr']}',
                          style: TextStyles.bodyB1
                              .copyWith(color: AppColors.neutralGrey500)),
                      WidgetSpan(
                          child: const SizedBox(
                        width: 5,
                      )),
                      TextSpan(
                          text: '${timeline['place']}',
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
