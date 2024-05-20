import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hoora/bloc/user/user_bloc.dart';
import 'package:hoora/common/decoration.dart';
import 'package:hoora/common/sentences.dart';

class LevelCard extends StatelessWidget {
  final double height;
  const LevelCard({super.key, required this.height});

  @override
  Widget build(BuildContext context) {
    UserBloc userBloc = context.read<UserBloc>();

    return BlocConsumer<UserBloc, UserState>(
      listener: (context, state) {},
      builder: (context, state) {
        return InkWell(
          onTap: () {
            Navigator.pushNamed(context, "/home/earnings/level");
          },
          child: Container(
            height: height,
            decoration: BoxDecoration(
              color: kSecondary,
              borderRadius: BorderRadius.circular(kRadius10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 0,
                  blurRadius: 3,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(kPadding20),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Mon niveau",
                          style: kRegularBalooPaaji14,
                        ),
                        const SizedBox(height: kPadding5),
                        Text(
                          levelSentences[userBloc.user.level - 1],
                          style: kBoldARPDisplay16,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ],
                    ),
                  ),
                  SvgPicture.asset(
                    "assets/svg/level_${userBloc.user.level}.svg",
                    height: 55,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
