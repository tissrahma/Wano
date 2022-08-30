import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screens/menuScreen/EmployeeScreen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_application_1/Screens/Login/login_screen.dart';
import 'Navigator.dart';
import 'ClientScreen.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AddMealForm extends StatefulWidget {
  const AddMealForm({Key? key}) : super(key: key);
  @override
  State<AddMealForm> createState() => _AddMealFormState();
}

final CollectionReference meals =
    FirebaseFirestore.instance.collection('meals');
TextEditingController _nameController = TextEditingController();
TextEditingController _priceController = TextEditingController();
String? singleImage;

String getImageName(PickedFile image) {
  return image.path.split("/").last;
}

Future<PickedFile?> singleImagePicker() async {
  return await ImagePicker.platform.pickImage(source: ImageSource.gallery);
}

late PickedFile? _image = PickedFile("");

Future<String?> getImageFile(image) async {
  return image?.path;
}

uploadImage(PickedFile image) async {
  User user = FirebaseAuth.instance.currentUser!;
  final _uid = user.uid;
  Reference db = FirebaseStorage.instance.ref().child('${getImageName(image)}');
  UploadTask uploadTask = db.putFile(File(image.path));
  uploadTask.snapshotEvents.listen((event) {
    print(
        event.bytesTransferred.toString() + "/t" + event.totalBytes.toString());
  });
  await uploadTask.whenComplete(() async {
    var uploadPath = await uploadTask.snapshot.ref.getDownloadURL();
    if (uploadPath.isNotEmpty) {
      await FirebaseFirestore.instance.collection("meals").add({
        'name': _nameController.text,
        'image': uploadPath,
        'price': _priceController.text
      }).then((value) => print("Record Inserted"));
      return uploadPath;
    }
  });
}

bool isButtonActive = true;

class _AddMealFormState extends State<AddMealForm> {
  @override
  void initState() {
    super.initState();
    setState(() {
      _nameController.clear();
      _priceController.clear();
      _image = PickedFile("");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
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
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                SizedBox(
                  height: 30,
                ),
                TextFormField(
                  style: TextStyle(color: Colors.white),
                  decoration: inputDecoration("Meal Name"),
                  controller: _nameController,
                ),
                SizedBox(
                  height: 30,
                ),
                TextFormField(
                  style: TextStyle(color: Colors.white),
                  decoration: inputDecoration("Meal price"),
                  controller: _priceController,
                ),
                SizedBox(
                  height: 30,
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      _image = await singleImagePicker();
                      setState(() {});
                    },
                    child: Text("select image "),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),

                // CachedNetworkImage(
                //   imageUrl:
                //       "https://firebasestorage.googleapis.com/v0/b/project1-cf751.appspot.com/o/image_picker2246698138651153800.jpg?alt=media&token=443bbf1e-3f34-4b35-8114-d2e7d9dc4456",
                //   progressIndicatorBuilder: (context, url, downloadProgress) =>
                //       CircularProgressIndicator(
                //           value: downloadProgress.progress),
                //   errorWidget: (context, url, error) => Icon(Icons.error),
                // ),
                FutureBuilder<String?>(
                  future: getImageFile(_image),
                  builder: (context, snap) {
                    if (snap.hasData && snap.data != '') {
                      return Container(
                        child: Image.file(
                          File(snap.data!),
                        ),
                        color: Colors.blue,
                      );
                    }
                    return CircularProgressIndicator();
                  },
                ),
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
                onPressed: isButtonActive
                    ? () async {
                        if (_priceController.text != "" &&
                            _nameController.text != "" &&
                            _image!.path.isNotEmpty) {
                          //   await uploadImage(_image!);
                          User user = FirebaseAuth.instance.currentUser!;
                          final _uid = user.uid;
                          Reference db = FirebaseStorage.instance
                              .ref()
                              .child('${getImageName(_image!)}');
                          UploadTask uploadTask =
                              db.putFile(File(_image!.path));
                          uploadTask.snapshotEvents.listen((event) {
                            print(event.bytesTransferred.toString() +
                                "/t" +
                                event.totalBytes.toString());
                          });

                          await uploadTask.whenComplete(() async {
                            var uploadPath =
                                await uploadTask.snapshot.ref.getDownloadURL();
                            if (uploadPath.isNotEmpty) {
                              await FirebaseFirestore.instance
                                  .collection("meals")
                                  .doc()
                                  .set({
                                'name': _nameController.text,
                                'image': uploadPath,
                                'price': _priceController.text
                              }).then((value) => print("Record Inserted"));
                              return uploadPath;
                            }
                          });

                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => EmployeeScreen()));
                        } else {
                          final snackBar = SnackBar(
                            content: const Text("plz enter all data  "),
                            backgroundColor: Colors.red,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      }
                    : null,
                child: Text(
                  "Save",
                  style: TextStyle(color: Colors.white),
                )),
          ),
        ));
  }
}

InputDecoration inputDecoration(String labelText) {
  return InputDecoration(
    focusColor: Colors.black,
    labelStyle: TextStyle(color: Colors.white),
    labelText: labelText,
    fillColor: Colors.deepPurple[200],
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(25.0),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(25.0),
      borderSide: BorderSide(
        color: Colors.black,
        width: 2.0,
      ),
    ),
  );
}
