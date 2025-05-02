import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../globle_data/globle_data.dart';

class SignUpPages extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => SignUpPages());
  const SignUpPages({super.key});

  @override
  State<SignUpPages> createState() => _SignUpPagesState();
}

class _SignUpPagesState extends State<SignUpPages> {
  late final TextEditingController emailcontroller;
  late final TextEditingController passwordcontroller;
  late final TextEditingController namecontroller;
  late final UserCredential userCredential;
  final formkey = GlobalKey<FormState>();

  @override
  void initState() {
    emailcontroller = TextEditingController();
    passwordcontroller = TextEditingController();
    namecontroller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    emailcontroller.dispose();
    passwordcontroller.dispose();
    namecontroller.dispose();
    super.dispose();
  }

  void checkup() async {
    if (formkey.currentState!.validate()) {
      await onclick();
    }
  }

  Future<void> onclick() async {
    String email = emailcontroller.text.trim();
    String password = passwordcontroller.text.trim();
    String name = namecontroller.text.trim();
    try {
      userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      await uploaddb(
        name: name,
        email: email,
        //password: password,
        uid: userCredential.user!.uid,
      );
      ScaffoldMessenger.of(
        // ignore: use_build_context_synchronously
        context,
      ).showSnackBar(SnackBar(content: Text("Registration complete")));
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("${e.message}")));
    }
  }

  Future<void> uploaddb({
    required String name,
    required String email,
    //required String password,
    required String uid,
  }) async {
    await FirebaseFirestore.instance.collection("UserData").doc(uid).set({
      "Name": name,
      "Email": email,
      //"Password": password,
    });
  }

  bool isValidEmail(String email) {
    // Regular expression for validating an email
    String pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    RegExp regex = RegExp(pattern);
    return regex.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(15),
        child: SizedBox(
          width: double.infinity,
          child: Form(
            key: formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Sign Up.",
                  style: TextStyle(fontSize: 50, fontWeight: FontWeight.w800),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: emailcontroller,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 27),
                    hintText: "Email",
                    enabledBorder: enableborder,
                    border: enableborder,
                    focusedBorder: focusborder,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Email is needed";
                    } else if (!isValidEmail(value.trim())) {
                      return "Invalid email format";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: passwordcontroller,
                  decoration: InputDecoration(
                    hintText: "Password",
                    contentPadding: EdgeInsets.symmetric(horizontal: 27),
                    border: enableborder,
                    enabledBorder: enableborder,
                    focusedBorder: focusborder,
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty ||
                        value.trim().length < 6) {
                      return "Invalid password";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: namecontroller,
                  decoration: InputDecoration(
                    hintText: "Name",
                    contentPadding: EdgeInsets.symmetric(horizontal: 27),
                    border: enableborder,
                    enabledBorder: enableborder,
                    focusedBorder: focusborder,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Name is needed";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: checkup,
                  style: buttonstyle,
                  child: Text(
                    "Sign Up",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: RichText(
                    text: TextSpan(
                      text: "Already have an Account? ",
                      style: TextStyle(color: Colors.black54),
                      children: [
                        TextSpan(
                          text: "Click to login",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
