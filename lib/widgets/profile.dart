import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:isr_afil_blog_app/models/userdata.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  void _showSignOutDialog(BuildContext context) async {
    var navigator = Navigator.of(context);

    bool? signout = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Do you want to sign out?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Handle sign-out logic
                FirebaseAuth.instance.signOut();
                Navigator.of(context).pop(true);
              },
              child: const Text(
                'Sign Out',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
    if (signout != null && signout == true) {
      navigator.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Expanded(
        child: FutureBuilder(
            future: UserPost.getOwndata(FirebaseAuth.instance.currentUser!.uid),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView(
                  scrollDirection: Axis.vertical,
                  children: [
                    for (var post in snapshot.requireData)
                      Column(
                        children: [
                          // Stack(
                          //   children: [
                          //     ClipRRect(
                          //       borderRadius:
                          //           const BorderRadius.vertical(top: Radius.circular(12)),
                          //       child: Image.network(

                          //         height: 180,
                          //         width: double.infinity,
                          //         fit: BoxFit.fill,
                          //       ),
                          //     ),
                          //     const Positioned(
                          //       top: 8,
                          //       right: 8,
                          //       child: CircleAvatar(
                          //         backgroundColor: Colors.white,
                          //         child: Icon(Icons.threed_rotation),
                          //       ),
                          //     ),
                          //   ],
                          // ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      post.username, //user name
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w800),
                                    ),
                                    const Spacer(),
                                    IconButton(
                                      onPressed: () {},
                                      icon: const Icon(Icons.info),
                                    ),
                                    // post.userid == FirebaseAuth.instance.currentUser?.uid
                                    //     ? IconButton(
                                    //         onPressed: () =>
                                    //             _showEditDialog(context, post),
                                    //         icon: const Icon(
                                    //           Icons.edit_outlined,
                                    //           color: Colors.blue,
                                    //         ),
                                    //       )
                                    //     : const SizedBox.shrink(),
                                    // post.userid == FirebaseAuth.instance.currentUser?.uid
                                    //     ? IconButton(
                                    //         onPressed: () =>
                                    //             _showDeleteDialog(
                                    //                 context, post),
                                    //         // icon: const Icon(Icons.more_vert_sharp),
                                    //         icon: const Icon(
                                    //           Icons.delete_outlined,
                                    //           color: Colors.red,
                                    //         ),
                                    //       )
                                    //     : const SizedBox.shrink(),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Column(
                                  children: [
                                    Center(
                                      child: Text(
                                        "Tittle: ${post.tittle}",
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Center(
                                      child: Text(
                                        "Location: ${post.location}",
                                        style: const TextStyle(
                                            color: Colors.grey),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "Details: ${post.details}",
                                      style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                  ],
                );
              } else {
                return const Center(child: Text("No post available"));
              }
            }),
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: FutureBuilder(
  //       future: Userdata.getuser(FirebaseAuth.instance.currentUser!.uid),
  //       builder: (context, snap) {
  //         if (snap.hasData) {
  //           return ListView(
  //           padding: const EdgeInsets.all(16.0),
  //           children: [
  //             ListTile(
  //               title: Text('Name: ${snap.requireData.name}', style: const TextStyle(fontWeight: FontWeight.bold),),
  //             ),
  //             ListTile(
  //               title: Text('E-mail: ${snap.requireData.email}'),
  //               trailing: const Icon(Icons.arrow_forward_ios),
  //               onTap: () {},
  //             ),
  //             ListTile(
  //               title: Text('Gender: ${snap.requireData.gender}'),
  //               trailing: const Icon(Icons.arrow_forward_ios),
  //               onTap: () {},
  //             ),
  //             ListTile(
  //               title: Text('Gender: ${snap.requireData.age}'),
  //               trailing: const Icon(Icons.arrow_forward_ios),
  //               onTap: () {},
  //             ),
  //             ListTile(
  //               title: Text('Number: ${snap.requireData.number}'),
  //               trailing: const Icon(Icons.arrow_forward_ios),
  //               onTap: () {},
  //             ),
  //             ListTile(
  //               title: const Text('Support'),
  //               trailing: const Icon(Icons.arrow_forward_ios),
  //               onTap: () {},
  //             ),
  //             const SizedBox(height: 20),
  //             Center(
  //               child: ElevatedButton(
  //                 onPressed: () => _showSignOutDialog(context),
  //                 style: ElevatedButton.styleFrom(
  //                   backgroundColor: Colors.red,
  //                   shape: RoundedRectangleBorder(
  //                     borderRadius: BorderRadius.circular(8.0),
  //                   ),
  //                   padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
  //                 ),
  //                 child: const Text('Sign Out', style: TextStyle(color: Colors.white)),
  //               ),
  //             ),
  //           ],
  //         );
  //         } else {
  //           return const Center(
  //             child: CircularProgressIndicator(),
  //           );
  //         }
  //       }
  //     ),
  //   );
  // }
}
