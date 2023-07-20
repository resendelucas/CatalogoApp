import 'package:catalogo_app/homeVideos.dart';
import 'package:catalogo_app/search.dart';
import 'package:catalogo_app/userVideos.dart';
import 'package:flutter/material.dart';

import 'DatabaseHelper.dart';
import 'addVideoPopUp.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.user});

  final String user;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;

  late final List<Widget> _screens = [
    HomeVideos(user: widget.user),
    SearchVideos(),
    UserVideos(username: widget.user)
  ];

  void onTabTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  bool verifyUserScreen() {
    if (_currentIndex == 2 && widget.user != '') return false;
    return true;
  }

  @override
  void initState() {
    DatabaseHelper().autoPopulateDb();
    super.initState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation:
          verifyUserScreen() ? null : FloatingActionButtonLocation.endFloat,
      floatingActionButton: verifyUserScreen()
          ? null
          : FloatingActionButton(
              backgroundColor: const Color.fromARGB(255, 132, 172, 205),
              child: Icon(Icons.add),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AddVideoScreen();
                    });
              }),
      backgroundColor: Color.fromARGB(255, 44, 47, 66),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        selectedIconTheme: IconThemeData(color: Colors.white),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: _currentIndex,
        onTap: onTabTap,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Pesquisar"),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Conta",
          ),
        ],
      ),
    );
  }
}
