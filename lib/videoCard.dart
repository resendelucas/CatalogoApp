import 'package:flutter/material.dart';

import 'videoDetails.dart';

/*class Video {
  int id;
  String titulo;
  String imagem;

  Video(this.id, this.imagem, this.titulo);
}*/

class VideoDb {
  int id;
  String name;
  String description;
  String thumbnailImageId;
  int type;
  String ageRestriction;
  int durationMinutes;
  String releaseDate;
  List<String> genres;

  VideoDb(
    this.id,
    this.name,
    this.description,
    this.type,
    this.ageRestriction,
    this.durationMinutes,
    this.thumbnailImageId,
    this.releaseDate,
    this.genres
  );
}

class VideoCard extends StatelessWidget {
  const VideoCard({super.key, required this.video});
  final VideoDb video;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => VideoDetails(video: video)));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        height: 220,
        width: 140,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            image: DecorationImage(
                image: NetworkImage(video.thumbnailImageId), fit: BoxFit.cover)),
      
      ),
    );
  }
}

class VideoCardNotClickable extends StatelessWidget {
  const VideoCardNotClickable({super.key, required this.video});
  final VideoDb video;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      width: 140,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          image: DecorationImage(
              image: NetworkImage(video.thumbnailImageId), fit: BoxFit.cover)),
    );
  }
}
