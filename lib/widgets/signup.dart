import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:isr_afil_blog_app/models/userdata.dart';

class Signup extends StatefulWidget {
  const Signup({
    super.key,
  });

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  var formkey = GlobalKey<FormState>();
  //  Signup({super.key, required this.onSignup});
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController ageController = TextEditingController();

  String? selectedstate;
  List<String> state = ["Male", "Female", "By born non-binary"];

  // final Function(String, String) onSignup;

  DateTime? selectedDate;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding:
              const EdgeInsets.only(top: 16, bottom: 16, left: 40, right: 40),
          child: Form(
            key: formkey,
            child: Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                const Text(
                  "Create new account",
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: nameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Name can't be empt!y";
                    } else {
                      return null;
                    }
                  },
                  decoration: const InputDecoration(labelText: 'Name* '),
                  style: const TextStyle(color: Colors.white),
                ),
                TextFormField(
                  controller: emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Email can't be empty!";
                    } else {
                      return null;
                    }
                  },
                  decoration: const InputDecoration(labelText: 'Email* '),
                  style: const TextStyle(color: Colors.white),
                ),
                TextFormField(
                  maxLength: 14,
                  controller: numberController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Number can't be empty";
                    } else {
                      return null;
                    }
                  },
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(labelText: 'Number* '),
                  style: const TextStyle(color: Colors.white),
                ),
                TextFormField(
                  maxLength: 02,
                  controller: ageController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Age can't be empty";
                    } else {
                      return null;
                    }
                  },
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Age* '),
                  style: const TextStyle(color: Colors.white),
                ),
                DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    style: const TextStyle(color: Colors.white),
                    isExpanded: true,
                    dropdownColor: const Color.fromARGB(255, 88, 88, 88),
                    menuMaxHeight: 200,
                    value: selectedstate,
                    hint: const Text(
                      "Select gender",
                      style:
                          TextStyle(color: Color.fromARGB(255, 170, 170, 170)),
                    ),
                    icon: const Icon(Icons.arrow_drop_down),
                    onChanged: (String? newvalue) {
                      setState(
                        () {
                          selectedstate = newvalue;
                        },
                      );
                    },
                    items: state.map(
                      (String daataa) {
                        return DropdownMenuItem<String>(
                          value: daataa,
                          child: Text(daataa),
                        );
                      },
                    ).toList(),
                  ),
                ),
                TextFormField(
                  controller: passwordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Password can't be empty";
                    } else {
                      return null;
                    }
                  },
                  decoration: const InputDecoration(labelText: 'Password*'),
                  obscureText: false,
                  style: const TextStyle(color: Colors.white),
                ),
                TextFormField(
                  controller: confirmPasswordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Password can't be empty";
                    } else {
                      return null;
                    }
                  },
                  decoration:
                      const InputDecoration(labelText: 'Confirm password*'),
                  obscureText: false,
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    var navigator = Navigator.of(context);
                    var scaffold = ScaffoldMessenger.of(context);
                    if (passwordController.text ==
                        confirmPasswordController.text) {
                      var user = await FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                              email: emailController.text,
                              password: passwordController.text);
                      Userdata userdata = Userdata();
                      userdata.name = nameController.text;
                      userdata.email = emailController.text;
                      userdata.password = passwordController.text;
                      userdata.number = numberController.text;
                      userdata.age = ageController.text;
                      userdata.gender = selectedstate!;
                      Userdata.saveuser(user.user!.uid, userdata);
                      scaffold.showSnackBar(const SnackBar(
                          content: Text(
                        'Sign up successfully',
                        style: TextStyle(color: Colors.white),
                      )));
                      log(user.toString());
                      navigator.pop();
                    } else {
                      var sms = ScaffoldMessenger.of(context);
                      sms.showSnackBar(
                        const SnackBar(
                          content: Text("Password didn't match"),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white),
                  child: const Text('SIGN UP'),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already have a account?",
                      style: TextStyle(color: Colors.white),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Sign in',
                          style: TextStyle(color: Colors.blue)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
