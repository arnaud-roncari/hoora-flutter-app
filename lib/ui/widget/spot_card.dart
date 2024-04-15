import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hoora/common/decoration.dart';

class SpotCard extends StatelessWidget {
  const SpotCard({super.key});

  bool isCrowded() {
    /// Check if there is a crowed element declared.
    /// Also check if it's in the same range time and day (2H range).
    return true;
  }

  bool isSponsored() {
    /// TODO update with data
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      width: double.infinity,
      decoration: BoxDecoration(
        color: kPrimary,
        borderRadius: BorderRadius.circular(kRadius10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(kPadding10),
        child: Row(
          children: [
            Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                color: kSecondary,
                borderRadius: BorderRadius.circular(kRadius10),
              ),
              child: Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  color: kSecondary,
                  borderRadius: BorderRadius.circular(kRadius10),
                ),
              ),
            ),
            const SizedBox(width: kPadding10),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: kPadding5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Jardin Albert 1er",
                      style: kBoldARPDisplay14.copyWith(color: Colors.white),
                    ),
                    const SizedBox(height: kPadding5),
                    Text(
                      "Nice",
                      style: kRegularBalooPaaji16.copyWith(color: Colors.white),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        if (isCrowded())
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 2.5),
                                child: Text(
                                  "foule",
                                  style: kRegularBalooPaaji12.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(width: kPadding5),
                              SvgPicture.asset("assets/svg/crowd.svg"),
                              const SizedBox(width: kPadding10),
                              Padding(
                                padding: const EdgeInsets.only(top: 2.5),
                                child: Text(
                                  "3h",
                                  style: kRegularBalooPaaji12.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(width: kPadding5),
                              SvgPicture.asset("assets/svg/waiting.svg"),
                            ],
                          ),
                        const Spacer(),
                        Container(
                          height: 30,
                          width: 70,
                          decoration: BoxDecoration(
                            color: isSponsored() ? kSecondary : kGemsIndicator,
                            borderRadius: BorderRadius.circular(kRadius100),
                            gradient: isSponsored()
                                ? const LinearGradient(
                                    colors: [
                                      Color.fromRGBO(87, 177, 123, 1),
                                      Color.fromRGBO(255, 244, 188, 1),
                                    ],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    stops: [
                                      0,
                                      0.7,
                                    ],
                                  )
                                : null,
                          ),
                          child: Row(
                            children: [
                              const Spacer(),
                              const Text(
                                "20",
                                style: kBoldARPDisplay13,
                              ),
                              const SizedBox(width: kPadding5),
                              SvgPicture.asset("assets/svg/gem.svg"),
                              const Spacer(),
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
