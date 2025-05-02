import 'package:arya_heck/globle_data/globle_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'user_info_page.dart';
import 'user_sign_in_page.dart';

class UserProfilePage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => UserProfilePage());
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: currentuser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator.adaptive());
          }
          if (islogin == false) {
            return LoginPage();
          }
          return UserInfoPage();
        },
      ),
    );
  }

  Future<User?> currentuser() async {
    return FirebaseAuth.instance.currentUser;
  }
}
