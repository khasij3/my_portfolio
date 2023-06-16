import 'package:flutter/material.dart';
import 'package:jointheway/shared/colors.dart';
import 'package:jointheway/shared/text_styles.dart';

class SigninWithButton extends StatelessWidget {
  final AssetImage image;
  final Color color;
  final Function() onTap;

  const SigninWithButton(
      {required this.image, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.all(Radius.circular(16)),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      spreadRadius: 0,
                      blurRadius: 3,
                      offset: Offset(0, 4))
                ]),
            padding: EdgeInsets.all(15),
            child: Image(image: image, fit: BoxFit.contain),
          ),
          borderRadius: BorderRadius.all(Radius.circular(16)),
          onTap: onTap),
    );
  }
}

class MyButton extends StatelessWidget {
  final String text;
  final double? width;
  final double? height;
  final double? circularRadius;
  final Icon? icon;
  final double? xPadding;
  final double? yPadding;
  final Color? color;
  final Color? borderColor;
  final double? borderWidth;
  final TextStyle? textStyle;
  final Function() onTap;

  const MyButton({
    required this.text,
    this.icon,
    this.xPadding,
    this.yPadding,
    this.color,
    this.borderColor,
    this.borderWidth,
    this.textStyle,
    required this.onTap,
    this.width,
    this.height,
    this.circularRadius,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
            borderRadius:
                BorderRadius.all(Radius.circular(circularRadius ?? 15)),
            child: Ink(
              width: width ?? null,
              height: height ?? null,
              decoration: BoxDecoration(
                  border: Border.all(
                      width: borderColor == null ? 0 : borderWidth ?? 2.0,
                      color: borderColor ?? Colors.transparent),
                  borderRadius:
                      BorderRadius.all(Radius.circular(circularRadius ?? 15)),
                  color:
                      borderColor == null ? color ?? AppColors.primary : null),
              padding: EdgeInsets.symmetric(
                  horizontal: xPadding ?? 10, vertical: yPadding ?? 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  icon != null
                      ? Container(
                          margin: EdgeInsets.only(right: 5),
                          child: icon,
                        )
                      : Container(),
                  Text(text,
                      style: textStyle ??
                          TextStyles.buttonBtn2.copyWith(
                            color: borderColor == null
                                ? AppColors.neutralWhite
                                : borderColor,
                          )),
                ],
              ),
            ),
            onTap: onTap),
      ),
    );
  }
}

class MyIconButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double? size;
  final String? label;
  final bool? leadingLabel;
  final Function() onTap;

  MyIconButton(
      {required this.icon,
      required this.color,
      this.size,
      this.label,
      this.leadingLabel,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    bool leading = leadingLabel ?? false;
    return Align(
      heightFactor: 1,
      widthFactor: 1,
      child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            borderRadius: BorderRadius.all(Radius.circular(30)),
            child: label != null && leading
                ? Row(
                    children: [
                      Text(
                        label.toString(),
                        style: TextStyles.titleT1.copyWith(color: color),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(width: 5),
                      Icon(
                        icon,
                        color: color,
                        size: size != null ? size : 24,
                      ),
                    ],
                  )
                : label != null && !leading
                    ? Row(
                        children: [
                          Icon(
                            icon,
                            color: color,
                            size: size != null ? size : 24,
                          ),
                          const SizedBox(width: 5),
                          Text(label.toString(),
                              style: TextStyles.titleT1.copyWith(color: color),
                              overflow: TextOverflow.ellipsis)
                        ],
                      )
                    : Ink(
                        padding: EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(30),
                          ),
                        ),
                        child: Icon(
                          icon,
                          color: color,
                          size: size != null ? size : 24,
                        ),
                      ),
            onTap: onTap,
          )),
    );
  }
}

class AvatarButton extends StatelessWidget {
  final double? radius;
  final double? borderSize;
  final Color? backgroundColor;
  final ImageProvider? image;
  final Widget? child;
  final Function()? onTap;

  AvatarButton(
      {this.radius,
      this.backgroundColor,
      this.image,
      this.onTap,
      this.child,
      this.borderSize});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Ink(
        width: radius != null ? radius! * 2 : 32,
        height: radius != null ? radius! * 2 : 32,
        child: Align(
          widthFactor: 1,
          heightFactor: 1,
          child: CircleAvatar(
            maxRadius: radius != null ? radius : 16,
            backgroundColor: backgroundColor,
            child: image != null
                ? CircleAvatar(
                    backgroundColor: backgroundColor,
                    maxRadius: radius != null
                        ? borderSize != null
                            ? radius! - borderSize! / 2
                            : radius!
                        : 16 * 0.8,
                    backgroundImage:
                        image ?? AssetImage('assets/images/leo.jpg'),
                  )
                : child ?? SizedBox(),
          ),
        ),
      ),
      onTap: onTap,
      borderRadius:
          BorderRadius.all(Radius.circular(radius != null ? radius! * 2 : 48)),
    );
  }
}
