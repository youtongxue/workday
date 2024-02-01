import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../enumm/appbar_enum.dart';
import '../../enumm/nav_enum.dart';
import '../../enumm/color_enum.dart';

final GlobalKey appBarKey = GlobalKey();

class CustomBody extends StatelessWidget {
  final Widget? appBar;
  //final List<Widget> body;
  final Widget? body;
  final bool enableAppBarPadding;
  final bool enableNaviBottom;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final bool scroller; // 根据此属性，让body为ListView还是Column
  final Color? backgroundColor;

  const CustomBody({
    super.key,
    this.appBar,
    this.body,
    this.enableAppBarPadding = true,
    this.enableNaviBottom = false,
    this.padding,
    this.margin,
    this.scroller = true,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final statusHeight = context.mediaQueryPadding.top;
    final appBarHeight = AppBarOptions.hight50.height;

    //final navHeight = context.mediaQueryPadding.bottom;
    final appNavHeight = NavigationOptions.hight55.height;

    return Stack(
      children: [
        Container(
          padding: EdgeInsets.only(
            top: enableAppBarPadding ? (appBarHeight + statusHeight) : 0,
            bottom: enableNaviBottom ? (appNavHeight) : 0,
          ),
          color: backgroundColor ?? MyColors.cardGrey1.color,
          child: MediaQuery.removePadding(
            context: context,
            removeTop: true,
            removeBottom: true,
            child: Container(
              width: context.width,
              height: context.height,
              padding: padding,
              margin: margin,
              child: SingleChildScrollView(
                physics:
                    scroller ? const AlwaysScrollableScrollPhysics() : null,
                child: body,
              ),
            ),
          ),
        ),
        if (appBar != null) appBar!,
      ],
    );
  }
}
