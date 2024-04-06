import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hoora/bloc/auth/auth_bloc.dart';
import 'package:hoora/common/decoration.dart';
import 'package:hoora/common/validator.dart';
import 'package:hoora/widget/button.dart';
import 'package:url_launcher/url_launcher.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController emailController = TextEditingController(text: "arnaud.roncaripro@gmail.com");
  final TextEditingController passwordController = TextEditingController(text: "333333333");
  final TextEditingController confirmPasswordController = TextEditingController(text: "333333333");
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSecondary,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is SignUpSuccess) {
            if (state.isNewUser) {
              Navigator.pushNamed(context, "/auth/sign_up_gift_gems");
            } else {
              Navigator.pushNamed(context, "/home");
            }
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            /// The content of the page is scrollable.
            /// Prevent keyboard opening space.
            /// SafeArea is not used, so the widget go behind the "safe areas".
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Center(
                child: LayoutBuilder(builder: (context, constraints) {
                  return Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(kPadding20),
                      child: Form(
                        key: formKey,
                        child: Column(
                          children: [
                            SizedBox(height: MediaQuery.of(context).padding.top),
                            const Text(
                              "Créer un compte",
                              style: kBoldARPDisplay25,
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: constraints.maxHeight * 0.10),
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Email",
                                style: kRegularBalooPaaji14,
                              ),
                            ),
                            const SizedBox(height: kPadding5),
                            TextFormField(
                              style: kRegularBalooPaaji18,
                              decoration: kTextFieldStyle.copyWith(prefixIcon: const Icon(CupertinoIcons.mail)),
                              controller: emailController,
                              validator: Validator.email,
                            ),
                            const SizedBox(height: kPadding10),
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Mot de passe",
                                style: kRegularBalooPaaji14,
                              ),
                            ),
                            const SizedBox(height: kPadding5),
                            TextFormField(
                              obscureText: true,
                              style: kRegularBalooPaaji18,
                              decoration: kTextFieldStyle.copyWith(
                                  prefixIcon: const Icon(CupertinoIcons.lock), hintText: "Mot de passe"),
                              controller: passwordController,
                              validator: Validator.password,
                            ),
                            const SizedBox(height: kPadding10),
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Confirmez votre mot de passe",
                                style: kRegularBalooPaaji14,
                              ),
                            ),
                            const SizedBox(height: kPadding5),
                            TextFormField(
                              obscureText: true,
                              style: kRegularBalooPaaji18,
                              decoration: kTextFieldStyle.copyWith(
                                  prefixIcon: const Icon(CupertinoIcons.lock), hintText: "Mot de passe"),
                              controller: confirmPasswordController,
                              validator: (_) => Validator.confirmPassword(
                                passwordController.text,
                                confirmPasswordController.text,
                              ),
                            ),
                            const SizedBox(height: kPadding20),
                            Button(
                                isLoading: state is SignUpLoading,
                                text: "Créer mon compte",
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    context.read<AuthBloc>().add(
                                          SignUp(
                                            email: emailController.text,
                                            password: passwordController.text,
                                          ),
                                        );
                                  }
                                }),
                            const SizedBox(height: kPadding20),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(width: kPadding20),
                                Expanded(
                                  child: Divider(
                                    thickness: 1,
                                    color: kPrimary,
                                  ),
                                ),
                                SizedBox(width: kPadding10),
                                Text("Ou", style: kRegularBalooPaaji14),
                                SizedBox(width: kPadding10),
                                Expanded(
                                  child: Divider(
                                    thickness: 1,
                                    color: kPrimary,
                                  ),
                                ),
                                SizedBox(width: kPadding20),
                              ],
                            ),
                            const SizedBox(height: kPadding20),
                            Button(
                                isLoading: state is SignUpWithGoogleLoading,
                                text: "Continuer avec Google",
                                onPressed: () {
                                  context.read<AuthBloc>().add(SignUpWithGoogle());
                                }),
                            if (Platform.isIOS)
                              Column(
                                children: [
                                  const SizedBox(height: kPadding10),
                                  Button(
                                      isLoading: state is SignUpWithAppleLoading,
                                      text: "Continuer avec Apple",
                                      onPressed: () {
                                        context.read<AuthBloc>().add(SignUpWithApple());
                                      }),
                                ],
                              ),
                            const SizedBox(height: kPadding10),
                            SizedBox(
                              height: 20,
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                                onPressed: () {
                                  Navigator.pushNamed(context, "/auth/sign_in");
                                },
                                child: const Text(
                                  "Se connecter",
                                  style: kRegularBalooPaaji14,
                                ),
                              ),
                            ),
                            const SizedBox(height: kPadding20),
                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                style: kRegularBalooPaaji14,
                                children: [
                                  const TextSpan(text: 'En créant votre compte, vous acceptez les '),
                                  TextSpan(
                                      style: kBoldBalooPaaji14,
                                      text: 'Conditions Générales d\'utilisation',
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () async {
                                          Uri url = Uri.parse(
                                              'https://rain-appeal-1ed.notion.site/Conditions-G-n-rales-d-Utilisation-de-HOORA-60df8893f0654d2c95c728d212945d84');

                                          if (!await launchUrl(url)) {
                                            throw Exception('Could not launch $url');
                                          }
                                        }),
                                  const TextSpan(text: ' de ce service et reconnaissez avoir pris connaissance de la '),
                                  TextSpan(
                                      style: kBoldBalooPaaji14,
                                      text: 'Politique de Confidentialité.',
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () async {
                                          Uri url = Uri.parse(
                                              'https://rain-appeal-1ed.notion.site/Politique-de-Confidentialit-de-HOORA-c0d152c43773428e8e350e08514e0a0e');

                                          if (!await launchUrl(url)) {
                                            throw Exception('Could not launch $url');
                                          }
                                        }),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          );
        },
      ),
    );
  }
}
