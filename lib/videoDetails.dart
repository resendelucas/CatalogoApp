import 'package:catalogo_app/addVideoPopUp.dart';
import 'package:catalogo_app/videoCard.dart';
import 'package:flutter/material.dart';
import 'login.dart';
import 'DatabaseHelper.dart';

// ignore: must_be_immutable
class VideoDetails extends StatefulWidget {
  VideoDetails({super.key, required this.video});

  VideoDb video;
  @override
  State<VideoDetails> createState() => _VideoDetailsState();
}

class _VideoDetailsState extends State<VideoDetails> {

  // void changeVideo(VideoDb novoVideo){
  //   setState(() {
  //     video = no
  //   });
  // }

  bool verifyUserLogged(){
    // print("AQUI NO VIDEO DETAIL: $USER_NAME");
    if (USER_NAME == '') return true;
    return false;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: verifyUserLogged() ? null: FloatingActionButtonLocation.endFloat,
      floatingActionButton: verifyUserLogged() ? null: FloatingActionButton(
          backgroundColor: const Color.fromARGB(255, 132, 172, 205),
          child: Icon(Icons.edit),
          onPressed: (){
            showDialog(
              context: context, 
              builder: (context){
                return EditVideoScreen(video: widget.video,);
              }).then((value){
                print(value);
                setState(() {
                  widget.video = value;
                });
                print(widget.video.name);
              });
      }),
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
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: 120,
                  child: Text(
                    widget.video.name,
                    maxLines: 3,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 28),
                  ),
                ),
                // SizedBox(height: 50,),
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
                FutureBuilder(
                  future: DatabaseHelper().genresByVideo(widget.video.name),
                  builder:(context, snapshot) {
                    if (snapshot.hasData){

                    return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      height: 45,
                      child: Text('${snapshot.data!.join(" ")}',
                      
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: const Color.fromARGB(255, 197, 194, 194)),),
                    ),
                    );
                    }
                    else {
                      return CircularProgressIndicator();
                    }
                  },),
              ],)
            ],),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
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