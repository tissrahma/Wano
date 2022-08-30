import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class SelectImageClass extends StatefulWidget {
  const SelectImageClass({Key? key}) : super(key: key);

  @override
  State<SelectImageClass> createState() => _SelectImageState();
}

late File attached = new File("");

class _SelectImageState extends State<SelectImageClass> {
  String? singleImage;
  Future pickImage() async {
    try {
      var image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemp = File(image.path);
      setState(() => image = imageTemp as XFile?);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  String getImageName(PickedFile? image) {
    return image!.path.split("/").last;
  }

  uploadImage(PickedFile image) async {
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
      var uploadPath = await uploadTask.snapshot.ref.getDownloadURL();
      if (uploadPath.isNotEmpty) {
        await FirebaseFirestore.instance.collection("meals").doc(_uid).set({
          'image': uploadPath,
        }).then((value) => print("Record Inserted"));
        print("***********");
        print(uploadPath);
      } else {
        print("error");
      }
    });
    //TaskSnapshot snapshot = await uploadTask;
    // String imageUrl = await (await snapshot).ref.getDownloadURL().toString();

    // final task = await db.putFile(File(image.path));
    // TaskSnapshot uploadTask = await task;
    // final urlString =   await (await uploadTask).ref.getDownloadURL().toString();
    //  return urlString;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        height: 100,
        width: 300,
        padding: EdgeInsets.all(20),
        child: Column(children: [
          ElevatedButton(
            onPressed: () async {
              PickedFile? _image = await singleImagePicker();
              if (_image != null && _image.path.isNotEmpty) {
                //   singleImage = uploadImage(_image);
              

                //                setState(() {});
              }
            },
            child: Text("select image "),
          ),
          SizedBox(
            height: 30,
          ),
          FutureBuilder<PickedFile?>(
            future: singleImagePicker(),
            builder: (context, snap) {
              Size(50, 50);
              if (snap.hasData) {
                return Container(
                  child: Image.file(
                    File(snap.data!.path),
                    fit: BoxFit.contain,
                  ),
                  color: Colors.blue,
                );
              }
              return Container(
                height: 200.0,
              );
            },
          ),
        ]),
      ),
    );
  }
}

Future<PickedFile?> singleImagePicker() async {
  return await ImagePicker.platform.pickImage(source: ImageSource.gallery);
}
