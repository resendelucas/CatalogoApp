import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  const Register({required this.user, super.key});

  final String user;

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final nameController = TextEditingController();
  final userController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose(){
    nameController.dispose();
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
              child: Text('Cadastre-se', style: TextStyle(
                fontSize: 36, 
                color: Colors.blue[400]
                ))
              ),
            Container(
              padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.12, left: 40, right: 40),
              child: Column(
                children: [
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Nome',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)
                      )
                    ),
                  ),
                  const SizedBox(height: 30),
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
                      onPressed: (){}, 
                      child: const Text('Cadastrar', style: TextStyle(fontSize: 20),)),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: (){},
                    child: const Text('Já tem uma conta? Faça login', style: TextStyle(
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