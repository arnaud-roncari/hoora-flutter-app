import 'package:flutter/material.dart';
import 'package:hoora/common/decoration.dart';

class PageIndicator extends StatelessWidget {
  final int length;
  final int currentIndex;
  const PageIndicator({super.key, required this.length, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    for (int i = 0; i < length; i++) {
      children.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2.5),
          child: Container(
            width: 43,
            height: 8,
            decoration: BoxDecoration(
              color: currentIndex == i ? kPrimary : kPrimary.withOpacity(0.30),
              borderRadius: BorderRadius.circular(100),
            ),
          ),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    );
  }
}
