import 'package:arya_heck/firebase_options.dart';
import 'package:arya_heck/globle_data/globle_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'api/ai_api_key.dart';
import 'pages/app_home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Gemini.init(apiKey: ai_apikey);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GovAssist',
      theme: ThemeData(useMaterial3: true),
      // home: AiChatPage(),
      home: FutureBuilder(
        future: currentuser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator.adaptive());
          }
          if (!snapshot.hasData || snapshot.hasError) {
            islogin = false;
            return AppHomePage();
          }
          islogin = true;
          return AppHomePage();
        },
      ),
    );
  }

  Future<User?> currentuser() async {
    return FirebaseAuth.instance.currentUser;
  }
}
