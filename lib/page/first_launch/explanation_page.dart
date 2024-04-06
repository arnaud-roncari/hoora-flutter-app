import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hoora/bloc/first_launch/first_launch_bloc.dart';
import 'package:hoora/common/decoration.dart';
import 'package:hoora/widget/page_indicator.dart';
import 'package:lottie/lottie.dart';

/// To keep the text aligned, we didnt used spacer but sizedbox with poourcentage.
/// The half of the screen is for the animations.
/// Animations are also each resized with differents values (due to the client).
/// Same for the text.
class ExplanationPage extends StatefulWidget {
  const ExplanationPage({super.key});

  @override
  State<ExplanationPage> createState() => _ExplanationPageState();
}

class _ExplanationPageState extends State<ExplanationPage> {
  late PageController controller = PageController();
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      body: BlocConsumer<FirstLaunchBloc, FirstLaunchState>(
        listener: (context, state) {
          if (state is FirstLaunchSet) {
            Navigator.of(context).pushNamedAndRemoveUntil('/auth/sign_up', (Route<dynamic> route) => false);
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: PageView(
                    controller: controller,
                    onPageChanged: (index) {
                      setState(() {
                        currentIndex = index;
                      });
                    },
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(kPadding20),
                        child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
                          return Column(
                            children: [
                              SizedBox(height: constraints.maxHeight * 0.15),
                              SizedBox(
                                height: constraints.maxHeight * 0.40,
                                child: FractionallySizedBox(
                                  widthFactor: 0.6,
                                  child: Lottie.asset("assets/animations/people.json"),
                                ),
                              ),
                              SizedBox(height: constraints.maxHeight * 0.15),
                              const Text(
                                "Découvrez",
                                style: kBoldARPDisplay25,
                              ),
                              const SizedBox(height: kPadding5),
                              const FractionallySizedBox(
                                widthFactor: 0.9,
                                child: Text(
                                  "Découvrez des  attraction touristiques autour de vous !",
                                  style: kRegularBalooPaaji20,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const Spacer(),
                            ],
                          );
                        }),
                      ),
                      Padding(
                          padding: const EdgeInsets.all(kPadding20),
                          child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
                            return Column(
                              children: [
                                SizedBox(height: constraints.maxHeight * 0.15),
                                SizedBox(
                                  height: constraints.maxHeight * 0.40,
                                  child: FractionallySizedBox(
                                      widthFactor: 0.35,
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 50),
                                        child: Lottie.asset("assets/animations/time.json"),
                                      )),
                                ),
                                SizedBox(height: constraints.maxHeight * 0.15),
                                const Text(
                                  "Choisissez",
                                  style: kBoldARPDisplay25,
                                ),
                                const SizedBox(height: kPadding5),
                                const FractionallySizedBox(
                                  widthFactor: 0.9,
                                  child: Text(
                                    " Choisissez le moment idéal pour vos visites. En optant pour les heures creuses, vous aidez à la répartition des flux et profitez pleinement des sites touristiques.",
                                    style: kRegularBalooPaaji20,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                const Spacer(),
                              ],
                            );
                          })),
                      Padding(
                        padding: const EdgeInsets.all(kPadding20),
                        child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
                          return Column(
                            children: [
                              SizedBox(height: constraints.maxHeight * 0.15),
                              SizedBox(
                                height: constraints.maxHeight * 0.40,
                                child: FractionallySizedBox(
                                    widthFactor: 0.5,
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 50),
                                      child: FractionallySizedBox(
                                          child: Lottie.asset("assets/animations/validation.json")),
                                    )),
                              ),
                              SizedBox(height: constraints.maxHeight * 0.15),
                              const Text(
                                "Validez",
                                style: kBoldARPDisplay25,
                              ),
                              const SizedBox(height: kPadding5),
                              const FractionallySizedBox(
                                widthFactor: 0.9,
                                child: Text(
                                  "Validez votre visite grâce à votre position GPS ou en prenant en photo votre ticket d'entrée. Si votre visite est en heure creuse, vous gagnez des points !",
                                  style: kRegularBalooPaaji20,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const Spacer(),
                            ],
                          );
                        }),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(kPadding20),
                        child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
                          return Column(
                            children: [
                              SizedBox(height: constraints.maxHeight * 0.15),
                              SizedBox(
                                height: constraints.maxHeight * 0.40,
                                child: FractionallySizedBox(
                                    widthFactor: 0.5, child: Lottie.asset("assets/animations/chest.json")),
                              ),
                              SizedBox(height: constraints.maxHeight * 0.15),
                              const Text(
                                "Echangez",
                                style: kBoldARPDisplay25,
                              ),
                              const SizedBox(height: kPadding5),
                              const FractionallySizedBox(
                                widthFactor: 0.9,
                                child: Text(
                                  "Echangez vos points contre des avantages exclusifs. Votre contribution à un tourisme responsable est ainsi récompensée.",
                                  style: kRegularBalooPaaji20,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const Spacer(),
                            ],
                          );
                        }),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    PageIndicator(length: 4, currentIndex: currentIndex),
                    Padding(
                      padding: const EdgeInsets.all(kPadding20),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: IconButton(
                          disabledColor: kBackground,
                          onPressed: currentIndex == 3
                              ? () {
                                  context.read<FirstLaunchBloc>().add(SetFirstLaunch());
                                }
                              : null,
                          icon: Icon(
                            CupertinoIcons.arrow_right,
                            size: 32,
                            color: currentIndex == 3 ? kPrimary : kBackground,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }
}
