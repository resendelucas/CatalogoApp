import 'package:catalogo_app/videoCard.dart';
import 'package:flutter/material.dart';

class VideoDetails extends StatefulWidget {
  const VideoDetails({super.key, required this.video});

  final VideoDb video;

  @override
  State<VideoDetails> createState() => _VideoDetailsState();
}

class _VideoDetailsState extends State<VideoDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 44, 47, 66),
      body: Column(
        children: [
          const SizedBox(height: 80),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            const SizedBox(width: 24),
            VideoCardNotClickable(video: widget.video),
            Column(
              children: [
              Container(
                height: 80,
                child: Text(
                  widget.video.name,
                  maxLines: 3,
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 20),
                ),
              )
            ],)
          ],)
        ],
      ),
    );
  }
}