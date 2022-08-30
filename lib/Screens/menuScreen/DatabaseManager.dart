import 'package:cloud_firestore/cloud_firestore.dart';


class DatabaseManager {
  final FirebaseFirestore firebasefirestore = FirebaseFirestore.instance;
 
  

  final CollectionReference profileList =
      FirebaseFirestore.instance.collection('meals');

  Future<void> createMealData(
      String name, String photo, double price, String uid) async {
    return await profileList
        .doc(uid)
        .set({'name': name, 'photo': photo, 'price': price});
  }

  Future updateMealList(
      String name, String photo, double price, String uid) async {
    return await profileList
        .doc(uid)
        .update({'name': name, 'gender': photo, 'score': price});
  }

  Future getMealsList() async {
    List itemsList = [];

    try {
      await profileList.get().then((querySnapshot) {
        querySnapshot.docs.forEach((element) {
          itemsList.add(element.data);
        });
      });
      return itemsList;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
