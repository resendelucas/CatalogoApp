import 'package:flutter/material.dart';

class HomeVideos extends StatefulWidget {
  const HomeVideos({super.key});

  @override
  State<HomeVideos> createState() => _HomeVideosState();
}

class _HomeVideosState extends State<HomeVideos> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Text("TELA PRINCIPAL", style: TextStyle(color: Colors.white, fontSize: 24),),
      ),
    );
  }
}