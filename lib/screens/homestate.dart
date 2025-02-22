import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:isr_afil_blog_app/models/userdata.dart';
import 'package:isr_afil_blog_app/widgets/addpost.dart';
import 'package:isr_afil_blog_app/widgets/homeWidget.dart';
import 'package:isr_afil_blog_app/widgets/profile.dart';
import 'package:isr_afil_blog_app/widgets/signin.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  late UserPost post;

  // final List<Widget> _screens = [
  //   const HomeScreen(),
  //   const UploadScreen(),
  //   NotificationScreen(),
  // ];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          return Scaffold(
            backgroundColor: const Color.fromARGB(255, 24, 22, 18),
            // appBar: AppBar(
            //   backgroundColor: const Color.fromARGB(255, 24, 22, 18),
            //   elevation: 0,
            //   title: Center(
            //     child: Text(
            //       tittle,
            //       style: const TextStyle(
            //         color: Colors.orangeAccent,
            //         fontWeight: FontWeight.bold,
            //       ),
            //     ),
            //   ),
            // ),
            // body: _screens[_currentIndex],
            body: [
              const HomeScreen(),
              snapshot.hasData
                  ? UploadScreen(
                      onGoBack2: () {
                        setState(() {
                          _currentIndex = 0;
                        });
                      },
                    )
                  : Signin(
                      onGoBack2: () {
                        setState(() {
                          _currentIndex = 0;
                        });
                      },
                      onGoBack: () {
                        setState(() {
                          _currentIndex = 0;
                        });
                      },
                    ),
              const Profile(),
            ][_currentIndex],
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: Colors.black,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              unselectedItemColor: Colors.grey,
              items: [
                const BottomNavigationBarItem(
                  icon: Icon(
                    Icons.dashboard,
                    color: Colors.grey,
                  ),
                  label: '',
                ),
                const BottomNavigationBarItem(
                  icon: Icon(
                    Icons.add_circle_rounded,
                  ),
                  label: '',
                ),
                if (snapshot.hasData)
                  const BottomNavigationBarItem(
                    icon: Icon(
                      Icons.person,
                    ),
                    label: '',
                  )
              ],
            ),
          );
        });
  }

  //method one
  // String _getTittle() {
  //   switch (_currentIndex) {
  //     case 0:
  //       return "Home";
  //     case 1:
  //       return "Upload post";
  //     case 2:
  //       return "Notification";
  //     default:
  //       return "Home";
  //   }
  // }

  //method 2
  String get tittle => switch (_currentIndex) {
        0 => "Home",
        1 => "Upload post",
        2 => "Profile",
        _ => "Home",
      };
}
