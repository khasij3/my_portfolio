import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:jointheway/widgets/buttons.dart';

import '../shared/colors.dart';
import '../shared/text_styles.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;
  final bool? backButton;
  final List<Widget>? actions;

  const MyAppBar({super.key, this.title, this.backButton, this.actions});

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.primary,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: AppColors.primary,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
      ),
      title: title ?? null,
      titleTextStyle: TextStyles.displayD2,
      centerTitle: true,
      elevation: 0,
      leading: backButton == true
          ? Align(
              heightFactor: 1,
              widthFactor: 1,
              child: MyIconButton(
                color: AppColors.neutralWhite,
                icon: Icons.west,
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            )
          : null,
      actions: actions ?? [],
    );
  }
}
