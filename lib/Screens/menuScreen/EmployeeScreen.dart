// ignore_for_file: avoid_print

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_application_1/Screens/Login/login_screen.dart';
import 'package:flutter_application_1/Screens/Signup/signup_screen.dart';
import 'package:flutter_application_1/Screens/menuScreen/EmployeeScreen.dart';
import 'package:flutter_application_1/Screens/menuScreen/addMealForm.dart';
import 'package:flutter_application_1/Screens/menuScreen/view.dart';
import 'package:image_picker/image_picker.dart';
import '../../constants.dart';

import 'ClientScreen.dart';
import 'Complaints.dart';
import 'DataBase.dart';
import 'Navigator.dart';

class EmployeeScreen extends StatefulWidget {
  @override
  _EmployeeScreenState createState() => _EmployeeScreenState();
}

late Map country;
late Database db;
List<String> docId = [];

Future getDocIds() async {
  await FirebaseFirestore.instance.collection('meals').get().then(
        (snapshot) => snapshot.docs.forEach((Document) {
          docId.add(Document.reference.id);
        }),
      );
}

String id = "";
List docs = [];

class _EmployeeScreenState extends State<EmployeeScreen> {
  Future<FirebaseApp> _intializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    return firebaseApp;
  }

  initialise() {
    db = Database();
    db.initiliase();
    db.read().then((value) => {
          setState(() {
            docs = value;
          })
        });
  }

  @override
  void initState() {
    super.initState();
    initialise();
  }

  Future<String> getImage() async {
    User user = FirebaseAuth.instance.currentUser!;
    String _uid = user.uid;
    final DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('meals').doc().get();
    String image = await userDoc.get('image').toString();

    return await image;
  }

  final _formKey = GlobalKey<FormState>();
  Future<DocumentSnapshot<Map<String, dynamic>>> variable =
      FirebaseFirestore.instance.collection('meals').doc().get();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[200],
        title: Text("employee interface "),
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: SingleChildScrollView(
            child: Container(
          height: 700,
          width: 100.0,
          child: Column(children: [NavigatorHeader(), DrawerEmp(context)]),
        )),
      ),
      body: Center(
          child: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: getDocIds(),
              builder: (context, snapshot) {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    return Container(
                      height: 80,
                      child: Card(
                          child: ListTile(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => View(
                                            country: docs[index],
                                            db: db))).then((value) => {
                                      if (value != null) {initialise()}
                                    });

                                tileColor:
                                Colors.deepPurple[200];
                                backgroundColor:
                                Colors.deepPurple[200];
                              },
                              title: Text(docs[index]['name'],
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                      fontSize: 25,
                                      color: Colors.deepPurple[200])),
                              trailing: Text(
                                docs[index]['price'].toString() + "€",
                                style: TextStyle(fontSize: 25),
                              ),
                              leading: CircleAvatar(
                                radius: 40,
                                backgroundImage:
                                    NetworkImage(docs[index]['image']),
                              ))),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: defaultPadding),
          ),
          Container(
            height: 50,
            width: 200,
            child: ElevatedButton(
              onPressed: () async {
                await Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const AddMealForm()));
              },
              child: Text("add a new meal"),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: defaultPadding),
          ),
        ],
      )),
    );
  }
}
