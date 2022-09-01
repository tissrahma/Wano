import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_application_1/Screens/Login/components/login_form.dart';
import 'package:flutter_application_1/Screens/Login/login_screen.dart';
import 'package:flutter_application_1/Screens/list_product.dart';
import 'package:flutter_application_1/Screens/menuScreen/ClientEssai.dart';
import 'package:flutter_application_1/Screens/menuScreen/Navigator.dart';

import 'package:flutter_application_1/Screens/menuScreen/ProductModel.dart';
import 'package:flutter_application_1/Screens/menuScreen/ShowCommande.dart';

import 'ClientScreen.dart';

class CommandeScreen extends StatefulWidget {
  const CommandeScreen({Key? key}) : super(key: key);

  @override
  State<CommandeScreen> createState() => _CommandeScreenState();
}

Future<String> getImage() async {
  User user = FirebaseAuth.instance.currentUser!;
  String _uid = user.uid;
  final DocumentSnapshot userDoc =
      await FirebaseFirestore.instance.collection('users').doc(_uid).get();
  String _name = await userDoc.get('image').toString();

  return await _name;
}

Future<String> getposition() async {
  User user = FirebaseAuth.instance.currentUser!;
  String _uid = user.uid;
  final DocumentSnapshot userDoc =
      await FirebaseFirestore.instance.collection('users').doc(_uid).get();
  String _name = await userDoc.get('position').toString();

  return await _name;
}

Future<String> getClientname() async {
  User user = FirebaseAuth.instance.currentUser!;
  String _uid = user.uid;
  final DocumentSnapshot userDoc =
      await FirebaseFirestore.instance.collection('users').doc(_uid).get();
  String _name = await userDoc.get('fullname').toString();

  return await _name;
}

Future<String> getphone() async {
  User user = FirebaseAuth.instance.currentUser!;
  String _uid = user.uid;
  final DocumentSnapshot userDoc =
      await FirebaseFirestore.instance.collection('phone').doc(_uid).get();
  String _name = await userDoc.get('image').toString();

  return await _name;
}

Future<String> getaddress() async {
  User user = FirebaseAuth.instance.currentUser!;
  String _uid = user.uid;
  final DocumentSnapshot userDoc =
      await FirebaseFirestore.instance.collection('users').doc(_uid).get();
  String _name = await userDoc.get('address').toString();

  return await _name;
}

Future<String> getMealsprice() async {
  User user = FirebaseAuth.instance.currentUser!;
  String _uid = user.uid;
  final DocumentSnapshot userDoc =
      await FirebaseFirestore.instance.collection('meals').doc(_uid).get();
  String _name = await userDoc.get('price').toString();

  return await _name;
}

Future<String> getMealsname() async {
  User user = FirebaseAuth.instance.currentUser!;
  String _uid = user.uid;
  final DocumentSnapshot userDoc =
      await FirebaseFirestore.instance.collection('meals').doc(_uid).get();
  String _name = await userDoc.get('name').toString();

  return await _name;
}
// image() {
//   for (int i = 0; i < 10; i++) {
//     return productList[i].image;
//   }
// }

// name() {
//   for (int i = 0; i < 10; i++) {
//     String name = productList[i].name.toString();
//     print("********************");
//     print(name);
//     return name;
//   }
// }

price() {
  for (int i = 0; i < 10; i++) {
    return productList[i].price;
  }
}

quantity() {
  for (int i = 0; i < 10; i++) {
    return productList[i].quantiy;
  }
}

getTotal() {
  for (int i = 0; i < productList.length; i++) {
    return double.parse(productList[i].price!) * productList[i].quantiy!;
  }
}

class _CommandeScreenState extends State<CommandeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  User firebaseUser = FirebaseAuth.instance.currentUser!;
  int quantity = 0;
  List docs = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[200],
        title: Text("Total"),
        actions: [
          IconButton(
              icon: Icon(Icons.keyboard_return),
              onPressed: () {
                productList.clear();
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => ClientEssai()));
              })
        ],
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
      body: Container(
          child: Column(
        children: [
          ListView.builder(
              shrinkWrap: true,
              itemCount: productList.length,
              itemBuilder: (context, index) {
                return Container(
                  height: 100,
                  width: 100,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 10,
                          height: 50,
                        ),
                        CircleAvatar(
                          radius: 40, // Image radius
                          backgroundImage:
                              NetworkImage(productList[index].image.toString()),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: Text(
                            productList[index].name.toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          " total = " + productList[index].quantiy.toString(),
                          style: TextStyle(
                            color: Colors.deepPurple[200],
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          productList[index].price.toString() + "€",
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                      ]),
                );
              }),
          SizedBox(
            height: 50,
          ),
        ],
      )),
    );
  }
}
