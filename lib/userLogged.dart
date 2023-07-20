import 'package:catalogo_app/DatabaseHelper.dart';
import 'package:flutter/material.dart';

import 'videoCard.dart';

class UserLoggedVideosScreen extends StatefulWidget {
  const UserLoggedVideosScreen({super.key, required this.username});

  final String username;

  @override
  State<UserLoggedVideosScreen> createState() => _UserLoggedVideosScreenState();
}

class _UserLoggedVideosScreenState extends State<UserLoggedVideosScreen> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
    new GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
  super.initState();
  WidgetsBinding.instance
      .addPostFrameCallback((_) => _refreshIndicatorKey.currentState!.show());
  }

  Future<List<VideoDb>> _futureVideos = DatabaseHelper().filterVideo(2, "", genre: 'Todos'); 
  
  Future<Null> _refresh(){
    return _futureVideos.then((value) {
      setState(() {
        _futureVideos = DatabaseHelper().filterVideo(2, "", genre: 'Todos'); 
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: _refresh,
      child: CustomScrollView(
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
            FutureBuilder(
              future: _futureVideos,
              builder: (context, snapshot) {
                if (snapshot.hasData){
                  return SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 1,
                    mainAxisExtent: MediaQuery.of(context).size.height * 0.32
          
                  ),
                  
                  delegate: SliverChildBuilderDelegate(
                    childCount: snapshot.data!.length,
                    (BuildContext context, int index) {
                      return VideoCard(video: snapshot.data![index],);
                    }
                  )
                  );
                }
                else {
                  // print('aaaaaaaaa');
                  return const SliverToBoxAdapter(
                    child: CircularProgressIndicator(),
                  );
                }
              }
              )
          ],
        ),
    );
  }

}