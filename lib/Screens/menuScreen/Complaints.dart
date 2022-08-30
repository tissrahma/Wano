import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:flutter_svg/svg.dart';
import 'package:get/get_connect.dart';
import 'package:http/http.dart' as http;
import '../../constants.dart';
import '../Login/login_screen.dart';

import 'ClientScreen.dart';
import 'Navigator.dart';

class Complaints extends StatefulWidget {
  const Complaints({Key? key}) : super(key: key);

  @override
  State<Complaints> createState() => _ComplaintsState();
}

Future sendmail(
    {required String email,
    required String subject,
    required String message}) async {
  final serviceId = 'service_97h3yr7';
  final templateId = 'template_gd4pel2';
  final userId = 'GgGHvc36-pdBUGcoC';
  final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
  final response = await http.post(url,
      headers: {
        'origin': 'http://localhost',
        'Content-Type': 'application/json'
      },
      body: jsonEncode({
        'service_id': serviceId,
        'template_id': templateId,
        'user_id': userId,
        'template_params': {
          'text': subject,
          'user_email': email,
          'title': message
        }
      }));
  print(response.body);
}

TextEditingController _titleController = TextEditingController();
TextEditingController _textController = TextEditingController();
String? requiredValidator(String? text) {
  if (text == null || text.trim().isEmpty) {
    return ' this field is required ';
  }
  return null;
}

String? email = FirebaseAuth.instance.currentUser!.email;

class _ComplaintsState extends State<Complaints> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple[200],
        ),
        drawer: Drawer(
          backgroundColor: Colors.deepPurple,
          child: SingleChildScrollView(
              child: Container(
            height: 700,
            width: 100.0,
            child: Column(children: [NavigatorHeader(), DrawerList(context)]),
          )),
        ),
        body: SingleChildScrollView(
          child: Align(
            alignment: Alignment.center,
            child: Form(
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  SvgPicture.asset(
                    "assets/icons/clinet.svg",
                    height: 170,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: 300,
                    height: 100,
                    child: TextFormField(
                      controller: _titleController,
                      validator: requiredValidator,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      cursorColor: kPrimaryColor,
                      onSaved: (email) {},
                      decoration: InputDecoration(
                        hintText: "Title  :  ",
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(defaultPadding),
                          child: Icon(Icons.headphones),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 300,
                    child: TextFormField(
                      textAlign: TextAlign.left,
                      controller: _textController,
                      validator: requiredValidator,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      cursorColor: kPrimaryColor,
                      onSaved: (email) {},
                      decoration: InputDecoration(
                        alignLabelWithHint: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 50),
                        hintText: "write your complaints  :  ",
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(defaultPadding),
                          child: Icon(Icons.text_fields_rounded),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Container(
                    width: 300,
                    child: ElevatedButton.icon(
                        onPressed: () async {
                          sendmail(
                              email: email.toString(),
                              subject: _titleController.text,
                              message: _textController.text);
                          final snackBar = SnackBar(
                            content: const Text("an email have been sent ! "),
                            backgroundColor: Color.fromARGB(255, 166, 238, 168),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        },
                        label: Text("Send",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold)),
                        icon: Icon(Icons.send_outlined)),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
