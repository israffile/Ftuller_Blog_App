// import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:isr_afil_blog_app/widgets/signup.dart';

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
      backgroundColor: const Color.fromARGB(255, 24, 22, 18),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              "Sign in your account",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Mail'),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
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
              child: const Text('SIGN IN'),
            ),
            // GoogleAuthProvider(),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have account?", style: TextStyle(color: Color.fromARGB(255, 202, 195, 195)),),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Signup(),
                      ),
                    );
                  },
                  child: const Text('Sign up'),
                ),
              ],
            ),
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
            Row(
              children: [
                IconButton(onPressed: (){}, icon: const FaIcon(FontAwesomeIcons.facebook, size: 50,)),
                IconButton(onPressed: (){}, icon: const Icon(Icons.email_outlined)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
