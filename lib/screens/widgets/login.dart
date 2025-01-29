import 'package:recipes_app/screens/widgets/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:recipes_app/components/text_input_card.dart';
import 'package:recipes_app/services/auth_service.dart';
import 'package:recipes_app/components/bottom_button.dart';
import '../../constants.dart';

class LoginPage extends StatefulWidget {
  static const String id = "login";
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _handleLogin() async {
    final authService = AuthService(
      email: _emailController.text,
      password: _passwordController.text,
      context: context,
    );
    await authService.logIn();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      child: Scaffold(
        backgroundColor: kprimaryColor,
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Welcome back!",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 15),
              TextInputCard(
                controller: _emailController,
                hintText: "Email",
                isPassword: false,
              ),
              TextInputCard(
                controller: _passwordController,
                hintText: "Password",
                isPassword: true,
              ),
              BottomButton(
                text: "Login",
                authFunction: _handleLogin,
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Not a member?", style: bottomTextStyle),
                  SizedBox(width: 2),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, SignUp.id);
                    },
                    child: Text("Register now", style: bottomTextStyleBlue),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
