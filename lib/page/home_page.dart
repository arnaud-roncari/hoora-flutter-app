import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hoora/bloc/auth/auth_bloc.dart';
import 'package:hoora/common/decoration.dart';
import 'package:hoora/widget/button.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      body: SafeArea(
        child: Button(
          onPressed: () {
            context.read<AuthBloc>().add(SignOut());
          },
          text: "Signout",
        ),
      ),
    );
  }
}
