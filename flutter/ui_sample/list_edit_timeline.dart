import 'package:buddhist_datetime_dateformat_sns/buddhist_datetime_dateformat_sns.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jointheway/widgets/buttons.dart';

import '../shared/colors.dart';
import '../shared/text_styles.dart';

class EditTimeline extends StatefulWidget {
  final Map timeline;

  const EditTimeline(this.timeline);

  @override
  State<EditTimeline> createState() => _EditTimelinesState();
}

class _EditTimelinesState extends State<EditTimeline> {
  @override
  Widget build(BuildContext context) {
    DateTime date_time = widget.timeline['date_time'];

    String latFormat = widget.timeline['loc'].latitude.toStringAsFixed(6);
    String lngFormat = widget.timeline['loc'].longitude.toStringAsFixed(6);
    String time = DateFormat('H:mm น.').format(date_time);
    String date = DateFormat("d MMM y").formatInBuddhistCalendarThai(date_time);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 80,
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
                    color: AppColors.neutralGrey500,
                    width: 36,
                  )),
              MyIconButton(
                  icon: Icons.remove_circle,
                  color: AppColors.statusError,
                  onTap: () => Text("remove timeline")),
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
                        text: '${widget.timeline['desc']}')),
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
                          text: '${widget.timeline['sub_addr']}',
                          style: TextStyles.bodyB1
                              .copyWith(color: AppColors.neutralGrey500)),
                      WidgetSpan(
                          child: const SizedBox(
                        width: 5,
                      )),
                      TextSpan(
                          text: widget.timeline['place'] != null
                              ? widget.timeline['place']['title']
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
