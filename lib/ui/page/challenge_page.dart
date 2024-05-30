import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hoora/bloc/challenge/challenge_bloc.dart';
import 'package:hoora/bloc/user/user_bloc.dart' as user_bloc;
import 'package:hoora/common/alert.dart';
import 'package:hoora/common/decoration.dart';
import 'package:hoora/model/challenge_model.dart';
import 'package:hoora/ui/widget/challenge/challenge_card.dart';
import 'package:hoora/ui/widget/gem_button.dart';

import 'package:lottie/lottie.dart';

class ChallengePage extends StatefulWidget {
  const ChallengePage({super.key});

  @override
  State<ChallengePage> createState() => _ChallengePageState();
}

class _ChallengePageState extends State<ChallengePage> with AutomaticKeepAliveClientMixin {
  late ChallengeBloc challengeBloc;

  @override
  void initState() {
    super.initState();
    challengeBloc = context.read<ChallengeBloc>();
    challengeBloc.add(Init());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocConsumer<ChallengeBloc, ChallengeState>(
      listener: (context, state) {
        if (state is InitFailed) {
          Alert.showError(context, state.exception.message);
        }

        if (state is ClaimSuccess) {
          context.read<user_bloc.UserBloc>().add(user_bloc.AddGem(gem: state.gem));
          Alert.showSuccessWidget(
            context,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Vous avez gagné ${state.gem} gemmes !",
                  style: kBoldARPDisplay13.copyWith(
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: kPadding10),
                SvgPicture.asset("assets/svg/gem.svg"),
              ],
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is InitLoading || state is InitFailed) {
          return const Center(child: CircularProgressIndicator(color: kPrimary));
        }

        return Stack(
          children: [
            if (state is ClaimSuccess)
              LottieBuilder.asset(
                "assets/animations/confetis.json",
                repeat: false,
              ),
            Column(
              children: [
                SizedBox(height: MediaQuery.of(context).padding.top),
                const Padding(
                  padding: EdgeInsets.only(top: kPadding20, right: kPadding20),
                  child: Align(alignment: Alignment.topRight, child: GemButton()),
                ),
                const SizedBox(height: kPadding20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset("assets/svg/challenge_mountain.svg"),
                    const SizedBox(width: kPadding10),
                    const Text("Challenges", style: kRBoldNunito18),
                  ],
                ),
                const SizedBox(height: kPadding40),
                const Text(
                  "Gagnez plus !\nRelevez des défis!",
                  style: kBoldARPDisplay18,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: kPadding20),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: kPadding20),
                    child: ListView.builder(
                        itemCount: challengeBloc.challenges.length,
                        padding: EdgeInsets.zero,
                        itemBuilder: (context, index) {
                          Challenge challenge = challengeBloc.challenges[index];
                          EdgeInsetsGeometry padding = const EdgeInsets.only(bottom: 10);

                          if (index == 0) {
                            padding = const EdgeInsets.only(top: 20, bottom: 10);
                          }

                          if (index == challengeBloc.challenges.length - 1 && challengeBloc.challenges.length > 1) {
                            padding = const EdgeInsets.only(bottom: 20);
                          }

                          return Padding(
                            padding: padding,
                            child: ChallengeCard(challenge: challenge),
                          );
                        }),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
