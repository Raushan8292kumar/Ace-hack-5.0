import 'package:arya_heck/globle_data/globle_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_home_page.dart';

class UserInfoPage extends StatefulWidget {
  const UserInfoPage({super.key});

  @override
  State<UserInfoPage> createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
   Map<String, dynamic>? userdata;

  static TextStyle _style() {
    return GoogleFonts.urbanist(
      fontSize: 20,
      fontWeight: FontWeight.w500,
      color: Colors.white,
    );
  }

  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      islogin = false;
      Navigator.pushAndRemoveUntil(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(builder: (builder) => AppHomePage()),
        (Route<dynamic> route) => false,
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(
        // ignore: use_build_context_synchronously
        context,
      ).showSnackBar(SnackBar(content: Text(e.code)));
    }
  }

  Future<void> getuserdata({
    required String uid,
    //required String field,
  }) async {
    DocumentSnapshot userData =
        await FirebaseFirestore.instance.collection("UserData").doc(uid).get();
    if (userData.exists) {
      setState(() {
        userdata = userData.data() as Map<String, dynamic>;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    final uid = FirebaseAuth.instance.currentUser!.uid;
    getuserdata(uid: uid);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream:
          FirebaseFirestore.instance
              .collection("UserData")
              .where(
                "emailId",
                isEqualTo: FirebaseAuth.instance.currentUser!.email,
              )
              .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator.adaptive());
        }
        if (!snapshot.hasData) {
          return Center(child: Text("No data found"));
        }
        return Scaffold(
          //appBar:AppBar(),
          backgroundColor: Color.fromARGB(200, 150, 150, 150),
          body: SafeArea(
            child: Center(
              child: Container(
                height: 700,
                width: double.infinity,
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(5),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 70,
                        backgroundColor: Colors.black,
                        child: Center(
                          child: Text(
                            "${userdata?["Name"][0]}",
                            style: GoogleFonts.urbanist(
                              fontSize: 100,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      Text("UserId: ${userdata?["Email"]}", style: _style()),
                      SizedBox(height: 15),
                      Text("Name: ${userdata?["Name"]} ", style: _style()),
                      SizedBox(height: 30),
                      TextButton(
                        onPressed: logout,
                        style: styleButton,
                        child: Text("Log Out", style: buttontext),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}