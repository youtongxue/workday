import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<T?> showMyBottomSheet<T>(
  BuildContext context, {
  required Widget showChild,
  bool scrollControlled = false,
  Color? backgroundColor = Colors.white,
  EdgeInsets? bodyPadding = const EdgeInsets.all(0),
  BorderRadius? radius = const BorderRadius.only(
      topLeft: Radius.circular(20), topRight: Radius.circular(20)),
}) {
  // MediaQuery.of(context).viewPadding.bottom,
  return showModalBottomSheet(
    context: context,
    clipBehavior: Clip.hardEdge,
    elevation: 0,
    backgroundColor: backgroundColor,
    shape: RoundedRectangleBorder(borderRadius: radius!),
    barrierColor: Colors.black.withOpacity(0.25),
    // A处
    constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height -
            MediaQuery.of(context).viewPadding.top,
        maxWidth: context.width),
    isScrollControlled: scrollControlled,
    builder: (context) => showChild,
  );
}
