import 'package:flutter/material.dart';
import 'package:workday/components/view/custom_body.dart';
import 'package:workday/enumm/color_enum.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomBody(
        backgroundColor: MyColors.background.color,
        body: const Column(
          children: [
            Center(
              child: Text("统计页"),
            )
          ],
        ),
      ),
    );
  }
}
