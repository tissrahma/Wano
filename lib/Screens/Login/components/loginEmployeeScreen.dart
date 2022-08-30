import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screens/Login/components/EmployeeLogin.dart';
import 'package:flutter_application_1/responsive.dart';

import 'package:flutter_application_1/components /background.dart';

import 'login_screen_top_image.dart';

class loginEmployeeScreen extends StatelessWidget {
  const loginEmployeeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Background(
      child: SingleChildScrollView(
        child: Responsive(
          mobile: const MobileLoginScreen(),
          desktop: Row(
            children: [
              const Expanded(
                child: LoginScreenTopImage(),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    SizedBox(
                      width: 450,
                      child: EmployeeLogin(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MobileLoginScreen extends StatelessWidget {
  const MobileLoginScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const LoginScreenTopImage(),
        Row(
          children: const [
            Spacer(),
            Expanded(
              flex: 8,
              child: EmployeeLogin(),
            ),
            Spacer(),
          ],
        ),
      ],
    );
  }
}
