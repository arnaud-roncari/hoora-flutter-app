import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hoora/bloc/explore/explore_bloc.dart';
import 'package:hoora/common/alert.dart';
import 'package:hoora/common/decoration.dart';
import 'package:hoora/common/extension/weekday_extension.dart';
import 'package:hoora/model/category_model.dart';
import 'package:hoora/model/spot_model.dart';
import 'package:hoora/model/user_model.dart';
import 'package:hoora/ui/widget/hour_slider.dart';
import 'package:hoora/ui/widget/spot_card.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
    context.read<ExploreBloc>().add(Initialize());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocConsumer<ExploreBloc, ExploreState>(
      listener: (context, state) {
        if (state is InitFailed) {
          Alert.showError(context, state.exception.message);
        }

        if (state is GetSpotsFailed) {
          Alert.showError(context, state.exception.message);
        }
      },
      builder: (context, state) {
        if (state is InitLoading || state is InitFailed) {
          return const Center(child: CircularProgressIndicator(color: kPrimary));
        }

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: kPadding20, right: kPadding20),
              child: buildGemButton(),
            ),
            const SizedBox(height: kPadding20),
            const Padding(
              padding: EdgeInsets.only(left: kPadding20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor: 0.8,
                  child: Text(
                    "Planifiez votre visite responsable",
                    style: kBoldARPDisplay16,
                  ),
                ),
              ),
            ),
            const SizedBox(height: kPadding20),
            Padding(
              padding: const EdgeInsets.only(left: kPadding20),
              child: Row(
                children: [
                  SizedBox(
                    height: 35,
                    child: ElevatedButton(
                      style: kButtonRoundedStyle,
                      onPressed: () {
                        Navigator.pushNamed(context, "/home/city");
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(kPadding10),
                        child: Text(
                          context.read<ExploreBloc>().selectedCity.name,
                          style: kBoldBalooPaaji16.copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: kPadding10),
                  SizedBox(
                    height: 35,
                    child: ElevatedButton(
                      style: kButtonRoundedStyle,
                      onPressed: () {
                        Navigator.pushNamed(context, "/home/date");
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(kPadding10),
                        child: Text(
                          context.read<ExploreBloc>().selectedDate.getDisplayedWeekday(),
                          style: kBoldBalooPaaji16.copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: kPadding20),

            /// Paddding is set in the widget, due to the Slider.
            /// Should be reworked with a paint class.
            HourSlider(onChangedEnd: (hour) {
              context.read<ExploreBloc>().add(HourSelected(hour: hour));
            }),
            const SizedBox(height: kPadding20),
            buildCategories(),

            Builder(builder: (context) {
              if (state is GetSpotsLoading) {
                return const Expanded(child: Center(child: CircularProgressIndicator(color: kPrimary)));
              }
              return buildSpotCards();
            }),
          ],
        );
      },
    );
  }

  Widget buildGemButton() {
    User user = context.read<ExploreBloc>().user;
    return Align(
      alignment: Alignment.topRight,
      child: SizedBox(
        height: 25,
        width: 65,
        child: ElevatedButton(
          style: kButtonRoundedStyle,
          onPressed: () {
            Navigator.pushNamed(context, "/home/my_gift");
          },
          child: Row(
            children: [
              const Spacer(),
              Text(
                user.gem.toString(),
                style: kBoldARPDisplay13.copyWith(color: Colors.white),
              ),
              const SizedBox(width: kPadding5),
              SvgPicture.asset("assets/svg/gem.svg"),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCategories() {
    List<Category> categories = context.read<ExploreBloc>().categories;
    Category? selectedCategory = context.read<ExploreBloc>().selectedCategory;

    List<Widget> children = [];
    for (int i = 0; i < categories.length; i++) {
      Category category = categories[i];
      EdgeInsetsGeometry padding = const EdgeInsets.only(right: 10);

      if (i == 0) {
        padding = const EdgeInsets.only(left: 20, right: 10);
      }

      if (i == categories.length - 1) {
        padding = const EdgeInsets.only(right: 20);
      }

      children.add(
        Padding(
          padding: padding,

          /// For the shadow.
          child: Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: selectedCategory != null && category.id == selectedCategory.id ? kSecondary : kUnselected,
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(kPadding10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 0,
                    blurRadius: 3,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(kRadius10),
                  onTap: () {
                    if (selectedCategory != null && category.id == selectedCategory.id) {
                      context.read<ExploreBloc>().add(CategorySelected(category: null));
                    } else {
                      context.read<ExploreBloc>().add(CategorySelected(category: category));
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(kPadding5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        /// UPGRADE: Firebase should not be imported into UI files.
                        /// How could I manage it ?
                        FutureBuilder<String>(
                            future:
                                FirebaseStorage.instance.ref().child("category/${category.imagePath}").getDownloadURL(),
                            builder: (_, snapshot) {
                              if (snapshot.hasData) {
                                return Expanded(
                                  child: CachedNetworkImage(
                                    fit: BoxFit.fitHeight,
                                    imageUrl: snapshot.data!,
                                    placeholder: (context, url) => Container(),
                                    errorWidget: (context, url, error) => Container(),
                                  ),
                                );
                              }
                              return const Spacer();
                            }),
                        const SizedBox(height: 2.5),

                        Text(
                          category.name,
                          style: kRegularBalooPaaji10,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    return SizedBox(
      height: 60,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: children,
        ),
      ),
    );
  }

  Widget buildSpotCards() {
    /// All the spots
    List<Spot> filteredSpots = context.read<ExploreBloc>().filteredSpots;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: kPadding20),
        child: ListView.builder(
            itemCount: filteredSpots.length,
            itemBuilder: (context, index) {
              EdgeInsetsGeometry padding = const EdgeInsets.only(bottom: 10);
              Spot spot = filteredSpots[index];

              if (index == 0) {
                padding = const EdgeInsets.only(top: 20, bottom: 10);
              }

              if (index == filteredSpots.length - 1 && filteredSpots.length > 1) {
                padding = const EdgeInsets.only(bottom: 20);
              }

              return Padding(
                padding: padding,
                child: SpotCard(spot: spot),
              );
            }),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
