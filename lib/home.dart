import 'package:catalogo_app/homeVideos.dart';
import 'package:catalogo_app/search.dart';
import 'package:catalogo_app/userVideos.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;

  final List<Widget>_screens = [
    HomeVideos(),
    SearchVideos(),
    UserVideos()
  ];
  
  void onTabTap(int index){
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255,7, 13, 45),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        selectedIconTheme: IconThemeData(color: Colors.white),
        showSelectedLabels: false,
        showUnselectedLabels: false,
				currentIndex: _currentIndex,
        onTap: onTabTap,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home"
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: "Pesquisar"
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "Conta",
          ),
        ],
      ),
    );
  }
}