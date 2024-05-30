import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hoora/common/decoration.dart';
import 'package:hoora/common/extension/hour_extension.dart';
import 'package:hoora/model/hours_model.dart';
import 'package:hoora/model/open_hours_model.dart';
import 'package:hoora/model/spot_model.dart';
import 'package:hoora/model/tarification_model.dart';
import 'package:hoora/ui/widget/map/gallery.dart';
import 'package:hoora/ui/widget/explore/hour_slider.dart';
import 'package:hoora/ui/widget/map/suggested_day.dart';
import 'package:hoora/ui/widget/map/tarification.dart';
import 'package:hoora/ui/widget/map/tips.dart';
import 'package:url_launcher/url_launcher.dart';

class SpotPage extends StatefulWidget {
  final Spot spot;
  const SpotPage({super.key, required this.spot});

  @override
  State<SpotPage> createState() => _SpotPageState();
}

class _SpotPageState extends State<SpotPage> {
  PageController controller = PageController();
  int currentIndex = 0;
  late int intensity;
  late int hour;

  @override
  void initState() {
    super.initState();
    hour = DateTime.now().getFormattedHour();

    intensity = calculateIntensity();
  }

  @override
  Widget build(BuildContext context) {
    Spot spot = widget.spot;
    return Scaffold(
      backgroundColor: kBackground,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(kPadding20),
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).padding.top,
                ),

                /// Back button
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

