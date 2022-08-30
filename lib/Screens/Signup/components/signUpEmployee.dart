import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screens/Login/components/loginEmployeeScreen.dart';
import 'package:flutter_application_1/Screens/menuScreen/Cart.dart';
import 'package:flutter_application_1/Screens/menuScreen/ClientEssai.dart';
import 'package:flutter_application_1/Screens/menuScreen/EmployeeScreen.dart';
import 'package:flutter_application_1/Screens/menuScreen/addMealForm.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';
import 'package:flutter_application_1/components /already_have_an_account_acheck.dart';
import 'package:image_picker/image_picker.dart';
import '../../../constants.dart';
import '../../Login/login_screen.dart';
import '../../menuScreen/ClientScreen.dart';

class SignUpEmployee extends StatelessWidget {
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

    String? singleImage;
    late PickedFile? _image = PickedFile("");
    Future<PickedFile?> singleImagePicker() async {
      return await ImagePicker.platform.pickImage(source: ImageSource.gallery);
    }

    String? confirmValidator(String? confirm) {
      if (confirm == null || confirm.trim().isEmpty) {
        return "this field is empty ";
      }
      if (_passwordController.text != _confirmController.text) {
        return "passwords don't match";
      }
    }

    Future<String?> getImageFile(image) async {
      return image?.path;
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
            'position': "employee",
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
            TextFormField(
              controller: _emailController,
              validator: emailValidator,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              cursorColor: kPrimaryColor,
              onSaved: (email) {},
              decoration: InputDecoration(
                hintText: "Your email",
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.mail),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: defaultPadding),
              child: TextFormField(
                controller: _nameController,
                validator: requiredValidator,
                textInputAction: TextInputAction.done,
                cursorColor: kPrimaryColor,
                decoration: InputDecoration(
                  hintText: "Your Full Name",
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(defaultPadding),
                    child: Icon(Icons.person),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: defaultPadding),
              child: TextFormField(
                controller: _addressController,
                validator: requiredValidator,
                textInputAction: TextInputAction.done,
                cursorColor: kPrimaryColor,
                decoration: InputDecoration(
                  hintText: "Your current address",
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(defaultPadding),
                    child: Icon(Icons.location_city),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: defaultPadding),
              child: TextFormField(
                controller: _phoneController,
                validator: requiredValidator,
                textInputAction: TextInputAction.done,
                cursorColor: kPrimaryColor,
                decoration: InputDecoration(
                  hintText: "Your Phone Number",
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(defaultPadding),
                    child: Icon(Icons.phone),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: defaultPadding),
              child: TextFormField(
                  controller: _passwordController,
                  validator: passwordValidator,
                  textInputAction: TextInputAction.done,
                  obscureText: _obscureText,
                  cursorColor: kPrimaryColor,
                  decoration: InputDecoration(
                    hintText: "Your password",
                    prefixIcon: Padding(
                        padding: const EdgeInsets.all(defaultPadding),
                        child: Icon(Icons.lock)),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: defaultPadding),
              child: TextFormField(
                  controller: _confirmController,
                  validator: confirmValidator,
                  textInputAction: TextInputAction.done,
                  obscureText: _obscureText,
                  cursorColor: kPrimaryColor,
                  decoration: InputDecoration(
                    hintText: "Confirm password",
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(defaultPadding),
                      child: Icon(Icons.lock),
                    ),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: defaultPadding),
              child: ElevatedButton(
                onPressed: () async {
                  _image = await singleImagePicker();
                },
                child: Text("select image "),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            FutureBuilder<String?>(
              future: getImageFile(_image),
              builder: (context, snap) {
                Size(50, 50);
                if (snap.hasData && snap.data != "") {
                  return Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: Image.file(
                      File(_image!.path),
                      fit: BoxFit.contain,
                    ),
                  );
                }
                return Text("loading ..");
              },
            ),
            SizedBox(
              height: 30,
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  singleImage = await uploadImage(_image!);
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => EmployeeScreen()));
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
                      return loginEmployeeScreen();
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
