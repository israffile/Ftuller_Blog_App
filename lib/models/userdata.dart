import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';

class Userdata {
  String name;
  String email;
  String password;
  String number;
  String age;
  String gender;

  Userdata()
      : name = "",
        email = "",
        password = "",
        number = "",
        age = "",
        gender = "";

  Map<String, dynamic> toMap() => {
        "name": name,
        "email": email,
        "password": password,
        "number": number,
        "age": age,
        "gender": gender,
      };

  Userdata.fromMap(Map<String, dynamic> map)
      : name = map["name"],
        email = map["email"],
        password = map["password"],
        number = map["number"],
        age = map["age"],
        gender = map["gender"];

  static Future<void> saveuser(String uid, Userdata data) async {
    Map<String, dynamic> mapdata = data.toMap();
    log(mapdata.entries.toString());
    await FirebaseFirestore.instance.collection("users").doc(uid).set(mapdata);
  }

  static Future<Userdata> getuser(String uid) async {
    var data =
        await FirebaseFirestore.instance.collection("users").doc(uid).get();
    var userdata = Userdata.fromMap(data.data()!);
    return userdata;
  }

}

class UserPost {
  String? postid;
  String username, tittle, location, details, userid;

  Timestamp? postTime;

  UserPost()
      : userid = "",
        username = "",
        tittle = "",
        location = "",
        details = "",
        postTime = null;

  Map<String, dynamic> toMap() => {
        "userid": userid,
        "username": username,
        "tittle": tittle,
        "location": location,
        "details": details,
        "postTime": postTime?.millisecondsSinceEpoch,
      };

  UserPost.fromMap(Map<String, dynamic> map, this.postid)
      : userid = map["userid"],
        username = map["username"],
        tittle = map["tittle"],
        location = map["location"],
        details = map["details"],
        postTime = map["postTime"] != null? Timestamp.fromMillisecondsSinceEpoch(map["postTime"]) : null;

  static Future<void> postData(UserPost postData) async {
    Map<String, dynamic> mapdata = postData.toMap();
    log(mapdata.toString());
    await FirebaseFirestore.instance.collection("postdata").doc(postData.postid).set(mapdata);
  }

  static Future<List<UserPost>> getdata() async {
    try {
      var data = await FirebaseFirestore.instance.collection("postdata").get();
      var dd = data.docs;
      var posts = dd.map((e) {
        return UserPost.fromMap(e.data(), e.id);
      }).toList();
      return posts;
    } catch (e) {
      log(e.toString());
      return [];
    }
  }
  static Future<List<UserPost>> getOwndata(String id) async {
    try {
      var data = await FirebaseFirestore.instance.collection("postdata").where('userid', isEqualTo: id).get();
      var dd = data.docs;
      var posts = dd.map((e) {
        return UserPost.fromMap(e.data(), e.id);
      }).toList();
      return posts;
    } catch (e) {
      log(e.toString());
      return [];
    }
  }
    
  static Future<void> deletePost(String fid) async{
    await FirebaseFirestore.instance.collection("postdata").doc(fid).delete();
  }
}
