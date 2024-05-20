import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hoora/bloc/user/user_bloc.dart';
import 'package:hoora/common/alert.dart';
import 'package:hoora/common/decoration.dart';
import 'package:hoora/common/validator.dart';
import 'package:lottie/lottie.dart';

class NicknamePage extends StatefulWidget {
  const NicknamePage({super.key});

  @override
  State<NicknamePage> createState() => _NicknamePageState();
}

class _NicknamePageState extends State<NicknamePage> {
  final TextEditingController nicknameController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserBloc, UserState>(
      listener: (context, state) {
        if (state is SetNicknameFailed) {
          Alert.showError(context, state.exception.message);
        }

        if (state is SetNicknameSuccess) {
          Navigator.pushReplacementNamed(context, "/home");
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: kSecondary,
          body: SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Padding(
                padding: const EdgeInsets.all(kPadding20),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      SizedBox(height: MediaQuery.of(context).padding.top),
                      const FractionallySizedBox(
                        child: Text(
                          "Comment on vous appelle ? !",
                          textAlign: TextAlign.center,
                          style: kBoldARPDisplay25,
                        ),
                      ),
                      const Spacer(),
                      SizedBox(
                        height: 160,
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.topCenter,
                              child: LottieBuilder.asset(
                                "assets/animations/gem.json",
                                height: 125,
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: SizedBox(
                                height: 125,
                                width: 125,
                                child: SvgPicture.asset("assets/svg/ranking_gem.svg"),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: kPadding20),
                      const Text(
                        "Choisissez le nom avec\nlequel  vous apparaîtrez\ndans notre classement.",
                        style: kBoldARPDisplay14,
                        textAlign: TextAlign.center,
                      ),
                      const Spacer(
                        flex: 2,
                      ),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Pseudo",
                          style: kRegularBalooPaaji14,
                        ),
                      ),
                      const SizedBox(height: kPadding5),
                      TextFormField(
                        style: kRegularBalooPaaji18,
                        decoration: kTextFieldStyle.copyWith(hintText: "Pseudo"),
                        controller: nicknameController,
                        validator: Validator.isNotEmpty,
                      ),
                      const SizedBox(height: kPadding20),
                      SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: ElevatedButton(
                          style: kButtonRoundedStyle,
                          onPressed: state is SetNicknameLoading
                              ? null
                              : () {
                                  if (formKey.currentState!.validate()) {
                                    context.read<UserBloc>().add(
                                          SetNickname(
                                            nickname: nicknameController.text,
                                          ),
                                        );
                                  }
                                },
                          child: state is SetNicknameLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(color: Colors.white),
                                )
                              : Text(
                                  "C'est partiiiii !",
                                  style: kBoldBalooPaaji16.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                      SizedBox(height: MediaQuery.of(context).padding.bottom),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
