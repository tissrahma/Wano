import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants.dart';

class Showpwd extends StatefulWidget {
  const Showpwd({Key? key}) : super(key: key);

  @override
  State<Showpwd> createState() => _ShowpwdState();
}

bool _obscureText = true;

class _ShowpwdState extends State<Showpwd> {
  @override
  Widget build(BuildContext context) {
    return Form(
        child: TextFormField(
            decoration: InputDecoration(
      suffixIcon: GestureDetector(
        onTap: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
        child: Icon(
          _obscureText ? Icons.visibility : Icons.visibility_off,
        ),
      ),
    )));
  }
}
