import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hoora/bloc/auth/auth_bloc.dart';
import 'package:hoora/bloc/first_launch/first_launch_bloc.dart';
import 'package:hoora/common/decoration.dart';
import 'package:hoora/common/globals.dart';
import 'package:hoora/page/auth/forgot_password.dart';
import 'package:hoora/page/auth/sign_in.dart';
import 'package:hoora/page/auth/sign_up.dart';
import 'package:hoora/page/auth/sign_up_gift_gems.dart';
import 'package:hoora/page/first_launch/explanation_page.dart';
import 'package:hoora/page/first_launch/welcome_page.dart';
import 'package:hoora/page/first_launch/request_geolocation_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hoora/page/home_page.dart';
import 'package:hoora/repository/auth_repository.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Set the application oriention to portrait only.
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  /// Null if first time lauching.
  String? isFirstLaunch = await const FlutterSecureStorage().read(key: kSSKeyFirstLaunch);

  User? user = FirebaseAuth.instance.currentUser;
  String initialRoute = user != null ? "/home" : "/auth/sign_up";
  if (isFirstLaunch == null) {
    initialRoute = "/first_launch/welcome";
  }

  runApp(HooraApp(initialRoute: initialRoute));
}

class HooraApp extends StatelessWidget {
  final String initialRoute;
  const HooraApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(create: (context) => AuthRepository()),
      ],
      child: Builder(builder: (context) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => FirstLaunchBloc(),
            ),
            BlocProvider(
              create: (_) => AuthBloc(authRepository: context.read<AuthRepository>()),
            ),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: kTheme,
            title: 'Hoora',
            initialRoute: initialRoute,
            // initialRoute: '/first_launch/welcome',
            routes: {
              '/first_launch/welcome': (context) => const WelcomePage(),
              '/first_launch/request_geolocation': (context) => const RequestGeolocationPage(),
              '/first_launch/explanation': (context) => const ExplanationPage(),
              '/auth/sign_in': (context) => const SignInPage(),
              '/auth/sign_up': (context) => const SignUpPage(),
              '/auth/sign_up_gift_gems': (context) => const SignUpGiftGemsPage(),
              '/auth/forgot_password': (context) => const ForgotPasswordPage(),
              '/home': (context) => const HomePage(),
            },
          ),
        );
      }),
    );
  }
}
