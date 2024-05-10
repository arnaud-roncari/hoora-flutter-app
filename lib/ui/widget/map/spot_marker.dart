import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hoora/common/decoration.dart';
import 'package:hoora/model/spot_model.dart';

class SpotMarker extends StatelessWidget {
  final Spot spot;
  const SpotMarker({super.key, required this.spot});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        /// Main circle
        Center(
          child: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: spot.isSponsoredNow() ? null : kPrimary,
              border: Border.all(color: Colors.white, width: 3),
              borderRadius: BorderRadius.circular(kRadius100),
              gradient: spot.isSponsoredNow()
                  ? const LinearGradient(
                      colors: [
                        Color.fromRGBO(187, 177, 123, 1),
                        Color.fromRGBO(255, 244, 188, 1),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [
                        0,
                        0.7,
                      ],
                    )
                  : null,
            ),

            /// Gem
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  spot.getGemsNow() == 0 ? "assets/svg/grey_gem.svg" : "assets/svg/gem.svg",
                  height: 17,
                ),
                const SizedBox(height: 1),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    spot.getGemsNow().toString(),
                    style: kBoldARPDisplay11.copyWith(
                      color: spot.isSponsoredNow() ? kPrimary : Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        if (spot.hasCrowdReportNow() && spot.isAwaitingTimeNow())
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              height: 35,
              width: 35,
              decoration: BoxDecoration(
                color: const Color.fromRGBO(161, 154, 255, 1),
                borderRadius: BorderRadius.circular(kRadius100),
              ),
              child: Center(
                  child: SvgPicture.asset(
                "assets/svg/hour_glass.svg",
                height: 25,
              )),
            ),
          ),

        if (spot.hasCrowdReportNow())
          Align(
            alignment: Alignment.topRight,
            child: Container(
              height: 35,
              width: 35,
              decoration: BoxDecoration(
                color: const Color.fromRGBO(255, 234, 176, 1),
                borderRadius: BorderRadius.circular(kRadius100),
              ),
              child: Center(
                  child: SvgPicture.asset(
                "assets/svg/smiley_${spot.lastCrowdReport!.intensity}.svg",
                height: 25,
              )),
            ),
          ),
      ],
    );
  }
}