                /// Pictures
                const SizedBox(height: kPadding20),
                if (widget.spot.imageGalleryPaths.length > 1)
                  Padding(
                    padding: const EdgeInsets.only(bottom: kPadding20),
                    child: Gallery(spot: spot),
                  ),
                Text(spot.type, style: kRegularNunito16, textAlign: TextAlign.center),
                const SizedBox(height: kPadding10),
                Text(spot.name, style: kBoldARPDisplay16, textAlign: TextAlign.center),
                const SizedBox(height: kPadding10),
                Text(spot.cityName, style: kRegularNunito16, textAlign: TextAlign.center),
                const SizedBox(height: kPadding10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 30,
                      decoration: BoxDecoration(
                        color: kPrimary,
                        borderRadius: BorderRadius.circular(kRadius100),
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: kPadding10),
                          child: Text(
                            getVisitDuration(),
                            style: kBoldNunito16.copyWith(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: kPadding10),
                    Container(
                      height: 30,
                      decoration: BoxDecoration(
                        color: kPrimary,
                        borderRadius: BorderRadius.circular(kRadius100),
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: kPadding10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(
                                CupertinoIcons.star_fill,
                                color: Colors.yellow,
                                size: 20,
                              ),
                              const SizedBox(width: kPadding5),
                              Text(
                                spot.rating.toString(),
                                style: kBoldNunito16.copyWith(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: kPadding20),
                Text(spot.description, style: kRegularNunito16, textAlign: TextAlign.center),
                const SizedBox(height: kPadding40),
                const Text("Quel jour privilégier ?", style: kBoldARPDisplay16, textAlign: TextAlign.center),
                const SizedBox(height: kPadding20),
                buildSuggestedDay(),
                const SizedBox(height: kPadding40),
                const Text("Quel moment privilégier ?", style: kBoldARPDisplay16, textAlign: TextAlign.center),
                const SizedBox(height: kPadding20),

                /// ISO
                LayoutBuilder(builder: (context, constraint) {
                  return SizedBox(
                    height: constraint.maxWidth * 0.6,
                    width: constraint.maxWidth * 0.6,
                    child: FutureBuilder<String>(
                        future: FirebaseStorage.instance
                            .ref()
                            .child("spot/iso/${widget.spot.imageIsoPath}")
                            .getDownloadURL(),
                        builder: (_, snapshot) {
                          if (snapshot.hasData) {
                            return CachedNetworkImage(
                              imageUrl: snapshot.data!,
                              fit: BoxFit.fitWidth,
                              placeholder: (context, url) => Container(),
                              errorWidget: (context, url, error) => Container(),
                              imageBuilder: (context, imageProvider) => LayoutBuilder(builder: (_, constraint) {
                                return Container(
                                    width: constraint.maxWidth,
                                    constraints: BoxConstraints(
                                      maxWidth: constraint.maxWidth,
                                      maxHeight: constraint.maxWidth,
                                    ),
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    child: Stack(
                                      children: [
                                        if (spot.isClosedAt(DateTime.now().copyWith(hour: hour)))
                                          Center(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                const Spacer(),
                                                SvgPicture.asset(
                                                  "assets/svg/lock.svg",
                                                  height: 30,
                                                ),
                                                const SizedBox(height: kPadding10),
                                                Container(
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius: BorderRadius.circular(
                                                        kRadius100,
                                                      )),
                                                  child: const Padding(
                                                    padding: EdgeInsets.symmetric(
                                                        horizontal: kPadding10, vertical: kPadding5),
                                                    child: Text(
                                                      "Fermé",
                                                      style: kRegularNunito16,
                                                    ),
                                                  ),
                                                ),
                                                const Spacer(),
                                              ],
                                            ),
                                          ),
                                        if (!spot.isClosedAt(DateTime.now().copyWith(hour: hour)) && intensity > 1)
                                          Image.asset(
                                            'assets/images/intensity_$intensity.png',
                                            height: constraint.maxWidth,
                                            width: constraint.maxWidth,
                                          ),
                                      ],
                                    ));
                              }),
                            );
                          }
                          return LayoutBuilder(builder: (_, constraint) {
                            return Container(
                              constraints: BoxConstraints(
                                maxWidth: constraint.maxWidth,
                                maxHeight: constraint.maxWidth,
                              ),
                            );
                          });
                        }),
                  );
                }),
                const SizedBox(height: kPadding20),
                HourSlider(
                  initialHour: hour,
                  onChanged: (hour) {
                    setState(() {
                      this.hour = hour;
                      intensity = calculateIntensity();
                    });
                  },
                ),
                const SizedBox(height: kPadding40),
                const Text("Heures d'ouverture", style: kBoldARPDisplay16, textAlign: TextAlign.center),
                const SizedBox(height: kPadding20),
                buildOpenHours(),
                const SizedBox(height: kPadding40),
                const Text("Tarifs ?", style: kBoldARPDisplay16, textAlign: TextAlign.center),
                const SizedBox(height: kPadding20),
                buildTarifications(),
                const SizedBox(height: kPadding40),
                const Text("Astuce de voyageurs ?", style: kBoldARPDisplay16, textAlign: TextAlign.center),
                const SizedBox(height: kPadding20),
                Tips(spot: widget.spot),
                const SizedBox(height: kPadding40),
                const Text("A ne pas manquer !", style: kBoldARPDisplay16, textAlign: TextAlign.center),
                const SizedBox(height: kPadding20),
                buildHighlights(),
                const SizedBox(height: kPadding40),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: SizedBox(
                    height: 37,
                    width: 130,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kSecondary,
                          padding: EdgeInsets.zero,
                        ),
                        onPressed: () async {
                          Uri url = Uri.parse(widget.spot.website);

                          if (!await launchUrl(url)) {
                            throw Exception('Could not launch $url');
                          }
                        },
                        child: Row(
                          children: [
                            const Spacer(),
                            SvgPicture.asset("assets/svg/website.svg"),
                            const SizedBox(width: kPadding10),
                            const Text(
                              "Site Web",
                              style: kBoldNunito16,
                            ),
                            const Spacer(),
                          ],
                        )),
                  ),
                ),
                const SizedBox(height: kPadding20),
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                      style: kButtonRoundedStyle,
                      onPressed: () async {
                        Uri url = Uri.parse(
                            'https://www.google.com/maps/search/?api=1&query=France, ${widget.spot.cityName}, ${widget.spot.name}');

                        if (!await launchUrl(url)) {
                          throw Exception('Could not launch $url');
                        }
                      },
                      child: Text(
                        "Ouvrir Google Maps",
                        style: kBoldNunito16.copyWith(color: Colors.white),
                      )),
                ),
                SizedBox(
                  height: MediaQuery.of(context).padding.bottom,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Return an intensity, based on the a calculated average, based on all popular times of the selected hour.
  int calculateIntensity() {
    double average = 0;
    int total = 0;

    /// Average of all popular time, of the selected hours.
    for (int i = 0; i < widget.spot.popularTimes.length; i++) {
      Map<String, int> pt = widget.spot.popularTimes[i];

      /// closed hours are not taken into account.
      if (widget.spot.openHours[i].hours.isEmpty) {
        continue;
      }

      int val = pt[hour.toString()]!;
      if (val > 0) {
        average += val;
        total++;
      }
    }
    average = average / total;

    int density = widget.spot.getDensityNow();

    /// Based on given documentation.
    List<List<int>> matrice = [
      [1, 2, 3, 4, 5],
      [2, 3, 4, 5, 6],
      [3, 4, 5, 6, 7],
      [4, 5, 6, 7, 8],
      [5, 6, 7, 8, 9],
    ];

    if (average < 20) {
      return matrice[density - 1][0];
    }

    if (average < 40) {
      return matrice[density - 1][1];
    }

    if (average < 60) {
      return matrice[density - 1][2];
    }

    if (average < 80) {
      return matrice[density - 1][3];
    }
    return matrice[density - 1][4];
  }

  String getVisitDuration() {
    int hour = int.parse(widget.spot.visitDuration.split(":")[0]);
    int minute = int.parse(widget.spot.visitDuration.split(":")[1]);

    if (hour < 1) {
      return '$minute min';
    }

    if (minute < 15) {
      return '${hour}h';
    }

    return '${hour}h$minute';
  }

  Widget buildTarifications() {
    List<Widget> children = [];
    TarificationModel? fullP = widget.spot.fullPrice;
    TarificationModel? reducedP = widget.spot.reducedPrice;
    TarificationModel? freeP = widget.spot.freePrice;

    if (fullP != null) {
      children.add(
        Tarification(svgPath: "assets/svg/full.svg", data: fullP),
      );
    }

    if (reducedP != null) {
      children.add(
        Tarification(svgPath: "assets/svg/reduce.svg", data: reducedP),
      );
    }

    if (freeP != null) {
      children.add(
        Tarification(svgPath: "assets/svg/free.svg", data: freeP),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: children,
    );
  }

  Widget buildSuggestedDay() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SuggestedDay(weekday: 1, title: "Lun.", spot: widget.spot),
        SuggestedDay(weekday: 2, title: "Mar.", spot: widget.spot),
        SuggestedDay(weekday: 3, title: "Mer.", spot: widget.spot),
        SuggestedDay(weekday: 4, title: "Jeu.", spot: widget.spot),
        SuggestedDay(weekday: 5, title: "Ven.", spot: widget.spot),
        SuggestedDay(weekday: 6, title: "Sam.", spot: widget.spot),
        SuggestedDay(weekday: 7, title: "Dim.", spot: widget.spot),
      ],
    );
  }

  Widget buildHighlights() {
    List<Widget> children = [];

    for (int i = 0; i < widget.spot.highlights.length; i++) {
      String h = widget.spot.highlights[i];
      children.add(Row(
        children: [
          const Icon(
            CupertinoIcons.check_mark,
            color: kPrimary,
          ),
          const SizedBox(width: kPadding5),
          Text(
            h,
            style: kRegularNunito16,
          )
        ],
      ));
    }

    return IntrinsicWidth(child: Column(children: children));
  }

  Widget buildOpenHours() {
    List<String> stringifiedHours = [];

    for (int i = 0; i < widget.spot.openHours.length; i++) {
      OpenHours oh = widget.spot.openHours[i];
      String str = "";
      for (int j = 0; j < oh.hours.length; j++) {
        Hours hours = oh.hours[j];

        if (oh.hours.length > 1) {
          if (j > 0 || j == oh.hours.length - 1) {
            str += "  ";
          }
        }

        str += "${hours.start.length < 5 ? "0" : ""}${hours.start}-${hours.end}";
      }
      stringifiedHours.add(str);
    }

    return IntrinsicWidth(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const SizedBox(width: 80, child: Text("Lundi", style: kRegularNunito16)),
              const SizedBox(width: kPadding20),
              Text(!stringifiedHours[0].contains(":") ? "Fermé" : stringifiedHours[0], style: kRegularNunito16),
            ],
          ),
          const SizedBox(height: kPadding5),
          Row(
            children: [
              const SizedBox(width: 80, child: Text("Mardi", style: kRegularNunito16)),
              const SizedBox(width: kPadding20),
              Text(!stringifiedHours[1].contains(":") ? "Fermé" : stringifiedHours[1], style: kRegularNunito16),
            ],
          ),
          const SizedBox(height: kPadding5),
          Row(
            children: [
              const SizedBox(width: 80, child: Text("Mercredi", style: kRegularNunito16)),
              const SizedBox(width: kPadding20),
              Text(!stringifiedHours[2].contains(":") ? "Fermé" : stringifiedHours[2], style: kRegularNunito16),
            ],
          ),
          const SizedBox(height: kPadding5),
          Row(
            children: [
              const SizedBox(width: 80, child: Text("Jeudi", style: kRegularNunito16)),
              const SizedBox(width: kPadding20),
              Text(!stringifiedHours[3].contains(":") ? "Fermé" : stringifiedHours[3], style: kRegularNunito16),
            ],
          ),
          const SizedBox(height: kPadding5),
          Row(
            children: [
              const SizedBox(width: 80, child: Text("Vendredi", style: kRegularNunito16)),
              const SizedBox(width: kPadding20),
              Text(!stringifiedHours[4].contains(":") ? "Fermé" : stringifiedHours[4], style: kRegularNunito16),
            ],
          ),
          const SizedBox(height: kPadding5),
          Row(
            children: [
              const SizedBox(width: 80, child: Text("Samedi", style: kRegularNunito16)),
              const SizedBox(width: kPadding20),
              Text(!stringifiedHours[5].contains(":") ? "Fermé" : stringifiedHours[5], style: kRegularNunito16),
            ],
          ),
          const SizedBox(height: kPadding5),
          Row(
            children: [
              const SizedBox(width: 80, child: Text("Dimanche", style: kRegularNunito16)),
              const SizedBox(width: kPadding20),
              Text(!stringifiedHours[6].contains(":") ? "Fermé" : stringifiedHours[6], style: kRegularNunito16),
            ],
          ),
        ],
      ),
    );
  }
}
