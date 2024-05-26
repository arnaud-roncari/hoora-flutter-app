import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hoora/bloc/offer/offer_bloc.dart';
import 'package:hoora/common/alert.dart';
import 'package:hoora/common/decoration.dart';
import 'package:hoora/model/offer_model.dart';
import 'package:hoora/ui/widget/level_card.dart';
import 'package:hoora/ui/widget/offer/offer_card.dart';

class OffersPage extends StatefulWidget {
  const OffersPage({super.key});

  @override
  State<OffersPage> createState() => _OffersPageState();
}

class _OffersPageState extends State<OffersPage> with AutomaticKeepAliveClientMixin {
  late OfferBloc offerBloc;

  @override
  void initState() {
    super.initState();
    offerBloc = context.read<OfferBloc>();
    offerBloc.add(Init());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BlocConsumer<OfferBloc, OfferState>(
      listener: (context, state) {
        if (state is InitFailed) {
          Alert.showError(context, state.exception.message);
        }
      },
      builder: (context, state) {
        if (state is InitLoading || state is InitFailed) {
          return const Center(child: CircularProgressIndicator(color: kPrimary));
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: kPadding20),
                child: LevelCard(height: 100),
              ),
              const SizedBox(height: kPadding20),

              /// Level 1 offers
              Row(
                children: [
                  const SizedBox(width: kPadding20),
                  SvgPicture.asset(
                    "assets/svg/level_1_blank.svg",
                    height: 30,
                  ),
                  const SizedBox(width: 5),
                  const Text(
                    'Niveau I',
                    style: kRBoldBalooPaaji18,
                  ),
                ],
              ),
              const SizedBox(height: kPadding10),

              SizedBox(
                /// 10 for the shadow to be displayed
                height: 160 + 10,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: offerBloc.offersLevel1.length,
                  itemBuilder: (_, index) {
                    Offer offer = offerBloc.offersLevel1[index];
                    EdgeInsetsGeometry padding = const EdgeInsets.only(right: 10);

                    if (index == 0) {
                      padding = const EdgeInsets.only(left: 20, right: 10);
                    }

                    if (index == offerBloc.offersLevel1.length - 1 && offerBloc.offersLevel1.length > 1) {
                      padding = const EdgeInsets.only(right: 20);
                    }

                    return Padding(
                      padding: padding,
                      child: Align(alignment: Alignment.topCenter, child: OfferCard(offer: offer)),
                    );
                  },
                ),
              ),
              const SizedBox(height: kPadding20),

              /// Level 2 offers
              Row(
                children: [
                  const SizedBox(width: kPadding20),
                  SvgPicture.asset(
                    "assets/svg/level_2_blank.svg",
                    height: 30,
                  ),
                  const SizedBox(width: 5),
                  const Text(
                    'Niveau II',
                    style: kRBoldBalooPaaji18,
                  ),
                ],
              ),
              const SizedBox(height: kPadding10),

              SizedBox(
                /// 10 for the shadow to be displayed
                height: 160 + 10,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: offerBloc.offersLevel2.length,
                  itemBuilder: (_, index) {
                    Offer offer = offerBloc.offersLevel2[index];
                    EdgeInsetsGeometry padding = const EdgeInsets.only(right: 10);

                    if (index == 0) {
                      padding = const EdgeInsets.only(left: 20, right: 10);
                    }

                    if (index == offerBloc.offersLevel2.length - 1 && offerBloc.offersLevel2.length > 1) {
                      padding = const EdgeInsets.only(right: 20);
                    }

                    return Padding(
                      padding: padding,
                      child: Align(alignment: Alignment.topCenter, child: OfferCard(offer: offer)),
                    );
                  },
                ),
              ),

              const SizedBox(height: kPadding20),

              /// Level 3 offers
              Row(
                children: [
                  const SizedBox(width: kPadding20),
                  SvgPicture.asset(
                    "assets/svg/level_3_blank.svg",
                    height: 30,
                  ),
                  const SizedBox(width: 5),
                  const Text(
                    'Niveau III',
                    style: kRBoldBalooPaaji18,
                  ),
                ],
              ),
              const SizedBox(height: kPadding10),

              SizedBox(
                /// 10 for the shadow to be displayed
                height: 160 + 10,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: offerBloc.offersLevel3.length,
                  itemBuilder: (_, index) {
                    Offer offer = offerBloc.offersLevel3[index];
                    EdgeInsetsGeometry padding = const EdgeInsets.only(right: 10);

                    if (index == 0) {
                      padding = const EdgeInsets.only(left: 20, right: 10);
                    }

                    if (index == offerBloc.offersLevel3.length - 1 && offerBloc.offersLevel3.length > 1) {
                      padding = const EdgeInsets.only(right: 20);
                    }

                    return Padding(
                      padding: padding,
                      child: Align(alignment: Alignment.topCenter, child: OfferCard(offer: offer)),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
