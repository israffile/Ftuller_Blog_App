import 'dart:developer';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:isr_afil_blog_app/models/imgService.dart';
import 'package:isr_afil_blog_app/models/userdata.dart';
import 'package:mime/mime.dart';

class UploadScreen extends StatefulWidget {
  final VoidCallback? onGoBack2;
  const UploadScreen({super.key, required this.onGoBack2});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  bool isPosting = false;

  var formkey = GlobalKey<FormState>();

  Uint8List? img;

  final TextEditingController tittleController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController detailsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  maxLength: 30,
                  controller: tittleController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Tittle can't be empty";
                    } else {
                      return null;
                    }
                  },
                  decoration: const InputDecoration(
                    hintText: "Title*",
                  ),
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                TextFormField(
                  maxLength: 20,
                  controller: locationController,
                  decoration: const InputDecoration(
                    hintText: "location",
                    border: InputBorder.none,
                  ),
                  style: const TextStyle(fontSize: 14, color: Colors.white),
                ),
                TextFormField(
                  maxLength: 1501,
                  controller: detailsController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Tittle can't be empty";
                    } else {
                      return null;
                    }
                  },
                  decoration: const InputDecoration(
                    hintText: "Details*",
                    border: InputBorder.none,
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 16),
                const SizedBox(
                  width: 30,
                  height: 30,
                ),
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                        image: img == null
                            ? null
                            : DecorationImage(image: MemoryImage(img!)),
                        border: Border.all()),
                    height: 160,
                    width: 280,
                    alignment: Alignment.center,
                    child: IconButton(
                      onPressed: () async {
                        var showValue = await showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                                backgroundColor:
                                    const Color.fromARGB(255, 69, 69, 69),
                                title: const Text(
                                  "Upload image",
                                  style: TextStyle(color: Colors.white),
                                ),
                                content: Row(
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(false);
                                      },
                                      child: IconButton(
                                          onPressed: () {
                                            Navigator.of(context).pop(
                                                ImageSource.camera); //camera
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                                    content: Text(
                                                        "Capctured photo ready to post")));
                                          },
                                          icon: const Icon(
                                            Icons.camera_alt_rounded,
                                            color: Color.fromARGB(
                                                255, 28, 115, 185),
                                          )),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pop(ImageSource.gallery); //gallery
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                                content: Text(
                                                    "Gallery photo ready to post")));
                                      },
                                      icon: const Icon(
                                        Icons.photo_library_rounded,
                                        color:
                                            Color.fromARGB(255, 52, 121, 178),
                                      ),
                                    ),
                                  ],
                                ));
                          },
                        );
                        if (showValue == null) {
                          return;
                        }
                        var file =
                            await ImagePicker().pickImage(source: showValue);
                        if (file != null) {
                          var newimage = await file.readAsBytes();
                          var mimeType = lookupMimeType("",
                              headerBytes: newimage.toList());
                          log(mimeType.toString());
                          if (mimeType?.startsWith("image") ?? false) {
                            setState(() {
                              img = newimage;
                            });
                          }
                        }
                      },
                      icon: const Icon(Icons.add_a_photo_outlined),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      var url = await uploadCloudinary(img);
                      // var nav = Navigator.of(context);
                      var sms = ScaffoldMessenger.of(context);
                      if (formkey.currentState!.validate()) {
                        Userdata userdata = await Userdata.getuser(
                            FirebaseAuth.instance.currentUser!.uid);
                        UserPost userpost = UserPost();
                        userpost.userid =
                            FirebaseAuth.instance.currentUser!.uid;
                        userpost.username = userdata.name;
                        userpost.tittle = tittleController.text;
                        userpost.location = locationController.text;
                        userpost.details = detailsController.text;
                        userpost.photoUrl = url!;
                        userpost.postTime = Timestamp.now();
                        UserPost.postData(userpost);
                        sms.showSnackBar(const SnackBar(
                            content: Text("Post upload successfully")));
                        widget.onGoBack2!();
                        if (isPosting) return;
                        setState(() {
                          isPosting = true;
                          const CircularProgressIndicator();
                        });
                      }
                    },
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    child: const Text(
                      "Post",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
