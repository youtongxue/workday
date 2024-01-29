import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: context.width,
        height: context.height,
        color: Colors.amber,
        child: Column(
          children: [
            Container(
              width: context.width,
              height: context.height / 3,
              color: Colors.white,
              child: const SizedBox(),
            )
          ],
        ),
      ),
    );
  }
}
