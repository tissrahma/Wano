import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screens/Login/components/login_form.dart';
import 'package:flutter_application_1/Screens/Login/login_screen.dart';
import 'package:flutter_application_1/Screens/list_product.dart';
import 'package:flutter_application_1/Screens/menuScreen/Cart.dart';
import 'package:flutter_application_1/Screens/menuScreen/Complaints.dart';
import 'package:flutter_application_1/Screens/menuScreen/ProductModel.dart';
import 'package:flutter_application_1/Screens/menuScreen/ShowCommande.dart';
import '../../constants.dart';
import 'DataBase.dart';

class ClientScreen extends StatefulWidget {
  const ClientScreen({
    Key? key,
  }) : super(key: key);

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

Map? country;
late Database db;
List<String> docId = [];

Future getDocIds() async {
  await FirebaseFirestore.instance.collection('meals').get().then(
        (snapshot) => snapshot.docs.forEach((Document) {
          print(Document.reference);
          docId.add(Document.reference.id);
        }),
      );
}

String id = "";

List docs = [];

Future<QuerySnapshot<Map<String, dynamic>>> meal =
    FirebaseFirestore.instance.collection('meals').get();

class _MenuScreenState extends State<ClientScreen> {
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
    print(image);
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
        title: Text("Client interface "),
        actions: [
          IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => LogIn()));
              })
        ],
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: SingleChildScrollView(
            child: Container(
          child: Column(children: [Navigator(), DrawerList(context)]),
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
                        child: ListTile(
                            onTap: () {
                              productList.add(ProductModel(
                                  image: getImage().toString(),
                                  price: getPrice().toString(),
                                  name: getname().toString()));
                            },
                            title: Text(docs[index]['name']),
                            trailing: Text(docs[index]['price'].toString()),
                            leading: CircleAvatar(
                              maxRadius: 50,
                              minRadius: 30, // Image radius
                              backgroundImage:
                                  NetworkImage(docs[index]['image']),
                            )));
                  },
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: defaultPadding),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: defaultPadding),
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => Cart()));
              },
              child: Text("helo"))
        ],
      )),
    );
  }
}

Widget DrawerList(context) {
  return Container(
    width: double.infinity,
    color: Colors.white,
    height: 500,
    padding: EdgeInsets.only(top: 15),
    child: Column(
      children: [menuItem(context)],
    ),
  );
}

menuItem(context) {
  return Column(
    children: [
      InkWell(
        onTap: () {
          if (FirebaseAuth.instance.currentUser?.uid != null) {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => Complaints()));
          } else
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => LoginScreen()));
        },
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Row(
            children: [
              SizedBox(
                width: 30,
              ),
              Icon(
                Icons.mail_lock_outlined,
                size: 25,
                color: Colors.black,
              ),
              SizedBox(
                width: 30,
              ),
              Text(
                "Send a complaint ",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
      ),
      SizedBox(
        height: 20,
      ),
      InkWell(
        onTap: () => Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (context) => Cart())),
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Row(
            children: [
              SizedBox(
                width: 30,
              ),
              Icon(
                Icons.shopping_cart,
                size: 25,
                color: Colors.black,
              ),
              SizedBox(
                width: 30,
              ),
              Text(
                "Go to cart  ",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
      ),
      SizedBox(
        height: 20,
      ),
      InkWell(
        onTap: () async {
          await FirebaseAuth.instance.signOut();
          await Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => LoginScreen()));
        },
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Row(
            children: [
              SizedBox(
                width: 30,
              ),
              Icon(
                Icons.logout_outlined,
                size: 25,
                color: Colors.black,
              ),
              SizedBox(
                width: 30,
              ),
              Text(
                "LogOut  ",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
      ),
    ],
  );
}
