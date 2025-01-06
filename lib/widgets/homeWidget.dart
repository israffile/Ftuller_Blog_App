import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:isr_afil_blog_app/models/userdata.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  // final UserPost post;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<List<UserPost>>? userpost;

  void reload() {
    setState(() {
      userpost = UserPost.getdata();
    });
  }

  late TextEditingController tittleController;
  late TextEditingController locationController;
  late TextEditingController detailsController;
  late TextEditingController nameController;

  @override
  void initState() {
    super.initState();
    reload();
  }

  var formkey = GlobalKey<FormState>();
  void _showEditDialog(BuildContext context, UserPost userpost) {
    tittleController = TextEditingController(text: userpost.tittle);
    locationController = TextEditingController(text: userpost.location);
    detailsController = TextEditingController(text: userpost.details);
    nameController = TextEditingController(text: userpost.username);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Form(
          key: formkey,
          child: AlertDialog(
            title: const Text("Edit your post"),
            actions: [
              TextFormField(
                maxLength: 30,
                controller: tittleController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Tittle can't be empty!!";
                  } else {
                    return null;
                  }
                },
                decoration: const InputDecoration(labelText: "Tittle"),
              ),
              TextFormField(
                maxLength: 20,
                controller: locationController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Location can't be empty!!";
                  } else {
                    return null;
                  }
                },
                decoration: const InputDecoration(labelText: "Location"),
              ),
              TextFormField(
                maxLength: 1501,
                controller: detailsController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Details can't be empty!!";
                  } else {
                    return null;
                  }
                },
                decoration: const InputDecoration(labelText: "Details"),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Cancel",
                        style: TextStyle(color: Colors.red),
                      )),
                  TextButton(
                      onPressed: () {
                        if (formkey.currentState!.validate()) {
                          UserPost post = UserPost();
                          post.postid = userpost.postid;
                          post.userid = userpost.userid;
                          post.username = userpost.username;
                          post.tittle = tittleController.text;
                          post.location = locationController.text;
                          post.details = detailsController.text;
                          UserPost.postData(post);
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Post updated!"),
                            ),
                          );
                          reload();
                        }
                      },
                      child: const Text(
                        "Update post",
                        style: TextStyle(color: Colors.blue),
                      )),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 24, 22, 18),
      body: FutureBuilder(
        future: userpost,
        builder: (context, snap) {
          if (snap.hasData) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  // Tabs
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Daily blogs',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text('Travel blogs',
                            style: TextStyle(color: Colors.grey)),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text('Upcoming',
                            style: TextStyle(color: Colors.grey)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Property Listings
                  Expanded(
                    child: ListView(
                      scrollDirection: Axis.vertical,
                      children: [
                        for (var post in snap.requireData)
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
                                padding: const EdgeInsets.only(
                                    left: 8, right: 8, top: 4, bottom: 4),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color:
                                        const Color.fromARGB(255, 56, 47, 33),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  post.username, //user name
                                                  style: const TextStyle(
                                                    color: Color.fromARGB(255, 101, 89, 89),
                                                    overflow: TextOverflow.ellipsis,
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w800),
                                                ),
                                              ],
                                            ),
                                            const Spacer(),
                                            IconButton(
                                              onPressed: () {},
                                              icon: const Icon(Icons.info),
                                            ),
                                            post.userid ==
                                                    FirebaseAuth.instance
                                                        .currentUser?.uid
                                                ? IconButton(
                                                    onPressed: () =>
                                                        _showEditDialog(
                                                            context, post),
                                                    icon: const Icon(
                                                      Icons.edit_outlined,
                                                      color: Colors.blue,
                                                    ),
                                                  )
                                                : const SizedBox.shrink(),
                                            post.userid ==
                                                    FirebaseAuth.instance
                                                        .currentUser?.uid
                                                ? IconButton(
                                                    onPressed: () =>
                                                        _showDeleteDialog(
                                                            context, post),
                                                    // icon: const Icon(Icons.more_vert_sharp),
                                                    icon: const Icon(
                                                      Icons.delete_outlined,
                                                      color: Colors.red,
                                                    ),
                                                  )
                                                : const SizedBox.shrink(),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Column(
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    "Tittle: ${post.tittle}",
                                                    style: const TextStyle(
                                                        overflow: TextOverflow.ellipsis,
                                                        color: Color.fromARGB(
                                                            255, 158, 152, 152),
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    "post-time:${post.postTime}",
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 8),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    "Location: ${post.location}",
                                                    style: const TextStyle(
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      color: Color.fromARGB(
                                                          255, 158, 152, 152),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 8),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    "Details: ${post.details}",
                                                    style: const TextStyle(
                                                      overflow: TextOverflow.clip,
                                                      color: Color.fromARGB(
                                                          255, 255, 255, 255),
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, UserPost post) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("This post will be delete!"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                var nav = Navigator.of(context);
                await UserPost.deletePost(post.postid!);
                nav.pop();
                reload();
              },
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}
