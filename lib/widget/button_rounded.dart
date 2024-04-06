import 'package:flutter/material.dart';
import 'package:hoora/common/decoration.dart';

class ButtonRounded extends StatelessWidget {
  final String text;
  final void Function()? onPressed;
  final bool isLoading;
  const ButtonRounded({super.key, required this.text, required this.onPressed, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: kPrimary,
          shape: const StadiumBorder(),
          disabledBackgroundColor: kPrimary,
        ),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(color: Colors.white),
              )
            : Text(
                text,
                style: kBoldBalooPaaji16.copyWith(
                  color: Colors.white,
                ),
              ),
      ),
    );
  }
}
