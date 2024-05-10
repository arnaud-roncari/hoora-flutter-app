import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hoora/bloc/explore/explore_bloc.dart';
import 'package:hoora/common/decoration.dart';
import 'package:hoora/model/spot_model.dart';
import 'package:hoora/ui/page/spot_page.dart';

class SpotCard extends StatelessWidget {
  final Spot spot;
  const SpotCard({super.key, required this.spot});

  @override
  Widget build(BuildContext context) {
    DateTime selectedDate = context.read<ExploreBloc>().selectedDate;

    return Container(
      height: 120,
      width: double.infinity,
      decoration: BoxDecoration(
        color: kPrimary,
        borderRadius: BorderRadius.circular(kRadius10),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SpotPage(
                spot: spot,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(kPadding10),
          child: Row(
            children: [
              FutureBuilder<String>(
                  future: FirebaseStorage.instance.ref().child("spot/card/${spot.imageCardPath}").getDownloadURL(),
                  builder: (_, snapshot) {
                    if (snapshot.hasData) {
                      return CachedNetworkImage(
                        height: 100,
                        width: 100,
                        fit: BoxFit.fitHeight,
                        imageUrl: snapshot.data!,
                        placeholder: (context, url) => const SizedBox(
                          height: 100,
                          width: 100,
                        ),
                        errorWidget: (context, url, error) => const SizedBox(
                          height: 100,
                          width: 100,
                        ),
                        imageBuilder: (context, imageProvider) => Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(kRadius10),
                            image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                          ),
                        ),
                      );
                    }
                    return const SizedBox(
                      height: 100,
                      width: 100,
                    );
                  }),
              const SizedBox(width: kPadding10),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: kPadding5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        spot.name,
                        style: kBoldARPDisplay11.copyWith(color: Colors.white),
                        maxLines: 2,
                      ),
                      const SizedBox(height: kPadding5),
                      Text(
                        spot.cityName,
                        style: kRegularBalooPaaji14.copyWith(color: Colors.white),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          if (spot.hasCrowdReportAt(selectedDate))
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
                                    getCrowdReportAwaitingTime(),
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
                              color: spot.isSponsoredAt(selectedDate) ? null : kGemsIndicator,
                              borderRadius: BorderRadius.circular(kRadius100),
                              gradient: spot.isSponsoredAt(selectedDate)
                                  ? const LinearGradient(
                                      colors: [
                                        Color.fromRGBO(187, 177, 123, 1),
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
                                SizedBox(
                                  width: 35,
                                  height: 30,
                                  child: Center(
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        spot.getGemsAt(selectedDate).toString(),
                                        style: kBoldARPDisplay13,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 30,
                                  width: 35,
                                  child: Center(
                                      child: Padding(
                                    padding: const EdgeInsets.only(right: kPadding5),
                                    child: SvgPicture.asset(
                                      "assets/svg/gem.svg",
                                      height: 15,
                                    ),
                                  )),
                                ),
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
      ),
    );
  }

  String getCrowdReportAwaitingTime() {
    if (spot.lastCrowdReport == null) {
      return '0\'';
    }

    int hour = int.parse(spot.lastCrowdReport!.duration.split(":")[0]);
    int minute = int.parse(spot.lastCrowdReport!.duration.split(":")[1]);

    if (hour < 1) {
      return '$minute\'';
    }

    if (minute < 15) {
      return '${hour}h';
    }

    return '${hour}h$minute';
  }
}
