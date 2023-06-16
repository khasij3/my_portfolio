import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jointheway/screens/select_group.dart';
import 'package:jointheway/shared/colors.dart';
import 'package:jointheway/shared/text_styles.dart';
import 'package:jointheway/widgets/buttons.dart';

class GroupList extends StatefulWidget {
  final String name;
  final String desc;
  final List users;
  final bool selected;
  final Function()? onTap;

  final String? imageUrl;

  GroupList({
    required this.name,
    required this.users,
    this.imageUrl,
    required this.desc,
    required this.selected,
    this.onTap,
  });

  @override
  State<GroupList> createState() => _GroupListState();
}

class _GroupListState extends State<GroupList> {
  @override
  void initState() {
    // getUserPic();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int numUsers = widget.users.length;

    return InkWell(
      onTap: widget.onTap,
      child: Container(
        color: widget.selected
            ? AppColors.foregroundLight
            : AppColors.neutralWhite,
        padding: EdgeInsets.all(15),
        width: MediaQuery.of(context).size.width,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              widget.imageUrl == ""
                  ? AvatarButton(
                      child: Text(widget.name.substring(0, 1),
                          style: TextStyles.displayD3
                              .copyWith(color: AppColors.primaryDarker)),
                      backgroundColor: AppColors.foregroundPrimary,
                      radius: 26,
                    )
                  : AvatarButton(
                      image: NetworkImage(widget.imageUrl!),
                      backgroundColor: AppColors.foregroundPrimary,
                      radius: 26,
                    ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.name,
                      overflow: TextOverflow.ellipsis,
                      style:
                          TextStyles.titleT2.copyWith(color: AppColors.primary),
                    ),
                    !widget.selected && widget.desc == ""
                        ? SizedBox()
                        : RichText(
                            overflow: TextOverflow.clip,
                            text: TextSpan(
                                style: TextStyles.bodyB2
                                    .copyWith(color: AppColors.textDark),
                                text: widget.desc),
                          ),
                    widget.selected
                        ? SizedBox()
                        : RichText(
                            overflow: TextOverflow.ellipsis,
                            text: TextSpan(
                              children: [
                                WidgetSpan(
                                  child: Icon(
                                    Icons.person,
                                    color: AppColors.neutralGrey500,
                                    size: 18,
                                  ),
                                ),
                                WidgetSpan(child: SizedBox(width: 5)),
                                TextSpan(
                                  text: numUsers > 1
                                      ? "$numUsers Members"
                                      : "1 Member",
                                  style: TextStyles.titleT1.copyWith(
                                      color: AppColors.neutralGrey500),
                                )
                              ],
                            ),
                          ),
                    !widget.selected
                        ? SizedBox()
                        : Container(
                            margin: EdgeInsets.only(top: 10),
                            height: 30,
                            child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: numUsers,
                              itemBuilder: ((context, index) {
                                return Align(
                                  widthFactor: 0.7,
                                  child: AvatarButton(
                                    image: NetworkImage(
                                        widget.users[index]['d_pic']),
                                    backgroundColor: AppColors.foregroundLight,
                                  ),
                                );
                              }),
                            ),
                          )
                  ],
                ),
              ),
              widget.selected
                  ? Container(
                      padding: EdgeInsets.only(top: 15, right: 15),
                      child: Icon(
                        Icons.check_circle,
                        color: AppColors.primary,
                      ),
                    )
                  : SizedBox(),
            ],
          ),
        ),
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
