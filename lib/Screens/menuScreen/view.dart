import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screens/menuScreen/DataBase.dart';
import 'package:flutter_application_1/Screens/menuScreen/EmployeeScreen.dart';
import 'package:image_picker/image_picker.dart';

import 'addMealForm.dart';

class View extends StatefulWidget {
  View({Key? key, required this.country, required this.db}) : super(key: key);
  late Map country;
  late Database db;
  @override
  _ViewState createState() => _ViewState();
}

class _ViewState extends State<View> {
  TextEditingController nameController = new TextEditingController();
  TextEditingController priceController = new TextEditingController();
  TextEditingController imageController = new TextEditingController();
  @override
  void initState() {
    super.initState();
    print(widget.country);
    nameController.text = widget.country['name'];
    priceController.text = widget.country['price'].toString();
    String image = widget.country['image'].toString();
  }

  String getImageName(PickedFile image) {
    return image.path.split("/").last;
  }

  String? singleImage;
  Future<PickedFile?> singleImagePicker() async {
    return await ImagePicker.platform.pickImage(source: ImageSource.gallery);
  }

  late PickedFile? _image = PickedFile("");
  Future<String?> getImageFile(image) async {
    return image?.path;
  }

  Future<String?> uploadImage(PickedFile image) async {
    User user = FirebaseAuth.instance.currentUser!;
    final _uid = user.uid;
    Reference db =
        FirebaseStorage.instance.ref().child('${getImageName(image)}');
    UploadTask uploadTask = db.putFile(File(image.path));
    uploadTask.snapshotEvents.listen((event) {
      print(event.bytesTransferred.toString() +
          "/t" +
          event.totalBytes.toString());
    });
    await uploadTask.whenComplete(() async {
      String uploadPath = await uploadTask.snapshot.ref.getDownloadURL();
      return uploadPath;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[200],
        title: Text("Meals "),
        actions: [
          IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                widget.db.delete(widget.country["id"]);
                Navigator.pop(context, true);
              })
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              TextFormField(
                style: TextStyle(color: Colors.black),
                decoration: inputDecoration("Name"),
                controller: nameController,
              ),
              SizedBox(
                height: 30,
              ),
              TextFormField(
                style: TextStyle(color: Colors.black),
                decoration: inputDecoration("price"),
                controller: priceController,
              ),
              SizedBox(
                height: 30,
              ),
              ElevatedButton(
                onPressed: () async {
                  _image = await singleImagePicker();
                  setState(() {});
                },
                child: Text("select image "),
              ),
              SizedBox(
                height: 30,
              ),
              FutureBuilder<String?>(
                future: getImageFile(_image),
                builder: (context, snap) {
                  if (snap.hasData && snap.data != '') {
                    return Container(
                      color: Colors.blue,
                      child: Image.file(
                        File(snap.data!),
                        fit: BoxFit.contain,
                      ),
                    );
                  } else
                    return const CircularProgressIndicator();
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
                onPressed: () async {
                  User user = FirebaseAuth.instance.currentUser!;
                  final _uid = user.uid;

                  Reference db = await FirebaseStorage.instance
                      .ref()
                      .child('${getImageName(_image!)}');
                  UploadTask uploadTask = db.putFile(File(_image!.path));
                  uploadTask.snapshotEvents.listen((event) {
                    print(event.bytesTransferred.toString() +
                        "/t" +
                        event.totalBytes.toString());
                  });
                  uploadTask.whenComplete(() async {
                    var uploadPath =
                        await uploadTask.snapshot.ref.getDownloadURL();

                    widget.db.update(widget.country['id'], nameController.text,
                        uploadPath, double.parse(priceController.text));

                    Navigator.pop(context, true);
                  });
                },
                child: Text(
                  "Save",
                  style: TextStyle(color: Colors.white),
                )),
          )),
    );
  }
}
