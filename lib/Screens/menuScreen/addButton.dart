import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../list_product.dart';
import 'ClientEssai.dart';
import 'ProductModel.dart';
class addButton extends StatefulWidget {
  const addButton({Key? key}) : super(key: key);
  @override
  State<addButton> createState() => _addButtonState();
}

@override
void initState() {
  initState();
}

getMealsprice() async {
  for (int i = 0; i < productList.length; i++) {
    return productList[i].price;
  }
}

getMealsname() async {
  for (int i = 0; i < productList.length; i++) {
    String name = productList[i].name.toString();

    return name;
  }
}

getMealsimage() {
  for (int i = 0; i < productList.length; i++) {
    return productList[i].image;
  }
}

@override
State<StatefulWidget> createState() => _addButtonState();

User user = FirebaseAuth.instance.currentUser!;
final _uid = user.uid;
List<String> docId = [];
getDocIds() async {
  User user = FirebaseAuth.instance.currentUser!;
  final _uid = user.uid;
  FirebaseFirestore.instance
      .collection('meals')
      .where('name', isEqualTo: "sushi")
      .get()
      .then((value) {
    value.docs.forEach((element) {
      docId.add(element.id);
    });
  });
}

addToCart() async {
  User user = FirebaseAuth.instance.currentUser!;
  final _uid = user.uid;
  await FirebaseFirestore.instance.collection("cart").doc().set({
    'userID': _uid,
    'image': getMealsimage().toString(),
    'name': getMealsname().toString(),
    'price': getMealsprice().toString(),
    'quantity': 1,
  }).then((value) => print("Record Inserted"));
}

class _addButtonState extends State<addButton> {
  bool isButtonActive = true;
  @override
  Widget build(BuildContext context) {
    // return FutureBuilder(
    //     future: getDocIds(),
    //     builder: (context, snap) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: 1,
        itemBuilder: (context, index) {
          return IconButton(
            icon: const Icon(Icons.add_circle),
            onPressed: isButtonActive
                ? () async {
                     productList.add(ProductModel(
                                     image: docs[index]['image'],
                                   price: docs[index]['price'],
                                  name: docs[index]['name'],
                                        quantiy: 1));
                    print("^^^^^^^^^^^^^");
                    print(productList[0]);

                    User user = FirebaseAuth.instance.currentUser!;
                    final _uid = user.uid;
                    getDocIds();
                    print("+++++++++++++++++");
                    print(docId);
                    await FirebaseFirestore.instance
                        .collection("cart")
                        .doc(docId.first)
                        .set({
                      'userID': _uid,
                      'image': docs[index]['image'],
                      'name': docs[index]['name'],
                      'price': docs[index]['price'],
                      'quantity': 1,
                    }).then((value) => print("Record Inserted"));
                    setState(() {
                      isButtonActive = false;
                    });
                    final snackBar = SnackBar(
                      content:
                          const Text("you have added a new item to the cart"),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                : null,
          );
        });
    // });
  }
}
