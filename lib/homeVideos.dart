import 'package:flutter/material.dart';
import 'videoCard.dart';
import 'videosTeste.dart';
import 'DatabaseHelper.dart';
class HomeVideos extends StatefulWidget {
  const HomeVideos({super.key, required this.user});

  final String user;

  @override
  State<HomeVideos> createState() => _HomeVideosState();
}

class _HomeVideosState extends State<HomeVideos> {

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        const SizedBox(height: 40),
        Center(child: Text("Catálogo de Vídeos", style: TextStyle(color: Colors.white, fontSize: 28),)),
        const SizedBox(height: 40),
        Padding(padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10), child: Text('Filmes', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600))),
        // FutureBuilder(builder:(context, snapshot) {
          
        // },)
        videoListBuilder(DatabaseHelper().filterVideo(0) as List<VideoDb>),
        Padding(padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10), child: Text('Series', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600))),
        videoListBuilder(DatabaseHelper().filterVideo(1) as List<VideoDb>),
        // generalVideoListBuilder(videolistTest, generosTest)
      ]),
    );
  }



  Widget videoListBuilder(List<VideoDb> videolist){
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 26, vertical: 6),
      height: MediaQuery.of(context).size.height * 0.30,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: videolist.length,
        itemBuilder: (context, index) {
          return VideoCard(video: videolist[index],
          );
        }),
    );
  }
  
  // Widget generalVideoListBuilder(List<Video> videolist, List<String> genreList){
  //   return ListView.builder(
  //     itemCount: genreList.length,
  //     itemBuilder: (context, index) {
  //       return Column(
  //         children: [
  //            Padding(
  //             padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10), 
  //             child: Text(
  //               genreList[index],
  //               style: const TextStyle(
  //                 color: Colors.white, 
  //                 fontSize: 20, 
  //                 fontWeight: FontWeight.w600))),
  //           videoListBuilder(videolist)
  //         ],
  //       );
  //     }
  //   );
  // }
}