import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screens/menuScreen/ClientScreen.dart';
import 'package:flutter_application_1/Screens/menuScreen/ClientScreen.dart';

import '../../constants.dart';
import 'ClientScreen.dart';
import 'DataBase.dart';
import 'Navigator.dart';

class ShowCommande extends StatefulWidget {
  late Database db;
  Map? country;

  @override
  _ShowCommandeState createState() => _ShowCommandeState();
}

late Map country;
Future<String> getClient() async {
  User user = FirebaseAuth.instance.currentUser!;
  String _uid = user.uid;
  final DocumentSnapshot userDoc =
      await FirebaseFirestore.instance.collection('commande').doc(_uid).get();
  String _name = await userDoc.get('client').toString();

  return await _name;
}

Future<String> getAddress() async {
  User user = FirebaseAuth.instance.currentUser!;
  String _uid = user.uid;
  final DocumentSnapshot userDoc =
      await FirebaseFirestore.instance.collection('commande').doc(_uid).get();
  String _name = await userDoc.get('address').toString();

  return await _name;
}

Future<String> getPhone() async {
  User user = FirebaseAuth.instance.currentUser!;
  String _uid = user.uid;
  final DocumentSnapshot userDoc =
      await FirebaseFirestore.instance.collection('commande').doc(_uid).get();
  String _name = await userDoc.get('phone').toString();

  return await _name;
}

Future<String> getname() async {
  User user = FirebaseAuth.instance.currentUser!;
  String _uid = user.uid;
  final DocumentSnapshot userDoc =
      await FirebaseFirestore.instance.collection('commande').doc(_uid).get();
  String _name = await userDoc.get('name').toString();

  return await _name;
}

Future<String> getPrice() async {
  User user = FirebaseAuth.instance.currentUser!;
  String _uid = user.uid;
  final DocumentSnapshot userDoc =
      await FirebaseFirestore.instance.collection('commande').doc(_uid).get();
  String _name = await userDoc.get('price').toString();

  return await _name;
}

class _ShowCommandeState extends State<ShowCommande> {
  @override
  void initState() {
    super.initState();
    print(widget.country);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[200],
        title: Text(" Order Details "),
        actions: [
          GestureDetector(
            child: Icon(Icons.logout),
          )
        ],
      ),
      drawer: Drawer(
        backgroundColor: Colors.deepPurple,
        child: SingleChildScrollView(
          child: Column(children: [NavigatorHeader(), DrawerList(context)]),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          width: double.infinity,
          height: 200,
          padding: EdgeInsets.only(top: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 30,
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.deepPurple[200],
                    border: Border.all(),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                padding: EdgeInsets.all(10),
                height: 50,
                width: 300,
                child: FutureBuilder<String?>(
                  future: getClient(),
                  builder: (context, AsyncSnapshot<String?> snap) {
                    if (snap.hasData) {
                      return Text(
                        "your name:" + snap.data.toString(),
                        style: TextStyle(color: Colors.black, fontSize: 15),
                        textAlign: TextAlign.center,
                      );
                    } else {
                      return Text('Loading data');
                    }
                  },
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.deepPurple[200],
                    border: Border.all(),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                padding: EdgeInsets.all(10),
                height: 50,
                width: 300,
                child: FutureBuilder<String?>(
                  future: getAddress(),
                  builder: (context, AsyncSnapshot<String?> snap) {
                    if (snap.hasData) {
                      return Text(
                        "your address :" + snap.data.toString(),
                        style: TextStyle(color: Colors.black, fontSize: 15),
                        textAlign: TextAlign.center,
                      );
                    } else {
                      return Text('Loading data');
                    }
                  },
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.deepPurple[200],
                    border: Border.all(),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                padding: EdgeInsets.all(10),
                height: 50,
                width: 300,
                child: FutureBuilder<String?>(
                  future: getPhone(),
                  builder: (context, AsyncSnapshot<String?> snap) {
                    if (snap.hasData) {
                      return Text(
                        "your phone number :" + snap.data.toString(),
                        style: TextStyle(color: Colors.black, fontSize: 15),
                        textAlign: TextAlign.center,
                      );
                    } else {
                      return Text('Loading data');
                    }
                  },
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.deepPurple[200],
                    border: Border.all(),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                padding: EdgeInsets.all(10),
                height: 50,
                width: 300,
                child: FutureBuilder<String?>(
                  future: getname(),
                  builder: (context, AsyncSnapshot<String?> snap) {
                    if (snap.hasData) {
                      return Text(
                        "order name :" + snap.data.toString(),
                        style: TextStyle(color: Colors.black, fontSize: 15),
                        textAlign: TextAlign.center,
                      );
                    } else {
                      return Text('Loading data');
                    }
                  },
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.deepPurple[200],
                    border: Border.all(),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                padding: EdgeInsets.all(10),
                height: 50,
                width: 300,
                child: FutureBuilder<String?>(
                  future: getPrice(),
                  builder: (context, AsyncSnapshot<String?> snap) {
                    if (snap.hasData) {
                      return Text(
                        "order price :" + snap.data.toString(),
                        style: TextStyle(color: Colors.black, fontSize: 15),
                        textAlign: TextAlign.center,
                      );
                    } else {
                      return Text('Loading data');
                    }
                  },
                ),
              ),
              SizedBox(
                height: 30,
              ),

              //     ElevatedButton(
              //      onPressed: () async {
              //  await FirebaseFirestore.instance
//.collection('commande')
              //       .doc()
              //    .delete();

              //    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => ClientScreen()));
              //  },
              //  style: ElevatedButton.styleFrom(
              //      primary: kPrimaryLightColor, elevation: 0),
              //  child: Text(
              //     "cancel ",
              //      style: TextStyle(color: Colors.black),
              //   )),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        color: Colors.transparent,
        child: BottomAppBar(
          color: Colors.transparent,
          child: RaisedButton(
              color: Colors.deepPurple[200],
              onPressed: () async {
                await FirebaseFirestore.instance
                    .collection('commande')
                    .doc(widget.country?["id"])
                    .delete();

                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => ClientScreen()));
              },
              child: Text(
                "cancel ",
                style: TextStyle(color: Colors.white),
              )),
        ),
      ),
    );
  }
}
