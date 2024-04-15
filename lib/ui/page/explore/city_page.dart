import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hoora/bloc/explore/explore_bloc.dart';
import 'package:hoora/model/city_model.dart';
import 'package:hoora/common/decoration.dart';

class CityPage extends StatelessWidget {
  const CityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(kPadding20),
        child: LayoutBuilder(builder: (_, constraints) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
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
              SizedBox(height: constraints.maxHeight * 0.05),
              const FractionallySizedBox(
                widthFactor: 0.8,
                child: Text(
                  "Quelle région voulez vous explorer ?",
                  style: kBoldARPDisplay16,
                  textAlign: TextAlign.center,
                ),
              ),
              const Spacer(),
              FractionallySizedBox(
                widthFactor: 0.5,
                child: Builder(builder: (_) {
                  List<Widget> children = [];
                  for (int i = 0; i < context.read<ExploreBloc>().cities.length; i++) {
                    City city = context.read<ExploreBloc>().cities[i];
                    City selectedCity = context.read<ExploreBloc>().selectedCity;
                    children.add(Padding(
                      padding: const EdgeInsets.all(kPadding10),
                      child: SizedBox(
                        height: 40,
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: city.id == selectedCity.id ? kSecondary : kUnselected,
                          ),
                          onPressed: () {
                            if (selectedCity.id != city.id) {
                              Navigator.pop(context);
                              context.read<ExploreBloc>().add(CitySelected(city: city));
                            }
                          },
                          child: Text(
                            city.name,
                            style: kBoldBalooPaaji16,
                          ),
                        ),
                      ),
                    ));
                  }
                  return Column(children: children);
                }),
              ),
              const Spacer(),
              const FractionallySizedBox(
                widthFactor: 0.8,
                child: Text(
                  "Certaines villes sont actuellement en préparation et seront bientôt disponibles",
                  style: kRegularBalooPaaji12,
                  textAlign: TextAlign.center,
                ),
              ),
              const Spacer(),
            ],
          );
        }),
      )),
    );
  }
}
