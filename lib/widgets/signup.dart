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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              "Create your account",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
                // height: 20,
                ),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name: '),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email: '),
            ),
            TextField(
              maxLength: 10,
              controller: numberController,
              decoration: const InputDecoration(labelText: 'Number: '),
            ),
            TextField(
              maxLength: 02,
              controller: ageController,
              decoration: const InputDecoration(labelText: 'Age: '),
            ),
            DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                dropdownColor: Colors.white,
                menuMaxHeight: 200,
                value: selectedstate,
                hint: const Text("Select gender"),
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
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password: '),
              obscureText: false,
            ),
            TextField(
              controller: confirmPasswordController,
              decoration: const InputDecoration(labelText: 'Confirm password'),
              obscureText: false,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                var navigator = Navigator.of(context);
                var scaffold = ScaffoldMessenger.of(context);
                if (passwordController.text == confirmPasswordController.text) {
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
                  scaffold.showSnackBar(
                      const SnackBar(content: Text('Sign up successfully')));
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
              child: const Text('SIGN UP'),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Already have a account?"),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Sign in'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
