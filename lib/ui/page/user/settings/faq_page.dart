import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hoora/common/decoration.dart';

class FAQPage extends StatelessWidget {
  const FAQPage({super.key});

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
                  "F.A.Q",
                  style: kBoldARPDisplay14,
                )),
                buildSection(
                  "1. Qu'est-ce que QUEHORA ?",
                  "QUEHORA est une application innovante conçue pour encourager les gens à visiter des spots touristiques pendant les heures creuses. Elle propose une carte interactive affichant les sites touristiques avec des indications de couleur (vert, orange, rouge) pour représenter l'affluence prévue. En visitant ces sites aux moments idéaux, les utilisateurs peuvent gagner des points échangeables contre des avantages chez nos partenaires.",
                ),
                buildSection("2. Comment puis-je créer un compte sur QUEHORA ?",
                    "Pour accéder à QUEHORA, il est nécessaire de télécharger l'application et de créer un compte en utilisant une adresse e-mail valide et un mot de passe. Ce processus permet de sécuriser votre accès et de personnaliser votre expérience."),
                buildSection("3. L'application est-elle gratuite ?",
                    "Oui, QUEHORA est totalement gratuite. Les utilisateurs peuvent gagner des points et les utiliser pour obtenir des avantages exclusifs chez nos partenaires sans frais supplémentaires."),

                buildSection("4. J'ai oublié mon mot de passe. Comment puis-je le récupérer ?",
                    "Si vous avez oublié votre mot de passe, cliquez sur le bouton \"J'ai oublié mon mot de passe\" lors de la connexion. Vous serez guidé à travers les étapes pour récupérer ou modifier votre mot de passe en toute sécurité."),

                buildSection("5. Comment fonctionne le système de points sur QUEHORA ?",
                    "Les points sont attribués en fonction de la différence entre l'affluence actuelle d'un lieu et son affluence moyenne, divisée par le carré de l'affluence moyenne. Plus la visite contribue à réduire l'affluence par rapport à la moyenne, plus vous gagnez de points. Ces points peuvent ensuite être utilisés pour profiter d'offres spéciales de nos partenaires."),

                buildSection("6. Comment puis-je valider ma visite et gagner des points ?",
                    "Pour valider une visite, sélectionnez l'option \"Je valide ma visite\" sur l'application. Vous devrez autoriser QUEHORA à accéder à votre géolocalisation pour confirmer votre présence sur le site touristique. Une fois la visite validée, les points seront ajoutés à votre profil."),

                buildSection("7. Comment puis-je utiliser mes points ?",
                    "Les points accumulés peuvent être dépensés pour profiter d'avantages exclusifs chez nos partenaires. Consultez la page des partenaires sur l'application pour découvrir les offres et promotions disponibles."),
                buildSection("8. Comment puis-je contacter le support de QUEHORA ?",
                    "Pour nous contacter, utilisez l'onglet de feedback dans l'application ou envoyez nous un e-mail directement. Nous sommes toujours à l'écoute de vos commentaires et prêts à vous aider."),

                buildSection("9. L'application est-elle disponible sur iOS et Android ?",
                    "Oui, QUEHORA est disponible à la fois sur iOS et Android, vous permettant d'accéder à nos services peu importe votre appareil."),

                buildSection("10. Comment QUEHORA garantit elle la sécurité et la confidentialité de mes données ?",
                    "Nous prenons la sécurité et la confidentialité des données très au sérieux. QUEHORA collecte des données personnelles conformément aux lois en vigueur, notamment la géolocalisation, à des fins d'analyse et d'amélioration de l'application. Nous avons mis en place des mesures rigoureuses pour garantir la protection de vos données."),
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
