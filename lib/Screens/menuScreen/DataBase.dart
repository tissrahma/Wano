import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class Database {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  initiliase() {
    firestore = FirebaseFirestore.instance;
  }

  Future<void> createMeal(String name, String image, double price) async {
    try {
      await FirebaseFirestore.instance
          .collection("meals")
          .add({'name': name, 'image': image, 'price': price});
    } catch (e) {
      print(e);
    }
  }

  Future<void> delete(String id) async {
    try {
      await firestore.collection("meals").doc(id).delete();
    } catch (e) {
      print(e);
    }
  }

  Future<List> read() async {
    QuerySnapshot querySnapshot;
    List docs = [];
    try {
      querySnapshot = await firestore.collection('meals').get();
      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs.toList()) {
          Map a = {
            "id": doc.id,
            "name": doc['name'],
            "image": doc["image"],
            "price": doc["price"]
          };
          docs.add(a);
        }
        return docs;
      }
    } catch (e) {
      print(e);
    }
    return docs;
  }

  Future<void> update(
      String id, String name, String image, double price) async {
    try {
      await firestore
          .collection("meals")
          .doc(id)
          .update({'name': name, 'price ': price, 'image': image});
    } catch (e) {
      print(e);
    }
  }
}
