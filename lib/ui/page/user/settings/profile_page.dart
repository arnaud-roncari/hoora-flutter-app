import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hoora/bloc/user/user_bloc.dart';
import 'package:hoora/common/alert.dart';
import 'package:hoora/common/decoration.dart';
import 'package:hoora/common/validator.dart';
import 'package:hoora/model/user_model.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late UserBloc userBloc;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nicknameController = TextEditingController();
  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController birthdayController = TextEditingController();
  DateTime? birthday;
  Gender gender = Gender.male;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    userBloc = context.read<UserBloc>();
    emailController.text = userBloc.email;
    nicknameController.text = userBloc.user.nickname;
    lastnameController.text = userBloc.user.lastname;
    firstnameController.text = userBloc.user.firstname;
    cityController.text = userBloc.user.city;
    countryController.text = userBloc.user.country;
    birthday = userBloc.user.birthday;
    birthdayController.text = userBloc.user.birthday == null
        ? ""
        : "${userBloc.user.birthday!.day}/${userBloc.user.birthday!.month}/${userBloc.user.birthday!.year}";

    if (userBloc.user.gender != null) {
      gender = userBloc.user.gender!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSecondary,
      body: BlocConsumer<UserBloc, UserState>(
        listener: (context, state) {
          if (state is UpdateProfileSuccess) {
            Alert.showSuccess(context, "Votre profil a été mis à jour !");
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(kPadding20),
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      /// back button
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            CupertinoIcons.arrow_left,
                            size: 32,
                            color: kPrimary,
                          ),
                        ),
                      ),
                      const Center(
                          child: Text(
                        "Mes informations",
                        style: kBoldARPDisplay14,
                      )),
                      const SizedBox(height: kPadding10),
                      SizedBox(
                        width: 140,
                        child: ElevatedButton(
                          style: kButtonRoundedPrimary3Style,
                          onPressed: state is UpdateProfileLoading
                              ? null
                              : () {
                                  if (formKey.currentState!.validate()) {
                                    userBloc.add(UpdateProfile(
                                      nickname: nicknameController.text,
                                      firstname: firstnameController.text,
                                      lastname: lastnameController.text,
                                      city: cityController.text,
                                      country: countryController.text,
                                      birthday: birthday!,
                                      gender: gender,
                                    ));
                                  }
                                },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: kPadding20, vertical: kPadding10),
                            child: state is UpdateProfileLoading
                                ? const Center(
                                    child: SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        color: kPrimary,
                                      ),
                                    ),
                                  )
                                : const Text(
                                    "Sauvegarder",
                                    style: kBoldBalooPaaji16,
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(height: kPadding20),

                      /// Email
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Email",
                          style: kRegularBalooPaaji14,
                        ),
                      ),
                      const SizedBox(height: kPadding5),
                      TextFormField(
                        readOnly: true,
                        style: kRegularBalooPaaji18,
                        decoration: kTextFieldStyle,
                        controller: emailController,
                      ),
                      const SizedBox(height: kPadding20),

                      /// Nickname
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

                      /// Firstname
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Prénom",
                          style: kRegularBalooPaaji14,
                        ),
                      ),
                      const SizedBox(height: kPadding5),
                      TextFormField(
                        style: kRegularBalooPaaji18,
                        decoration: kTextFieldStyle.copyWith(hintText: "Prénom"),
                        controller: firstnameController,
                        validator: Validator.isNotEmpty,
                      ),
                      const SizedBox(height: kPadding20),

                      /// Lastname
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Nom",
                          style: kRegularBalooPaaji14,
                        ),
                      ),
                      const SizedBox(height: kPadding5),
                      TextFormField(
                        style: kRegularBalooPaaji18,
                        decoration: kTextFieldStyle.copyWith(hintText: "Nom"),
                        controller: lastnameController,
                        validator: Validator.isNotEmpty,
                      ),
                      const SizedBox(height: kPadding20),

                      /// Birthday
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Date de naissance",
                          style: kRegularBalooPaaji14,
                        ),
                      ),
                      const SizedBox(height: kPadding5),
                      TextFormField(
                        readOnly: true,
                        style: kRegularBalooPaaji18,
                        decoration: kTextFieldStyle.copyWith(hintText: "Date de naissance"),
                        controller: birthdayController,
                        validator: Validator.isNotEmpty,
                        onTap: () async {
                          DateTime? date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                          );

                          if (date != null) {
                            setState(() {
                              birthdayController.text = "${date.day}/${date.month}/${date.year}";
                              birthday = date;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: kPadding20),

                      /// Type
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Genre",
                          style: kRegularBalooPaaji14,
                        ),
                      ),
                      const SizedBox(height: kPadding5),

                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(kRadius10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: kPadding10),
                          child: DropdownButton<Gender>(
                              isExpanded: true,
                              dropdownColor: Colors.white,
                              borderRadius: BorderRadius.circular(kRadius10),
                              style: kRegularBalooPaaji18,
                              value: gender,
                              underline: Container(),
                              items: const [
                                DropdownMenuItem(
                                    value: Gender.male,
                                    child: Text(
                                      'Homme',
                                      style: kRegularBalooPaaji18,
                                    )),
                                DropdownMenuItem(
                                    value: Gender.female,
                                    child: Text(
                                      'Femme',
                                      style: kRegularBalooPaaji18,
                                    )),
                                DropdownMenuItem(
                                    value: Gender.other,
                                    child: Text(
                                      'Autre',
                                      style: kRegularBalooPaaji18,
                                    )),
                              ],
                              onChanged: (newGender) {
                                setState(() {
                                  gender = newGender!;
                                });
                              }),
                        ),
                      ),

                      const SizedBox(height: kPadding20),

                      /// City
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Ville",
                          style: kRegularBalooPaaji14,
                        ),
                      ),
                      const SizedBox(height: kPadding5),
                      TextFormField(
                        style: kRegularBalooPaaji18,
                        decoration: kTextFieldStyle.copyWith(hintText: "Ville"),
                        controller: cityController,
                        validator: Validator.isNotEmpty,
                      ),
                      const SizedBox(height: kPadding20),

                      /// Country
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Pays",
                          style: kRegularBalooPaaji14,
                        ),
                      ),
                      const SizedBox(height: kPadding5),
                      TextFormField(
                        style: kRegularBalooPaaji18,
                        decoration: kTextFieldStyle.copyWith(hintText: "Pays"),
                        controller: countryController,
                        validator: Validator.isNotEmpty,
                      ),
                      const SizedBox(height: kPadding20),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String genderToString(Gender gender) {
    if (gender == Gender.male) {
      return "Homme";
    } else if (gender == Gender.female) {
      return "Femme";
    }
    return "Autre";
  }
}
