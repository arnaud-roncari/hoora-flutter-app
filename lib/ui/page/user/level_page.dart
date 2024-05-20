import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hoora/bloc/user/user_bloc.dart';
import 'package:hoora/common/decoration.dart';
import 'package:hoora/common/sentences.dart';
import 'package:hoora/ui/widget/gem_progress_bar.dart';

class LevelPage extends StatefulWidget {
  const LevelPage({super.key});

  @override
  State<LevelPage> createState() => _LevelPageState();
}

class _LevelPageState extends State<LevelPage> {
  late UserBloc userBloc;

  @override
  void initState() {
    super.initState();
    userBloc = context.read<UserBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSecondary,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: kPadding20),
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).padding.top + kPadding20),
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  CupertinoIcons.arrow_left,
                  size: 32,
                  color: kPrimary,
                ),
              ),
            ),
            const Text(
              "Votre impact positif\nest récompensé !",
              style: kBoldARPDisplay18,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: kPadding40),
            SvgPicture.asset(
              "assets/svg/level_${userBloc.user.level}.svg",
              height: 50,
            ),
            const SizedBox(height: kPadding5),
            const Text(
              "Mon niveau",
              style: kRegularBalooPaaji14,
            ),
            const SizedBox(height: kPadding5),
            Text(
              levelSentences[userBloc.user.level - 1].replaceAll(" ", "\n"),
              style: kBoldARPDisplay11,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: kPadding40),
            if (userBloc.user.level < 3)
              FractionallySizedBox(
                widthFactor: 0.8,
                child: Row(
                  children: [
                    Text(
                      userBloc.user.level == 1 ? "I" : "II",
                      style: kBoldARPDisplay11,
                    ),
                    const SizedBox(width: kPadding10),
                    Expanded(
                      child: GemProgressBar(
                        value: userBloc.user.experience,
                        goal: userBloc.user.level == 1 ? 800 : 2000,
                      ),
                    ),
                    const SizedBox(width: kPadding10),
                    Text(
                      userBloc.user.level == 1 ? "II" : "III",
                      style: kBoldARPDisplay11,
                    ),
                  ],
                ),
              ),
            const SizedBox(height: kPadding40),
            const FractionallySizedBox(
              widthFactor: 0.8,
              child: Text(
                "Tous vos gains depuis votre inscription sont comptabilisés et vous permettent de monter en niveau. Cumulez encore plus de points pour débloquer des récompenses toujours plus alléchantes !",
                textAlign: TextAlign.center,
                style: kRegularBalooPaaji14,
              ),
            ),
            const SizedBox(height: kPadding20),
            const FractionallySizedBox(
              widthFactor: 0.8,
              child: Text(
                "Plus vous visitez durablement, plus vous êtes récompensés !",
                textAlign: TextAlign.center,
                style: kBoldBalooPaaji14,
              ),
            ),
            const SizedBox(height: kPadding40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    SvgPicture.asset(
                      "assets/svg/level_1.svg",
                      height: 50,
                    ),
                    const SizedBox(height: kPadding5),
                    const Text(
                      "Niveau 1",
                      style: kBoldBalooPaaji14,
                    ),
                    const SizedBox(height: kPadding5),
                    const Text(
                      "Touriste\nResponsable",
                      textAlign: TextAlign.center,
                      style: kBoldBalooPaaji12,
                    ),
                  ],
                ),
                Column(
                  children: [
                    SvgPicture.asset(
                      "assets/svg/level_2.svg",
                      height: 50,
                    ),
                    const SizedBox(height: kPadding5),
                    const Text(
                      "Niveau 2",
                      style: kBoldBalooPaaji14,
                    ),
                    const SizedBox(height: kPadding5),
                    const Text(
                      "Aventurier\nEngagé",
                      textAlign: TextAlign.center,
                      style: kBoldBalooPaaji12,
                    ),
                  ],
                ),
                Column(
                  children: [
                    SvgPicture.asset(
                      "assets/svg/level_3.svg",
                      height: 50,
                    ),
                    const SizedBox(height: kPadding5),
                    const Text(
                      "Niveau 3",
                      style: kBoldBalooPaaji14,
                    ),
                    const SizedBox(height: kPadding5),
                    const Text(
                      "Explorateur\nElite",
                      textAlign: TextAlign.center,
                      style: kBoldBalooPaaji12,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
