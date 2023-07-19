import 'package:catalogo_app/videosTeste.dart';
import 'package:flutter/material.dart';

import 'videoCard.dart';

class UserLoggedVideosScreen extends StatefulWidget {
  const UserLoggedVideosScreen({super.key, required this.username});

  final String username;

  @override
  State<UserLoggedVideosScreen> createState() => _UserLoggedVideosScreenState();
}

class _UserLoggedVideosScreenState extends State<UserLoggedVideosScreen> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverGrid(
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 300,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 1
          ),
          
          delegate: SliverChildBuilderDelegate(
            childCount: videolistTest.length,
            (BuildContext context, int index) {
              // return VideoCard(video: videolistTest[index],);
            }
          )
          ),
          
      ],
    );
  }

}