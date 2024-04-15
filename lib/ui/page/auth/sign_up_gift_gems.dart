import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hoora/common/decoration.dart';
import 'package:lottie/lottie.dart';

class SignUpGiftGemsPage extends StatelessWidget {
  const SignUpGiftGemsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSecondary,
      body: SafeArea(
        child: LayoutBuilder(builder: (context, constraints) {
          return Padding(
            padding: const EdgeInsets.all(kPadding20),
            child: Column(
              children: [
                const Text(
                  "Bienvenue à bord !",
                  textAlign: TextAlign.center,
                  style: kBoldARPDisplay25,
                ),
                const Spacer(),
                const FractionallySizedBox(
                  widthFactor: 0.45,
                  child: Text(
                    "Votre cadeau de bienvenue",
                    style: kBoldARPDisplay14,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: kPadding20),
                SizedBox(
                  height: 125,
                  width: 125,
                  child: Stack(
                    children: [
                      SizedBox(
                        height: 125,
                        width: 125,
                        child: SvgPicture.asset("assets/svg/bubble.svg"),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 2.5),
                        child: Stack(
                          children: [
                            /// Center due to the bottom left "arrow".
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Align(
                                alignment: Alignment.topCenter,
                                child: Lottie.asset(
                                  "assets/animations/gem.json",
                                  height: 75,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 35),
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Text(
                                  "15",
                                  style: kBoldARPDisplay20.copyWith(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(
                  flex: 2,
                ),
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    style: kButtonRoundedStyle,
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, "/home");
                    },
                    child: Text(
                      "C'est partiiiii !",
                      style: kBoldBalooPaaji16.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
