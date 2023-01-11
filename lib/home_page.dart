
// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? image;


  Future pickImage() async{
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTempHolder = File(image.path);
      setState(() {
        this.image = imageTempHolder;
      });
    } on PlatformException catch (e) {
      print("Failed");
      // TODO
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Displaying Images Activity"),
      ),
      body: Center(
        child: SizedBox(
          child: image != null ? Image.file(image!) : FlutterLogo(size : 160),
        ),

      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            PermissionStatus readMediaStatus = await Permission.storage.request();

            if(readMediaStatus == PermissionStatus.granted){
              pickImage();
            }
            if(readMediaStatus == PermissionStatus.denied){
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text("Permission Denied")
                  )
              );
            }
            if(readMediaStatus == PermissionStatus.permanentlyDenied){
              openAppSettings();
            }
          },
          icon: const Icon(Icons.photo_size_select_actual_outlined),
          label: const Text("Select Image"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
