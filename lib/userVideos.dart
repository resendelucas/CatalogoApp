import 'package:flutter/material.dart';

class UserVideos extends StatefulWidget {
  const UserVideos({super.key});

  @override
  State<UserVideos> createState() => _UserVideosState();
}

class _UserVideosState extends State<UserVideos> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Text("MEUS VIDEOS", style: TextStyle(color: Colors.white, fontSize: 24)),
      ),
    );
  }
}


