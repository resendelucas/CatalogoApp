import 'package:catalogo_app/home.dart';
import 'package:flutter/material.dart';
import 'register.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final userController = TextEditingController();
  final passwordController = TextEditingController();


  @override
  void dispose(){

    userController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 150
              ),
            Center(
              child: Text('Entrar', style: TextStyle(
                fontSize: 36, 
                color: Colors.blue[400]
                ))
              ),
            Container(
              padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.12, left: 40, right: 40),
              child: Column(
                children: [
                  TextField(
                    controller: userController,
                    decoration: InputDecoration(
                      labelText: 'Usuário',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)
                      )
                    ),
                  ),
                  const SizedBox(height: 30),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    obscuringCharacter: '*',
                    decoration: InputDecoration(
                      labelText: 'Senha',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)
                      )
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 80,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder:(context) => Home(user: userController.text)));
                      }, 
                      child: const Text('Entrar', style: TextStyle(fontSize: 20),)),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: (){
      
                      Navigator.push(context, MaterialPageRoute(builder: ((context) => Register(user: userController.toString()))));
                    },
                    child: const Text('Não tem uma conta? Cadastre-se', style: TextStyle(
                      fontSize: 16,
                      decoration: TextDecoration.underline
                  )))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}