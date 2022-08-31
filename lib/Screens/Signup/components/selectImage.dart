import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../menuScreen/addMealForm.dart';

class SelectImage extends StatefulWidget {
  @override
  State<SelectImage> createState() => _SelectImageState();
}

late PickedFile? img = PickedFile("");

class _SelectImageState extends State<SelectImage> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        img = await singleImagePicker();
        setState(() {});
      },
      child: Text("select image "),
    );
  }
}
