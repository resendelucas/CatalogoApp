import 'package:catalogo_app/userLogged.dart';
import 'package:flutter/material.dart';

class UserVideos extends StatefulWidget {
  const UserVideos({super.key, required this.username});

  final String username;

  @override
  State<UserVideos> createState() => _UserVideosState();
}

class _UserVideosState extends State<UserVideos> {
  int _currentIndex = 0;

  late final List<Widget> _screens = [
    UserLoggedVideosScreen(
      username: '',
    ),
    // UserNotLoggedScreen()
  ];

  @override
  void initState() {
    if (widget.username == '')
      _currentIndex = 1;
    else
      _currentIndex = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _screens[_currentIndex];
  }
}
