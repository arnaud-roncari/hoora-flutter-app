import 'package:flutter/material.dart';
import 'package:hoora/common/decoration.dart';

class Alert {
  static showError(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          text,
          textAlign: TextAlign.center,
          style: kRegularBalooPaaji20.copyWith(color: Colors.white),
        ),
      ),
    );
  }

  static showSuccess(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: kPrimary,
        content: Text(
          text,
          textAlign: TextAlign.center,
          style: kRegularBalooPaaji20.copyWith(color: Colors.white),
        ),
      ),
    );
  }
}
