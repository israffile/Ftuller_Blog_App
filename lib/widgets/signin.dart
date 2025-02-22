// import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:isr_afil_blog_app/widgets/signup.dart';
import 'package:url_launcher/url_launcher.dart';

class Signin extends StatefulWidget {
  const Signin({super.key, this.onGoBack, this.onGoBack2,});

  final VoidCallback? onGoBack;
  final VoidCallback? onGoBack2;

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 90,),
            const Text(
              "Sign in to your account",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 40, right: 40),
              child: TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Mail*'),
                style: const TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 40, right: 40),
              child: TextField(
                controller: passwordController,
                decoration: const InputDecoration(labelText: 'Password*',),
                obscureText: true,
                style: const TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () async {
                // User? user = FirebaseAuth.instance.currentUser;
                var alert = ScaffoldMessenger.of(context);
                var navigator = Navigator.of(context);
                try {
                  await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: emailController.text,
                      password: passwordController.text);
                  alert.showSnackBar(
                    const SnackBar(
                      content: Text('Signin Successfull!'),
                    ),
                  );
                if (navigator.canPop()) {
                  navigator.pop();
                } else if (widget.onGoBack2 != null) {
                  widget.onGoBack2!();
                }
                } catch (e) {
                  alert.showSnackBar(
                    const SnackBar(content: Text('Invalid username/password!')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
              child: const Text('SIGN IN'),
            ),
            // GoogleAuthProvider(),
            const SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have account?", style: TextStyle(color: Color.fromARGB(255, 202, 195, 195), fontWeight: FontWeight.bold),),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Signup(),
                      ),
                    );
                  },
                  child: const Text('Sign up', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),),
                ),
              ],
            ),
            const SizedBox(height: 20,),
            TextButton(
              onPressed: () {
                var nav = Navigator.of(context);
                if (nav.canPop()) {
                  nav.pop();
                } else if (widget.onGoBack != null) {
                  widget.onGoBack!();
                }
              },
              child: const Text(
                'Sign in/Sign up later',
                style: TextStyle(color: Colors.red),
              ),
            ),
            const SizedBox(height: 50,),
            Row(
              children: [
                const Spacer(),
                Row(
                  children: [
                    IconButton(onPressed: () => _launchUrl('https://www.facebook.com/israffile'), icon: const FaIcon(FontAwesomeIcons.facebook, size: 40,), color: const Color.fromARGB(255, 11, 123, 215),),
                    const SizedBox(width: 20,),
                    IconButton(onPressed: () => sendEmail(), icon: const Icon(Icons.email, size: 40,), color: const Color.fromARGB(255, 183, 110, 2),),
                    const SizedBox(width: 20,),
                    IconButton(onPressed: () => _launchUrl("https://www.instagram.com/isr_afil"), icon: const FaIcon(FontAwesomeIcons.instagram, size: 40,), color: const Color.fromARGB(255, 226, 18, 4),),
                  ],
                ),
                const Spacer(),
              ],
            ),
          ],
        ),
      ),
    );
  }
  void _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw "Could not launch $url";
    }
  }

  final String email = 'kazimdisrafil7@gmail.com';
  Future<void> sendEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
    );

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      throw 'Could not launch $emailUri';
    }
  }
}
