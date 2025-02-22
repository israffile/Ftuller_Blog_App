import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:isr_afil_blog_app/models/userdata.dart';
import 'package:isr_afil_blog_app/widgets/more&sign.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Future<List<UserPost>>? ownpost;

  void reload() {
    setState(() {
      ownpost = UserPost.getOwndata(FirebaseAuth.instance.currentUser!.uid);
    });
  }

  late TextEditingController tittleController;
  late TextEditingController locationController;
  late TextEditingController detailsController;
  late TextEditingController nameController;

  String time(Timestamp time) {
    var datetime =
        DateTime.fromMillisecondsSinceEpoch(time.millisecondsSinceEpoch);
    return "${datetime.hour}:${datetime.minute}; ${datetime.day}-${datetime.month}-${datetime.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: FutureBuilder(
          future: Userdata.getuser(FirebaseAuth.instance.currentUser!.uid),
          builder: (context, snap) {
            if (snap.hasData) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Column(
                      children: [
                        const CircleAvatar(
                          radius: 50,
                          backgroundImage:
                              NetworkImage('https://via.placeholder.com/150'),
                        ),
                        Text(
                          snap.requireData.name, //name
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          snap.requireData.email, //email
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildStat('3,820', 'Followers'),
                            _buildStat('6,290', 'Following'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const MoreSign()));
                        },
                        child: const Text(
                          "Profile more details",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.arrow_circle_right_outlined),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'My Posts',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildPost(),
                ],
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  Widget _buildStat(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  void _showDialog(BuildContext context, UserPost post) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 82, 82, 82),
          title: const Row(
            children: [
              Text(
                "Edit or delete post  ",
              ),
              Icon(
                Icons.info,
                color: Color.fromARGB(255, 52, 52, 52),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 52, 52, 52)),
              onPressed: () => _showEditDialog(context, post),
              child: const Icon(
                Icons.edit,
                color: Colors.blue,
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 52, 52, 52)),
              onPressed: () => _showDeleteDialog(context, post),
              child: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
            ),
          ],
        );
      },
    );
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
            backgroundColor: const Color.fromARGB(255, 126, 126, 126),
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
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 52, 52, 52)),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Cancel",
                        style: TextStyle(color: Colors.red),
                      )),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 52, 52, 52)),
                      onPressed: () {
                        if (formkey.currentState!.validate()) {
                          UserPost post = UserPost();
                          post.postid = userpost.postid;
                          post.userid = userpost.userid;
                          post.username = userpost.username;
                          post.tittle = tittleController.text;
                          post.location = locationController.text;
                          post.details = detailsController.text;
                          post.postTime = Timestamp.now();
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

  void _showDeleteDialog(BuildContext context, UserPost post) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 126, 126, 126),
          title: const Text("This post will be delete!"),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 52, 52, 52)),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 52, 52, 52)),
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

  // Widget _buildWorkoutCard(String title, String imageUrl) {
  Widget _buildPost() {
    return FutureBuilder(
      future: UserPost.getOwndata(FirebaseAuth.instance.currentUser!.uid),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Column(
            children: [
              for (var post in snapshot.requireData)
                GestureDetector(
                  onLongPress: () => _showDialog(context, post),
                  child: Card(
                    color: Colors.grey[900],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const CircleAvatar(
                                radius: 20,
                                backgroundImage: NetworkImage(
                                    'https://via.placeholder.com/150'), //img
                              ),
                              const SizedBox(width: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    post.username, //user name
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    time(post.postTime!),
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            height: MediaQuery.of(context).size.width * 0.9,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                            ),
                            child: Image.network(
                              post.photoUrl,
                              fit: BoxFit.cover,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return const Center(
                                    child:
                                        CircularProgressIndicator()); // Show loading indicator
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.image_not_supported,
                                    size: 50, color: Colors.grey);
                              },
                            ),
                          ),
                          Text(
                            "Tittle: ${post.tittle}", //tittle section
                            style: const TextStyle(
                                color: Color.fromARGB(255, 113, 181, 215),
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "location: ${post.location}", //location section
                            style: const TextStyle(color: Colors.grey),
                          ),
                          Text(
                            'Details: ${post.details}', //details section
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
