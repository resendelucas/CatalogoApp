import 'package:catalogo_app/userLogged.dart';
import 'package:flutter/material.dart';

class UserVideos extends StatefulWidget {
  const UserVideos({super.key});

  @override
  State<UserVideos> createState() => _UserVideosState();
}

class _UserVideosState extends State<UserVideos> {

  int _currentIndex = 0;

  // late final List<Widget>_screens = [
  //   UserLoggedVideosScreen(),
  //   UserNotLoggedScreen()
  // ];


  @override
  Widget build(BuildContext context) {
    return UserLoggedVideosScreen(username: '');
  }
}

