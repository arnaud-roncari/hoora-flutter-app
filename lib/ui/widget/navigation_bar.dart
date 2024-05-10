import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hoora/common/decoration.dart';
import 'package:lottie/lottie.dart';

class Navigation extends StatefulWidget {
  final void Function(int index) onChanged;
  const Navigation({super.key, required this.onChanged});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int currentIndex = 0;

  void onPressed(int index) {
    if (index != currentIndex) {
      currentIndex = index;
      widget.onChanged(index);
    }
  }

  Widget _buildButton(String svgPath, int index) {
    return InkWell(
      borderRadius: BorderRadius.circular(kRadius100),
      onTap: () => onPressed(index),
      child: SizedBox(
        height: 50,
        width: 50,
        child: Center(
          child: SvgPicture.asset(
            "assets/svg/$svgPath",
            height: 26,
            colorFilter: index == currentIndex
                ? const ColorFilter.mode(kNavigationIconSelected, BlendMode.srcIn)
                : const ColorFilter.mode(kPrimary, BlendMode.srcIn),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _buildButton("explore.svg", 0),
          _buildButton("gift.svg", 1),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 65,
                width: 65,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(kRadius100),
                  color: kBackground,
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
                  borderRadius: BorderRadius.circular(kRadius100),
                  color: kBackground,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(kRadius100),
                    onTap: () => onPressed(2),
                    child: Center(
                      child: Container(
                        height: 55,
                        width: 55,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(kRadius100),
                          color: kPrimary,
                        ),
                        child: Lottie.asset("assets/animations/gem.json"),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 5),
            ],
          ),
          _buildButton("challenge.svg", 3),
          _buildButton("ranking.svg", 4),
        ],
      ),
    );
  }
}
