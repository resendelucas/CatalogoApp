import 'package:flutter/material.dart';


class UserNotLoggedScreen extends StatefulWidget {
  const UserNotLoggedScreen({super.key});


  @override
  State<UserNotLoggedScreen> createState() => _UserLoggedVideosScreenState();
}

class _UserLoggedVideosScreenState extends State<UserNotLoggedScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 80,),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text('Para acessar,\nÉ preciso fazer login', style: TextStyle(fontSize: 26, color: Colors.white, fontWeight: FontWeight.bold),),
        ),
        SizedBox(height: 30),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: SizedBox(
            width: MediaQuery.of(context).size.width - 80,
            height: 50,
            child: ElevatedButton(
              
                onPressed: (){
                    Navigator.pop(context);
                  },
                child: const Text(
                  'Login',
                  style: TextStyle(fontSize: 20),
                )),
            ),
        ),
      ],
      );
  }

}