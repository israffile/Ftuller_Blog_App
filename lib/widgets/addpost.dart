import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:isr_afil_blog_app/models/userdata.dart';

class UploadScreen extends StatefulWidget {
  final VoidCallback? onGoBack2;
  const UploadScreen({super.key, required this.onGoBack2});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  var formkey = GlobalKey<FormState>();

  final TextEditingController tittleController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController detailsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
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
                  hintText: "Title:",
                ),
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextFormField(
                maxLength: 20,
                controller: locationController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Location can't be empty";
                  } else {
                    return null;
                  }
                },
                decoration: const InputDecoration(
                  hintText: "location:",
                  border: InputBorder.none,
                ),
                style: const TextStyle(fontSize: 14),
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
                  hintText: "Details:",
                  border: InputBorder.none,
                ),
              ),
              const SizedBox(height: 16),
              const SizedBox(
                width: 30,
                height: 30,
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.add_a_photo_outlined),
              ),
              const SizedBox(
                height: 30,
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    // var nav = Navigator.of(context);
                    var sms = ScaffoldMessenger.of(context);
                    if (formkey.currentState!.validate()) {
                      Userdata userdata = await Userdata.getuser(
                          FirebaseAuth.instance.currentUser!.uid);
                      UserPost userpost = UserPost();
                      userpost.userid = FirebaseAuth.instance.currentUser!.uid;
                      userpost.username = userdata.name;
                      userpost.tittle = tittleController.text;
                      userpost.location = locationController.text;
                      userpost.details = detailsController.text;
                      userpost.postTime = Timestamp.now();
                      UserPost.postData(userpost);
                      sms.showSnackBar(const SnackBar(
                          content: Text("Post upload successfully")));
                      widget.onGoBack2!();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey),
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
    );
  }
}
