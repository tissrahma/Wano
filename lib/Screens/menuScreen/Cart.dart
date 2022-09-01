import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screens/list_product.dart';
import 'package:flutter_application_1/Screens/menuScreen/ClientEssai.dart';
import 'package:flutter_application_1/Screens/menuScreen/CommandeScreen.dart';
import 'package:flutter_application_1/Screens/menuScreen/Navigator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../main.dart';
import 'ClientScreen.dart';

class Cart extends StatefulWidget {
  const Cart({Key? key}) : super(key: key);

  @override
  State<Cart> createState() => _CartState();
}

User? firebaseUser = FirebaseAuth.instance.currentUser;

Future<String> getposition() async {
  User user = FirebaseAuth.instance.currentUser!;
  String _uid = user.uid;
  final DocumentSnapshot userDoc =
      await FirebaseFirestore.instance.collection('users').doc(_uid).get();
  String _name = await userDoc.get('position').toString();

  return await _name;
}

getDocIds(String name) async {
  User user = FirebaseAuth.instance.currentUser!;
  final _uid = user.uid;
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

// getTotal() {
//   for (var element in productList) {
//     print("+++++++++++++++");
//     print(element.name);
//     String sum =
//         (double.parse(productList[productList.indexOf(element)].price!) *
//                 productList[productList.indexOf(element)].quantiy!)
//             .toString();
//     return sum.toString();
//   }
// }

User user = FirebaseAuth.instance.currentUser!;
String _uid = user.uid;
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

@override
Future<String> getaddress() async {
  User user = FirebaseAuth.instance.currentUser!;
  String _uid = user.uid;
  final DocumentSnapshot userDoc =
      await FirebaseFirestore.instance.collection('users').doc(_uid).get();
  String _name = await userDoc.get('address').toString();
  return await _name;
}

getMealsprice() async {
  for (int i = 0; i < productList.length; i++) {
    return productList[i].price;
  }
}

getMealsname() async {
  for (int i = 0; i < productList.length; i++) {
    return productList[i].name.toString();
  }
}

getMealsimage() {
  for (int i = 0; i < productList.length; i++) {
    return productList[i].image;
  }
}

getQuantity() {
  for (int i = 0; i < productList.length; i++) {
    return productList[i].quantiy;
  }
}

class _CartState extends State<Cart> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  final items = List<String>.generate(20, (i) => 'Item ${i + 1}');

  // addCommande() async {
  //   User user = FirebaseAuth.instance.currentUser!;
  //   final _uid = user.uid;

  //   for (int i = 0; i < productList.length; i++) {
  //     await FirebaseFirestore.instance.collection("commande" + _uid).doc().set({
  //       'userID': _uid,
  //       'image': getMealsimage().toString(),
  //       'name': getMealsname(),
  //       'price': getMealsprice(),
  //       'quantity': getQuantity()
  //     }).then((value) => print("Record Inserted"));
  //   }
  // }

  User? firebaseUser = FirebaseAuth.instance.currentUser;
  int quantity = 1;
  List docs = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[200],
        title: Text("YOUR CART"),
        actions: [
          IconButton(
              icon: Icon(Icons.keyboard_return),
              onPressed: () async {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => ClientEssai()));
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
      body: Column(children: [
        Container(
            height: 500,
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: productList.length,
                itemBuilder: (context, index) {
                  String item = items[index];
                  return Dismissible(
                    key: UniqueKey(),
                    onDismissed: (direction) {
                      setState(() {
                        if (Total > 0) {
                          Total = Total -
                              ((double.parse(productList[index].price!) *
                                  productList[index].quantiy!));
                        } else {
                          final snackBar = SnackBar(
                            content: const Text("you have removed everthing"),
                          );
                        }

                        getDocIds(productList[index].name.toString());
                        productList.removeAt(index);
                        items.removeAt(index);
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('$item dismissed')));
                    },
                    child: Container(
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
                              backgroundImage: NetworkImage(
                                  productList[index].image.toString()),
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
                            Text(
                              productList[index].price.toString() + "€",
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            IconButton(
                                onPressed: () async {
                                  User user =
                                      FirebaseAuth.instance.currentUser!;
                                  String _uid = user.uid;
                                  if (docId.isEmpty) {
                                    getDocIds(
                                        productList[index].name.toString());
                                  } else {
                                    await FirebaseFirestore.instance
                                        .collection('cart' + _uid)
                                        .doc(docId.last)
                                        .update({
                                      'quantity':
                                          productList[index].quantiy! + 1
                                    });

                                    docId.clear();
                                  }

                                  setState(() {
                                    Total = Total +
                                        (double.parse(
                                            productList[index].price!));

                                    productList[index].quantiy =
                                        productList[index].quantiy! + 1;
                                  });
                                },
                                icon: const Icon(Icons.add_circle)),
                            Text(
                              productList[index].quantiy.toString(),
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            IconButton(
                                onPressed: () async {
                                  User user =
                                      FirebaseAuth.instance.currentUser!;
                                  String _uid = user.uid;
                                  if (docId.isEmpty) {
                                    getDocIds(
                                        productList[index].name.toString());
                                  } else {
                                    await FirebaseFirestore.instance
                                        .collection('cart' + _uid)
                                        .doc(docId.last)
                                        .update({
                                      'quantity':
                                          productList[index].quantiy! - 1
                                    });
                                    docId.clear();
                                  }
                                  setState(() {
                                    if (productList[index].quantiy! > 1) {
                                      if (Total > 0) {
                                        Total = Total -
                                            (double.parse(
                                                productList[index].price!));
                                      } else {
                                        final snackBar = SnackBar(
                                          content: const Text(
                                              "you have removed everthing"),
                                        );
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackBar);
                                      }
                                      productList[index].quantiy =
                                          productList[index].quantiy! - 1;
                                    } else {
                                      final snackBar = SnackBar(
                                        content:
                                            const Text("quantitity cant be 0"),
                                      );
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                    }
                                  });
                                },
                                icon: const Icon(Icons.remove_circle)),
                            SizedBox(
                              height: 30,
                            ),
                          ]),
                    ),
                  );
                })),
        Align(
            alignment: Alignment.bottomCenter,
            child: Text(
              "your total is " + Total.toString(),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            )),
      ]),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple[200],
        onPressed: () {
          
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => CommandeScreen()));

          Fluttertoast.showToast(
              msg: "your order have been confirmed ",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.deepPurple[200],
              textColor: Colors.white,
              fontSize: 16.0);
        },
        child: const Icon(Icons.check),
      ),
    );
  }
}
