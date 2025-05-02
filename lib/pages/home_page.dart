import 'package:arya_heck/globle_data/globle_data.dart';
import 'package:arya_heck/pages/user_sign_in_page.dart';
import 'package:flutter/material.dart';

import '../globle_data/central_gorv_data_page.dart';
//import '../globle_data/gorv_of_india_data.dart';
import '../globle_data/central_gorv_related_doc.dart';
import 'gorv_scheme_details_page.dart';
import 'user_profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CircleAvatar(child: Image.asset("assets/images/image-00.webp",width: 45,)),
        backgroundColor: Colors.blueAccent,
        title: Text(
          "Central Government Scheme",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: GestureDetector(
              onTap: () {
                if (islogin == true) {
                  Navigator.of(context).push(UserProfilePage.route());
                } else {
                  Navigator.of(context).push(LoginPage.route());
                }
              },
              child: Icon(Icons.account_circle, size: 40, color: Colors.white),
            ),
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: ListView.builder(
          itemCount: governmentSchemes.length,
          itemBuilder: (context, index) {
            final items = governmentSchemes[index];
            return GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>GorvSchemeDetailsPage(schemeitem:items,index: index,doc:schemeDocuments,)));
              },
              child: Card(
                margin: EdgeInsets.symmetric(vertical: 10),
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(15),
                      ),
                      child: Image.network(
                        items["imageurl"].toString(),
                        errorBuilder: (context, error, stackTrace) => Icon(Icons.broken_image),
                        height: MediaQuery.of(context).size.height / 3,
                        width: double.infinity,
                        fit:
                            BoxFit
                                .contain, // Use BoxFit.contain to show the full image
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        items["title"].toString(),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
