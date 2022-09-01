import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screens/menuScreen/Cart.dart';
import 'package:flutter_application_1/Screens/menuScreen/ClientEssai.dart';
import 'package:flutter_application_1/Screens/menuScreen/addMealForm.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';
import 'package:flutter_application_1/components /already_have_an_account_acheck.dart';
import 'package:image_picker/image_picker.dart';
import '../../../constants.dart';
import '../../Login/login_screen.dart';
import '../../menuScreen/ClientScreen.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({Key? key}) : super(key: key);
  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  @override
  Widget build(BuildContext context) {
    TextEditingController _emailController = TextEditingController();
    TextEditingController _nameController = TextEditingController();
    TextEditingController _addressController = TextEditingController();
    TextEditingController _phoneController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();
    TextEditingController _confirmController = TextEditingController();
    TextEditingController _positionController = TextEditingController();
    String dropdownValue = 'Employee';
    bool _obscureText = true;
    String? requiredValidator(String? text) {
      if (text == null || text.trim().isEmpty) {
        return ' this field is required ';
      }
      return null;
    }

    String? passwordValidator(String? text) {
      if (text == null || text.trim().isEmpty) {
        if (text!.length < 6) {
          return 'passwor weak';
        }
        return ' this field is required ';
      }
      return null;
    }

    String? emailValidator(String? text) {
      if (text == null || text.trim().isEmpty) {
        if (EmailValidator.validate(text!) == false) {
          return "invalid email";
        }
        return ' this field is required ';
      }
      return null;
    }

    Future<PickedFile?> singleImagePicker() async {
      return await ImagePicker.platform.pickImage(source: ImageSource.gallery);
    }

    late PickedFile? _image = PickedFile("");

    Future<String?> getImageFile(image) async {
      return image?.path;
    }

    String? confirmValidator(String? confirm) {
      if (confirm == null || confirm.trim().isEmpty) {
        return "this field is empty ";
      }
      if (_passwordController.text != _confirmController.text) {
        return "passwords don't match";
      }
    }

    final _formKey = GlobalKey<FormState>();

    String getImageName(PickedFile image) {
      return image.path.split("/").last;
    }

    sucess() {
      return 'done !';
    }

    uploadImage(PickedFile image) async {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim());

      Reference db =
          FirebaseStorage.instance.ref().child('${getImageName(image)}');
      UploadTask uploadTask = db.putFile(File(image.path));

      uploadTask.snapshotEvents.listen((event) {
        print(event.bytesTransferred.toString() +
            "/t" +
            event.totalBytes.toString());
      });

      String? _uid = FirebaseAuth.instance.currentUser?.uid;

      await uploadTask.whenComplete(() async {
        var uploadPath = await uploadTask.snapshot.ref.getDownloadURL();
        if (uploadPath.isNotEmpty) {
          await FirebaseFirestore.instance.collection("users").doc(_uid).set({
            'fullname': _nameController.text,
            'position': "client",
            'image': uploadPath,
            'phone': _phoneController.text,
            'address': _addressController.text,
          }).then((value) => print("Record Inserted"));
        } else {
          final snackBar = SnackBar(
            content: Text("plz select an image "),
            backgroundColor: Colors.red,
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      });
    }

    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            FutureBuilder<String?>(
              future: getImageFile(_image),
              builder: (context, snap) {
                print(snap.data);
                print("§§§§§§§§§§§§§§§§§§");
                if (snap.hasData && snap.data != '') {
                  return Container(
                    color: Colors.blue,
                    child: CircleAvatar(
                        child: Image.file(
                      File(snap.data!),
                      fit: BoxFit.contain,
                    )),
                  );
                } else
                  return CircleAvatar(
                      radius: 40.0,
                      backgroundImage: NetworkImage(
                          "https://firebasestorage.googleapis.com/v0/b/project1-cf751.appspot.com/o/profilee.jpeg?alt=media&token=a33122c4-dd6f-4fc0-bdea-fda167638ba6"));
              },
            ),
            SizedBox(
              height: 30,
            ),
            TextFormField(
              controller: _emailController,
              validator: emailValidator,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              cursorColor: kPrimaryColor,
              onSaved: (email) {},
              decoration: const InputDecoration(
                hintText: "Your email",
                prefixIcon: Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.mail),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            TextFormField(
              controller: _nameController,
              validator: requiredValidator,
              textInputAction: TextInputAction.done,
              cursorColor: kPrimaryColor,
              decoration: const InputDecoration(
                hintText: "Your Full Name",
                prefixIcon: Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.person),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            TextFormField(
              controller: _addressController,
              validator: requiredValidator,
              textInputAction: TextInputAction.done,
              cursorColor: kPrimaryColor,
              decoration: const InputDecoration(
                hintText: "Your current address",
                prefixIcon: Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.location_city),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            TextFormField(
              controller: _phoneController,
              validator: requiredValidator,
              textInputAction: TextInputAction.done,
              cursorColor: kPrimaryColor,
              decoration: const InputDecoration(
                hintText: "Your Phone Number",
                prefixIcon: Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.phone),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            TextFormField(
                controller: _passwordController,
                validator: passwordValidator,
                textInputAction: TextInputAction.done,
                obscureText: _obscureText,
                cursorColor: kPrimaryColor,
                decoration: const InputDecoration(
                  hintText: "Your password",
                  prefixIcon: Padding(
                      padding: EdgeInsets.all(defaultPadding),
                      child: Icon(Icons.lock)),
                )),
            SizedBox(
              height: 30,
            ),
            TextFormField(
                controller: _confirmController,
                validator: confirmValidator,
                textInputAction: TextInputAction.done,
                obscureText: _obscureText,
                cursorColor: kPrimaryColor,
                decoration: const InputDecoration(
                  hintText: "Confirm password",
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(defaultPadding),
                    child: Icon(Icons.lock),
                  ),
                )),
            SizedBox(
              height: 30,
            ),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  _image = await singleImagePicker();
                },
                child: Text("select image "),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await uploadImage(_image!);
                  await Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => ClientEssai()));
                } on FirebaseAuthException catch (e) {
                  final snackBar = SnackBar(
                    content: Text(e.code.toString()),
                    backgroundColor: Colors.red,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              },
              child: Text("Sign Up".toUpperCase()),
            ),
            const SizedBox(height: defaultPadding),
            AlreadyHaveAnAccountCheck(
              login: false,
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return LoginScreen();
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
