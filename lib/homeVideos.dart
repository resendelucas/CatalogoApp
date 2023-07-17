import 'package:flutter/material.dart';

class HomeVideos extends StatefulWidget {
  const HomeVideos({super.key, required this.user});

  final String user;

  @override
  State<HomeVideos> createState() => _HomeVideosState();
}

class _HomeVideosState extends State<HomeVideos> {
   String _user;
  
  @override
  void initState(){
    super.initState();
    _user = widget.user;
  }
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Text("usuario:", style: TextStyle(color: Colors.white, fontSize: 24),),
      ),
    );
  }
}