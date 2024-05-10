import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hoora/bloc/user/user_bloc.dart';
import 'package:hoora/common/decoration.dart';
import 'package:hoora/model/user_model.dart';

class GemButton extends StatelessWidget {
  final bool isLight;
  const GemButton({super.key, this.isLight = false});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserBloc, UserState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is InitLoading || state is InitFailed) {
          const SizedBox(height: 25);
        }

        User user = context.read<UserBloc>().user;

        return SizedBox(
          height: 25,
          child: ElevatedButton(
            style: isLight ? kButtonRoundedLightStyle : kButtonRoundedStyle,
            onPressed: () {
              Navigator.pushNamed(context, "/home/my_gift");
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: kPadding10),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    user.gem.toString(),
                    style: kBoldARPDisplay13.copyWith(color: isLight ? kPrimary : Colors.white),
                  ),
                  const SizedBox(width: kPadding5),
                  SvgPicture.asset("assets/svg/gem.svg"),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
