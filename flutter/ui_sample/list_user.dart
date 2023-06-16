import 'package:flutter/material.dart';
import 'package:jointheway/shared/colors.dart';
import 'package:jointheway/shared/text_styles.dart';
import 'package:jointheway/widgets/buttons.dart';

class UserList extends StatefulWidget {
  final String? imageUrl;
  final String displayName;
  final String username;
  final String uniqueKey;
  final Function()? onTap;
  final bool selected;

  const UserList({
    super.key,
    required this.displayName,
    required this.username,
    required this.uniqueKey,
    this.imageUrl,
    required this.selected,
    this.onTap,
  });

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        color: widget.selected
            ? AppColors.foregroundLight
            : AppColors.neutralWhite,
        padding: EdgeInsets.all(15),
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                widget.imageUrl == ""
                    ? AvatarButton(
                        child: Text(widget.displayName.substring(0, 1),
                            style: TextStyles.displayD3
                                .copyWith(color: AppColors.primaryDarker)),
                        backgroundColor: AppColors.primaryLighter,
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
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.displayName,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyles.titleT2
                            .copyWith(color: AppColors.primary),
                      ),
                      RichText(
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: widget.username,
                              style: TextStyles.titleT1
                                  .copyWith(color: AppColors.secondary),
                            ),
                            WidgetSpan(child: SizedBox(width: 5)),
                            TextSpan(
                              text: "#${widget.uniqueKey}",
                              style: TextStyles.titleT1
                                  .copyWith(color: AppColors.neutralGrey500),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            widget.selected
                ? Container(
                    padding: EdgeInsets.only(right: 15),
                    child: Icon(
                      Icons.check_circle,
                      color: AppColors.primary,
                    ),
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}
