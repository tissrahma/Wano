import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screens/menuScreen/ClientEssai.dart';
import 'package:flutter_svg/svg.dart';

import '../../constants.dart';
import '../menuScreen/ClientScreen.dart';
import '../menuScreen/Navigator.dart';
import 'login_screen.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

TextEditingController _emailController = TextEditingController();
String? requiredValidator(String? text) {
  if (text == null || text.trim().isEmpty) {
    return ' this field is required ';
  }
  return null;
}

class _ForgotPasswordState extends State<ForgotPassword> {
  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple[200],
          actions: [
            IconButton(
                alignment: Alignment.topLeft,
                icon: Icon(Icons.keyboard_return),
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => LoginScreen()));
                })
          ],
        ),
        body: SingleChildScrollView(
            child: Align(
          alignment: Alignment.center,
          child: Form(
            child: Column(
              children: [
                SizedBox(
                  height: 50,
                ),
                SvgPicture.asset(
                  "assets/icons/email.svg",
                  height: 150,
                ),
                SizedBox(
                  height: 50,
                ),
                Container(
                  height: 20,
                  child: Text(
                    " reset your password ",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.deepPurple,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 35,
                ),
                Container(
                  width: 300,
                  child: TextFormField(
                    controller: _emailController,
                    validator: requiredValidator,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    cursorColor: kPrimaryColor,
                    onSaved: (email) {},
                    decoration: InputDecoration(
                      hintText: "your email ",
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(defaultPadding),
                        child: Icon(Icons.email_outlined),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  width: 300,
                  child: ElevatedButton.icon(
                      onPressed: () async {
                        if (_emailController != null) {
                          try {
                            await FirebaseAuth.instance.sendPasswordResetEmail(
                                email: _emailController.text.trim());
                            final snackBar = SnackBar(
                              content: const Text("an email have been sent ! "),
                              backgroundColor:
                                  Color.fromARGB(255, 166, 238, 168),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => LoginScreen()));
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'user-not-found') {
                              final snackBar = SnackBar(
                                content: const Text("something went wrong   "),
                                backgroundColor: Colors.red,
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            }
                          }
                        }
                        final snackBar = SnackBar(
                          content: const Text("something went wrong   "),
                          backgroundColor: Colors.red,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      },
                      label: Text("Confirm",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold)),
                      icon: Icon(Icons.email_outlined)),
                ),
              ],
            ),
          ),
        )));
  }
}
