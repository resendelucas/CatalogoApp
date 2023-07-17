import 'package:flutter/material.dart';

class SearchVideos extends StatefulWidget {
  const SearchVideos({super.key});

  @override
  State<SearchVideos> createState() => _SearchVideosState();
}

class _SearchVideosState extends State<SearchVideos> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Text("TELA PESQUISA", style: TextStyle(color: Colors.white, fontSize: 24)),
      ),
    );
  }
}