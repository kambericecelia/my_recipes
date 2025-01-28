
import 'package:flutter/material.dart';
import 'package:recipes_app/components/login_card.dart';
import 'package:recipes_app/services/auth_service.dart';
import 'package:recipes_app/components/bottom_button.dart';
import '../../constants.dart';
import 'login_page.dart';


class SignUp extends StatefulWidget {
  static const String id = "sign_up";

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();


  Future<void> _handleSignUp() async {
    final authService = AuthService(email: _emailController.text, password: _passwordController.text, context: context,
        );
    await authService.signUp(_confirmPasswordController.text);
    _emailController.clear();
    _passwordController.clear();
    _confirmPasswordController.clear();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kprimaryColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 90),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Welcome", style: welcomeTextStyle),
                SizedBox(height: 15),
                LoginCard(controller: _emailController, hintText: "Email", isPassword: false,),
                LoginCard(
                    controller: _passwordController, hintText: "Password", isPassword: true,),
                LoginCard(
                    controller: _confirmPasswordController,
                    hintText: "Confirm password", isPassword: true,),
                Button(text: "Sign Up", authFunction: _handleSignUp),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already a member?", style: bottomTextStyle),
                    SizedBox(width: 5),
                    TextButton(
                      onPressed: () {

                        Navigator.pushNamed(context, LoginPage.id);
                      },
                      child: Text("Log in", style: bottomTextStyleBlue),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
