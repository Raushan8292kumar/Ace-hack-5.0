import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../globle_data/globle_data.dart';
import 'usre_sign_up_page.dart';

class LoginPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => LoginPage());
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final TextEditingController emailcontroller;
  late final TextEditingController passwordcontroller;

  final formkey = GlobalKey<FormState>();
  @override
  void initState() {
    emailcontroller = TextEditingController();
    passwordcontroller = TextEditingController();

    super.initState();
  }

  void checkup() async {
    if (formkey.currentState!.validate()) {
      await onclick();
    }
  }

  Future<void> onclick() async {
    String email = emailcontroller.text.trim();
    String password = passwordcontroller.text.trim();
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      ScaffoldMessenger.of(
        // ignore: use_build_context_synchronously
        context,
      ).showSnackBar(SnackBar(content: Text("Login Succesfull")));
      islogin = true;
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message.toString())));
    }
  }

  @override
  void dispose() {
    emailcontroller.dispose();
    passwordcontroller.dispose();

    // formkey.currentState!.validate();
    super.dispose();
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
                  "Login",
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
                      return "inviled password";
                    }
                    return null;
                  },
                ),

                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: checkup,
                  style: buttonstyle,
                  child: Text(
                    "Login",
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
                    Navigator.of(context).push(SignUpPages.route());
                  },
                  child: RichText(
                    text: TextSpan(
                      text: "Don't have an account? ",
                      style: TextStyle(color: Colors.black54),
                      children: [
                        TextSpan(
                          text: "Click to SignUp",
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
