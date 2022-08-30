import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class NavigatorHeader extends StatefulWidget {
  @override
  _NavigatorHeaderState createState() => _NavigatorHeaderState();
}

class _NavigatorHeaderState extends State<NavigatorHeader> {
  Future<String> getname() async {
    String? _uid = FirebaseAuth.instance.currentUser?.uid;
    final DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(_uid).get();
    String _name = await userDoc.get('fullname').toString();
    return await _name;
  }

  Future<String> getImage() async {
    String? _uid = FirebaseAuth.instance.currentUser?.uid;
    if (FirebaseAuth.instance.currentUser?.uid != null) {
      final DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(_uid).get();
      String _name = await userDoc.get('image').toString();
      return await _name;
    } else
      return "https://firebasestorage.googleapis.com/v0/b/project1-cf751.appspot.com/o/profilee.jpeg?alt=media&token=a33122c4-dd6f-4fc0-bdea-fda167638ba6";
  }

  Future<String?> getemail() async {
    String? _email = FirebaseAuth.instance.currentUser?.email.toString();
    return await _email;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.deepPurple[200],
      width: double.infinity,
      height: 200,
      padding: EdgeInsets.only(top: 10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FutureBuilder<String>(
              future: getImage(),
              builder: (context, AsyncSnapshot<String?> snap) {
                if (snap.data != null &&
                    FirebaseAuth.instance.currentUser?.uid != null) {
                  return Container(
                    width: 100,
                    height: 100,
                    child: CircleAvatar(
                      radius: 40, // Image radius
                      backgroundImage: NetworkImage(snap.data.toString()),
                    ),
                  );
                }
                return Container(
                  color: Colors.grey[700],
                  width: 100,
                  height: 100,
                  child: Icon(Icons.person),
                );
              }),
        ],
      ),
    );
  }
}
