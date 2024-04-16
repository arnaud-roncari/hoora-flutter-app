import 'package:flutter/material.dart';
import 'package:hoora/common/decoration.dart';
import 'package:hoora/ui/page/challenge_page.dart';
import 'package:hoora/ui/page/explore/explore_page.dart';
import 'package:hoora/ui/page/gift_page.dart';
import 'package:hoora/ui/page/explore/map_page.dart';
import 'package:hoora/ui/page/validation_page.dart';
import 'package:hoora/ui/widget/navigation_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController controller = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      body: SafeArea(
          child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 60),
            child: PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: controller,
              children: const [
                ExplorePage(),
                MapPage(),
                ValidationPage(),
                GiftPage(),
                ChallengePage(),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Navigation(
              onChanged: (page) {
                setState(() {
                  controller.jumpToPage(page);
                });
              },
            ),
          )
        ],
      )),
    );
  }
}
