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
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      body: SafeArea(
          child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 60),
            child: Builder(builder: (_) {
              switch (currentIndex) {
                case 0:
                  return const ExplorePage();
                case 1:
                  return const MapPage();
                case 2:
                  return const ValidationPage();
                case 3:
                  return const GiftPage();
                case 4:
                  return const ChallengePage();
                default:
                  return const ExplorePage();
              }
            }),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Navigation(
              onChanged: (index) {
                setState(() {
                  currentIndex = index;
                });
              },
            ),
          )
        ],
      )),
    );
  }
}


//  Button(
//           onPressed: () {
//             context.read<AuthBloc>().add(SignOut());
//           },
//           text: "Signout",
//         ),