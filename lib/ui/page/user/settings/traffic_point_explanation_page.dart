import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hoora/common/decoration.dart';

class TrafficPointExplanationPage extends StatelessWidget {
  const TrafficPointExplanationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(kPadding20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// back button
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
                const Center(
                    child: Text(
                  "Calcul des points",
                  style: kBoldARPDisplay14,
                )),
                const SizedBox(height: kPadding40),
                const Text(
                  "Hoora valorise les visites en heures creuses pour réduire la congestion dans les lieux touristiques et favoriser une expérience de visite optimale. Découvrez le fonctionnement de notre système de points :",
                  style: kRegularBalooPaaji14,
                ),
                buildSection(
                  "1. Sélection du moment et du lieu de votre visite",
                  "En choisissant de visiter pendant les heures creuses, que le lieu soit très fréquenté ou non, vous gagnez des points. Les heures creuses sont des moments moins affluents, permettant une expérience de visite plus agréable.",
                ),
                buildSection("2. Attribution des points en fonction de l'impact",
                    "Les points sont attribués en fonction de votre contribution à la réduction du nombre de visiteurs. Pour cela, nous comparons le nombre de visiteurs attendus lors de votre visite à la moyenne hebdomadaire. Vous gagnez des points uniquement si l'affluence prévue pour votre visite est inférieure à cette moyenne hebdomadaire. En revanche, si l'affluence est égale ou supérieure à la moyenne, aucun point n'est attribué, car la visite ne contribue pas à alléger la fréquentation du site.\n\nHoora utilise des données prévisionnelles d'affluence heure par heure à partir de sources fiables pour chaque site touristique.\n\n\nLes créneaux de visite en dessous de la moyenne d'affluence sont récompensés, plus le créneau est en dessous de cette moyenne, plus le nombre de points accordés est élevé pour encourager les visites durant les périodes de moindre affluences."),

                const SizedBox(height: kPadding40),
                Center(
                  child: FractionallySizedBox(
                    widthFactor: 0.6,
                    child: Image.asset("assets/images/graph_gem.png"),
                  ),
                ),

                buildSection("3. Exemple concret",
                    "Modifier votre visite au musée du Louvre du samedi après-midi au lundi matin réduit significativement l'affluence du week-end. Cette action, en allégeant les pics de fréquentation, vous permet d'obtenir davantage de points."),

                buildSection("4. Importance de votre choix",
                    "Choisir des heures creuses pour vos visites améliore non seulement votre expérience mais joue également un rôle crucial dans la préservation des sites. Cette démarche réduit l'usure des lieux et diminue le besoin de travaux de restauration onéreux, ce qui allège à la fois les coûts et l'impact environnemental. Ainsi, vous participez à un tourisme plus responsable, garantissant la conservation des sites pour l'avenir."),

                buildSection("5. Utilisation de vos points",
                    "Les points que vous gagnez peuvent être échangés contre des avantages auprès de nos partenaires, tels que des réductions ou des accès exclusifs, enrichissant encore plus votre expérience touristique."),

                const SizedBox(height: kPadding20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: kPadding40),
        Text(
          title,
          style: kBoldBalooPaaji14,
        ),
        const SizedBox(height: kPadding20),
        Text(
          content,
          style: kRegularBalooPaaji14,
        ),
      ],
    );
  }
}
