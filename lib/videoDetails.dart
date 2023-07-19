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
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 80),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              const SizedBox(width: 24),
              Material(
                elevation: 15,
                borderRadius: BorderRadius.circular(6),
                child: VideoCardNotClickable(video: widget.video)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  height: 60,
                  child: Text(
                    widget.video.name,
                    maxLines: 3,
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 28),
                  ),
                ),
                SizedBox(height: 50,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Text(widget.video.type.isEven ? 'Filme':'Série',
                  style: TextStyle(color: const Color.fromARGB(255, 197, 194, 194))),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Text('Lançamento: ${widget.video.releaseDate}',
                  style: TextStyle(color: const Color.fromARGB(255, 197, 194, 194))),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Text('Duração: ${widget.video.durationMinutes.toString()} minutos',
                  style: TextStyle(color: const Color.fromARGB(255, 197, 194, 194))),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Text('Restrição: ${widget.video.ageRestriction}+',
                  style: TextStyle(color: const Color.fromARGB(255, 197, 194, 194)),),
                ),
              ],)
            ],),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
              child: Text('Descrição', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 22),),
            ),
            Container(
              height: MediaQuery.of(context).size.height*0.45,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                widget.video.description,
                maxLines: 10,
                style: TextStyle(
                  fontSize: 16,
                  color: const Color.fromARGB(255, 235, 233, 229),
                  fontWeight: FontWeight.w500
              ),),
            )
          ],
        ),
      ),
    );
  }
}