import 'package:flutter/material.dart';

class LoginCard extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool isPassword;

  const LoginCard({
    required this.controller,
    required this.hintText,
    required this.isPassword
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 30),
      child: TextFormField(
        obscureText: isPassword,
        controller: controller,
        decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: hintText,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))),

      ),
    );
  }
}
