import 'package:flutter/material.dart';
class Button extends StatelessWidget {
  const Button({

    required this.text,
    required this.authFunction,
  });
final String text;
final VoidCallback authFunction;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 29),
      child: GestureDetector(
        onTap: authFunction,
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(text,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18
              ),
            ),
          ),
        ),
      ),
    );
  }
}