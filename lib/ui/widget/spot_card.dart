import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hoora/bloc/explore/explore_bloc.dart';
import 'package:hoora/common/decoration.dart';
import 'package:hoora/model/spot_model.dart';

/// TODO retirer le reload du backend et faire le trie lors du changement de catégorie
/// TODO intéger du délai front pendant le sliding (si ça lag)
class SpotCard extends StatelessWidget {
  final Spot spot;
  const SpotCard({super.key, required this.spot});

  @override
  Widget build(BuildContext context) {
    DateTime selectedDate = context.read<ExploreBloc>().selectedDate;
    int selectedHour = context.read<ExploreBloc>().selectedHour;

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
            FutureBuilder<String>(
                future: FirebaseStorage.instance.ref().child("spot/${spot.imageCardPath}").getDownloadURL(),
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
                      style: kBoldARPDisplay14.copyWith(color: Colors.white),
                    ),
                    const SizedBox(height: kPadding5),
                    Text(
                      spot.city.name,
                      style: kRegularBalooPaaji16.copyWith(color: Colors.white),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        if (spot.isCrowdedAt(selectedDate, selectedHour))
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
                            color: spot.isSponsoredAt(selectedDate) ? kSecondary : kGemsIndicator,
                            borderRadius: BorderRadius.circular(kRadius100),
                            gradient: spot.isSponsoredAt(selectedDate)
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
                              SizedBox(
                                width: 35,
                                height: 30,
                                child: Center(
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      spot
                                          .getGemsAt(
                                            selectedDate,
                                            selectedHour,
                                          )
                                          .toString(),
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
    );
  }
}
