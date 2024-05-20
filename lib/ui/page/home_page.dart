import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hoora/bloc/explore/explore_bloc.dart' as explore_bloc;
import 'package:hoora/bloc/map/map_bloc.dart' as map_bloc;
import 'package:hoora/bloc/user/user_bloc.dart' as user_bloc;
import 'package:hoora/common/decoration.dart';
import 'package:hoora/ui/page/challenge_page.dart';
import 'package:hoora/ui/page/explore/explore_page.dart';
import 'package:hoora/ui/page/map/map_page.dart';
import 'package:hoora/ui/page/offer/offers_page.dart';
import 'package:hoora/ui/page/ranking_page.dart';
import 'package:hoora/ui/widget/navigation_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController controller = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
    context.read<user_bloc.UserBloc>().add(user_bloc.Init());
    context.read<explore_bloc.ExploreBloc>().add(explore_bloc.Init());
    context.read<map_bloc.MapBloc>().add(map_bloc.Init());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      body: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 60),
              child: PageView(
                physics: const NeverScrollableScrollPhysics(),
                controller: controller,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                    child: const ExplorePage(),
                  ),
                  const OffersPage(),
                  const MapPage(),
                  const ChallengePage(),
                  const RankingPage(),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Navigation(
                onChanged: (page) {
                  setState(() {
                    controller.jumpToPage(page);
                    if (page == 2) {
                      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
                    } else {
                      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
                    }
                  });
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
