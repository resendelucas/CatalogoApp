import 'package:flutter/material.dart';
class Video {
  int id;
  String titulo;
  String imagem;

  Video(this.id, this.imagem, this.titulo);
}


class VideoCard extends StatelessWidget {
  const VideoCard({super.key, required this.video});
  final Video video;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6),
      height: 220,
      width: 140,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        image: DecorationImage(
          image: NetworkImage(video.imagem),
          fit: BoxFit.cover
        )
      ),
    );
  }
}