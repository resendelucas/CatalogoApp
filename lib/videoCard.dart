
import 'package:flutter/material.dart';

class Video {
  int id;
  String titulo;
  String imagem;

  Video(this.id, this.imagem, this.titulo);
}

class VideoDb {
  int id;
  String name;
  String description;
  String thumbnailImageId;
  int type;
  String ageRestriction;
  int durationMinutes;
  String releaseDate;

  VideoDb(
    this.id,
    this.name,
    this.description,
    this.type,
    this.ageRestriction,
    this.durationMinutes,
    this.thumbnailImageId,
    this.releaseDate
  );
}

class VideoCard extends StatelessWidget {
  const VideoCard({super.key, required this.video});
  final VideoDb video;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6),
      height: 220,
      width: 140,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          image: DecorationImage(
              image: NetworkImage(video.thumbnailImageId), fit: BoxFit.cover)),
    );
  }
}
