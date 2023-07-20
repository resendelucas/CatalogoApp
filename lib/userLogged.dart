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
          const SliverToBoxAdapter(
            child: SizedBox(height: 40),
          ),
          const SliverToBoxAdapter(
            child: Center(child: Text('Meus Vídeos', style: TextStyle(fontSize: 28, color: Colors.white),)),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 20),
          ),
          SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 12,
              crossAxisSpacing: 1,
              mainAxisExtent: MediaQuery.of(context).size.height * 0.32
    
            ),
            
            delegate: SliverChildBuilderDelegate(
              childCount: videolistTest.length,
              (BuildContext context, int index) {
                return VideoCard(video: videolistTest[index],);
              }
            )
            ),
            
        ],
      );
  }

}