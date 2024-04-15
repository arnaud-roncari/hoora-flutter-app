import 'package:flutter/material.dart';

final ThemeData kTheme = ThemeData(inputDecorationTheme: const InputDecorationTheme(errorMaxLines: 10));

const Color kPrimary = Color.fromRGBO(12, 10, 41, 1);
const Color kSecondary = Color.fromRGBO(197, 248, 220, 1);
const Color kBackground = Color.fromRGBO(249, 250, 251, 1);
const Color kNavigationIconSelected = Color.fromRGBO(161, 154, 255, 1);
const Color kUnselected = Color.fromRGBO(241, 240, 255, 1);
const Color kGemsIndicator = Color.fromRGBO(241, 240, 255, 1);

const double kPadding40 = 40;
const double kPadding20 = 20;
const double kPadding10 = 10;
const double kPadding5 = 5;

const double kRadius10 = 10;
const double kRadius100 = 100;

const TextStyle kBoldARPDisplay25 = TextStyle(
  fontFamily: "ARPDisplay",
  fontSize: 25,
  fontWeight: FontWeight.w900,
  color: kPrimary,
  height: 1,
);

const TextStyle kBoldARPDisplay20 = TextStyle(
  fontFamily: "ARPDisplay",
  fontSize: 20,
  fontWeight: FontWeight.w900,
  color: kPrimary,
  height: 1,
);

const TextStyle kBoldARPDisplay14 = TextStyle(
  fontFamily: "ARPDisplay",
  fontSize: 14,
  fontWeight: FontWeight.w900,
  color: kPrimary,
  height: 1,
);

const TextStyle kBoldARPDisplay16 = TextStyle(
  fontFamily: "ARPDisplay",
  fontSize: 16,
  fontWeight: FontWeight.w900,
  color: kPrimary,
  height: 1,
);

const TextStyle kBoldARPDisplay13 = TextStyle(
  fontFamily: "ARPDisplay",
  fontSize: 13,
  fontWeight: FontWeight.w900,
  color: kPrimary,
  height: 1,
);

const TextStyle kRegularBalooPaaji20 = TextStyle(
  fontFamily: "BalooPaaji",
  fontSize: 20,
  fontWeight: FontWeight.w400,
  color: kPrimary,
  height: 1,
);

const TextStyle kBoldBalooPaaji16 = TextStyle(
  fontFamily: "BalooPaaji",
  fontSize: 16,
  fontWeight: FontWeight.w900,
  color: kPrimary,
  height: 1,
);
const TextStyle kBoldBalooPaaji20 = TextStyle(
  fontFamily: "BalooPaaji",
  fontSize: 20,
  fontWeight: FontWeight.w900,
  color: kPrimary,
  height: 1,
);

const TextStyle kRegularBalooPaaji10 = TextStyle(
  fontFamily: "BalooPaaji",
  fontSize: 10,
  fontWeight: FontWeight.w400,
  color: kPrimary,
  height: 1,
);

const TextStyle kRegularBalooPaaji12 = TextStyle(
  fontFamily: "BalooPaaji",
  fontSize: 12,
  fontWeight: FontWeight.w400,
  color: kPrimary,
  height: 1,
);

const TextStyle kRegularBalooPaaji14 = TextStyle(
  fontFamily: "BalooPaaji",
  fontSize: 14,
  fontWeight: FontWeight.w400,
  color: kPrimary,
  height: 1,
);

const TextStyle kRegularBalooPaaji16 = TextStyle(
  fontFamily: "BalooPaaji",
  fontSize: 16,
  fontWeight: FontWeight.w400,
  color: kPrimary,
  height: 1,
);

const TextStyle kBoldBalooPaaji10 = TextStyle(
  fontFamily: "BalooPaaji",
  fontSize: 10,
  fontWeight: FontWeight.w900,
  color: kPrimary,
  height: 1,
);

const TextStyle kBoldBalooPaaji14 = TextStyle(
  fontFamily: "BalooPaaji",
  fontSize: 14,
  fontWeight: FontWeight.w900,
  color: kPrimary,
  height: 1,
);

const TextStyle kRegularBalooPaaji18 = TextStyle(
  fontFamily: "BalooPaaji",
  fontSize: 18,
  fontWeight: FontWeight.w400,
  color: kPrimary,
  height: 1,
);

InputDecoration kTextFieldStyle = InputDecoration(
  hintText: "Email",
  hintStyle: kRegularBalooPaaji18.copyWith(
    color: Colors.black.withOpacity(0.5),
  ),
  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(kRadius10),
    borderSide: const BorderSide(
      width: 0,
      style: BorderStyle.none,
    ),
  ),
  fillColor: Colors.white,
  filled: true,
);

ButtonStyle kButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: kPrimary,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(kRadius10),
  ),
  disabledBackgroundColor: kPrimary,
  padding: EdgeInsets.zero,
  minimumSize: Size.zero,
);

ButtonStyle kButtonRoundedStyle = ElevatedButton.styleFrom(
  backgroundColor: kPrimary,
  shape: const StadiumBorder(),
  disabledBackgroundColor: kPrimary,
  padding: EdgeInsets.zero,
  minimumSize: Size.zero,
);
