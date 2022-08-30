import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screens/Login/login_screen.dart';
import 'package:flutter_application_1/Screens/list_product.dart';
import 'package:flutter_application_1/Screens/menuScreen/Cart.dart';
import 'package:flutter_application_1/Screens/menuScreen/ProductModel.dart';
import 'ClientScreen.dart';
import 'DataBase.dart';
import 'Navigator.dart';

class ClientEssai extends StatefulWidget {
  const ClientEssai({
    Key? key,
  }) : super(key: key);
  @override
  _ClientEssaiState createState() => _ClientEssaiState();
}

Map? country;
late Database db;
Future<String> getname() async {
  User user = FirebaseAuth.instance.currentUser!;
  String _uid = user.uid;
  final DocumentSnapshot userDoc =
      await FirebaseFirestore.instance.collection('meals').doc().get();
  String _name = await userDoc.get('name').toString();
  return await _name;
}

Future<String> getPrice() async {
  User user = FirebaseAuth.instance.currentUser!;
  String _uid = user.uid;
  final DocumentSnapshot userDoc =
      await FirebaseFirestore.instance.collection('meals').doc().get();
  String _name = await userDoc.get('price').toString();
  return await _name;
}

String id = "";
List docs = [];
Future<QuerySnapshot<Map<String, dynamic>>> meal =
    FirebaseFirestore.instance.collection('meals').get();
List<bool> isButtonActive = [
  true,
  true,
  true,
  true,
  true,
  true,
  true,
  true,
  true,
  true,
  true,
  true,
  true,
  true,
  true,
  true,
  true,
  true,
  true,
  true,
];

class _ClientEssaiState extends State<ClientEssai> {
  Future<FirebaseApp> _intializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    return firebaseApp;
  }

  findMeal(String name) {
    for (var i = 0; i < productList.length; i++) {
      if (productList[i].name == name) {
        return 1;
      }
    }
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

  List<String> docId = [];
  getDocIds(String name) async {
    final _uid = FirebaseAuth.instance.currentUser?.uid;
    FirebaseFirestore.instance
        .collection('meals')
        .where('name', isEqualTo: name)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        docId.add(element.id);
      });
    });
  }

  int quantity = 0;
  final _formKey = GlobalKey<FormState>();
  Future<DocumentSnapshot<Map<String, dynamic>>> variable =
      FirebaseFirestore.instance.collection('meals').doc().get();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[200],
        title: Text(" Wano's restaurant "),
        actions: [
          IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              })
        ],
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: SingleChildScrollView(
            child: Container(
          height: 700,
          width: 100.0,
          child: Column(children: [NavigatorHeader(), DrawerList(context)]),
        )),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  return Container(
                    height: 100,
                    width: 100,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 50,
                          ),
                          CircleAvatar(
                            radius: 40, // Image radius
                            backgroundImage: NetworkImage(docs[index]['image']),
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          Expanded(
                            child: Text(
                              docs[index]['name'].toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          Text(
                            docs[index]['price'] + "€",
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(
                            width: 30,
                            height: 50,
                          ),
                          IconButton(
                            icon: const Icon(Icons.add_circle),
                            onPressed: isButtonActive[index]
                                ? () async {
                                    if (FirebaseAuth
                                            .instance.currentUser?.uid !=
                                        null) {
                                      if (docId.isEmpty) {
                                        getDocIds(docs[index]['name']);
                                      } else {
                                        productList.add(ProductModel(
                                            image: docs[index]['image'],
                                            price: docs[index]['price'],
                                            name: docs[index]['name'],
                                            quantiy: 1));

                                        String? _uid = FirebaseAuth
                                            .instance.currentUser?.uid;
                                        await FirebaseFirestore.instance
                                            .collection(
                                                "cart" + _uid.toString())
                                            .doc(docId.last)
                                            .set({
                                          'userID': _uid,
                                          'image': docs[index]['image'],
                                          'name': docs[index]['name'],
                                          'price': docs[index]['price'],
                                          'quantity': 1,
                                        }).then((value) =>
                                                print("Record Inserted"));
                                        docId.clear();
                                        setState(() {
                                          isButtonActive[index] = false;
                                        });
                                        final snackBar = SnackBar(
                                          content: const Text(
                                              "you have added a new item to the cart"),
                                        );
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackBar);
                                      }
                                    } else
                                      Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  LoginScreen()));
                                  }
                                : null,
                          ),
                          SizedBox(
                            height: 30,
                          ),
                        ]),
                  );
                }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.deepPurple[200],
          onPressed: () {
            if (FirebaseAuth.instance.currentUser?.uid != null) {
              if (productList.length != 0) {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => Cart()));
              }
            } else {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => LoginScreen()));
            }
          },
          child: const Icon(Icons.shopping_cart)),
    );
  }
}
