import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screens/Login/ForgotPassword.dart';
import 'package:flutter_application_1/Screens/menuScreen/ClientEssai.dart';
import 'package:flutter_application_1/Screens/menuScreen/EmployeeScreen.dart';
import 'package:flutter_application_1/components /already_have_an_account_acheck.dart';
import '../../../constants.dart';
import '../../Signup/signup_screen.dart';

class LogIn extends StatefulWidget {
  const LogIn({Key? key}) : super(key: key);
  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  static Future<User?> loginUsingEmail(
      {required String email,
      required String password,
      BuildContext? context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print("No user found for that email");
      }
    }
    return user;
  }

  List<String> list = [];
  @override
  Widget build(BuildContext context) {
    TextEditingController _emailController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();
    String? requiredValidator(String? text) {
      if (text == null || text.trim().isEmpty) {
        return ' this field is required ';
      }
      return null;
    }
    getpos() async {
      if (FirebaseAuth.instance.currentUser?.uid != null) {
        String? _uid = FirebaseAuth.instance.currentUser?.uid;
        final DocumentSnapshot userDoc =
            await FirebaseFirestore.instance.collection('users').doc().get();
        String pos = await userDoc.get('position').toString();
        return pos;
      } else {}
    }
    bool _obscureText = true;
    return Form(
      child: Column(
        children: [
          TextFormField(
            controller: _emailController,
            validator: requiredValidator,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            cursorColor: kPrimaryColor,
            onSaved: (email) {},
            decoration: InputDecoration(
              hintText: "Your email",
              prefixIcon: Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: Icon(Icons.person),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              controller: _passwordController,
              validator: requiredValidator,
              textInputAction: TextInputAction.done,
              obscureText: true,
              cursorColor: kPrimaryColor,
              decoration: InputDecoration(
                hintText: "Your password",
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.lock),
                ),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding),
          FutureBuilder(
              future: getpos(),
              builder: (context, snap) {
                return Hero(
                  tag: "login_btn",
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_emailController.text != "" &&
                          _passwordController.text != "") {
                        try {
                          print("_____________");
                          print(snap.data);
                          UserCredential userCredential = await FirebaseAuth
                              .instance
                              .signInWithEmailAndPassword(
                                  email: _emailController.text,
                                  password: _passwordController.text);
                          if (snap.data == "employee") {
                            print("________________");
                            print(snap.data);
                            await Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => EmployeeScreen()));
                          } else {
                            await Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => ClientEssai()));
                          }
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'user-not-found') {
                            final snackBar = SnackBar(
                              content: const Text("user not found  "),
                              backgroundColor: Colors.red,
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          } else if (e.code == 'wrong-password') {
                            final snackBar = SnackBar(
                              content: const Text("wrong password  "),
                              backgroundColor: Colors.red,
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          } else {
                            final snackBar = SnackBar(
                              content: const Text("something went wrong "),
                              backgroundColor: Colors.red,
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }
                        }
                      } else {
                        final snackBar = SnackBar(
                          content: const Text("plz enter your data  "),
                          backgroundColor: Colors.red,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    },
                    child: Text(
                      "Login".toUpperCase(),
                    ),
                  ),
                );
              }),
          const SizedBox(height: defaultPadding),
          AlreadyHaveAnAccountCheck(
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return SignUpScreen();
                  },
                ),
              );
            },
          ),
          GestureDetector(
              child: Text(
                "Forgot Password ?",
                style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: Colors.deepPurple,
                    fontSize: 15),
              ),
              onTap: () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => ForgotPassword()))),
        ],
      ),
    );
  }
}
