import 'package:flutter/material.dart';
import 'package:hoora/common/decoration.dart';

class EarningsPage extends StatelessWidget {
  const EarningsPage({super.key});

// ajoute rle bottom padding a la fin
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: kPadding20),
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).padding.top),

            const SizedBox(
              height: kPadding20,
            )
            // sized box 20
          ],
        ),
      ),
    );
  }
}
