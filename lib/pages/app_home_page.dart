import 'package:flutter/material.dart';

import 'home_page.dart';
import 'state_home_page.dart';

class AppHomePage extends StatefulWidget {
  const AppHomePage({super.key});

  @override
  State<AppHomePage> createState() => _AppHomePageState();
}

class _AppHomePageState extends State<AppHomePage> {
  final List<Widget> pages = [HomePage(),StateHomePage()];
  int indexcount = 0;
  //late final String home;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: indexcount, children: pages),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) {
          setState(() {
            indexcount = value;
          });
        },
        currentIndex:indexcount,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.black,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 30),
            label: "Central",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.store_mall_directory_rounded, size: 30),
            label: "State",
          ),
        ],
      ),
    );
  }
}
