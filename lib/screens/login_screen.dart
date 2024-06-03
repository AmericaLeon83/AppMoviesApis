import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tap2024/screens/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  bool isValidating = false;

  @override
  Widget build(BuildContext context) {

    final txtUser = TextFormField(
      decoration: const InputDecoration(
        icon: Icon(Icons.person),
        hintText: 'Correo Electrónico',
        hintStyle: TextStyle(fontWeight: FontWeight.bold)
      ),
    );

    final txtPwd = TextFormField(
      obscureText: true,
      decoration: const InputDecoration(
        icon: Icon(Icons.key),
        hintText: 'Contraseña',
        hintStyle: TextStyle(fontWeight: FontWeight.bold)
      ),
    );

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(10),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
            opacity: .5,
            fit: BoxFit.fill,
            image: AssetImage('assets/gwf2.webp')
          )
        ),
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Positioned(
              top: 200,
              child: Image.asset('assets/cactus.webp',)
            ),
            Positioned(
              bottom: 150,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                height: 120,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 86, 195, 88).withOpacity(.8),
                  borderRadius: BorderRadius.circular(20)
                ),
                child: Column(
                  children: [
                    txtUser,
                    txtPwd
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 90,
              child: ElevatedButton.icon(
                onPressed: (){
                  isValidating = !isValidating;
                  setState(() {});
                  Future.delayed(const Duration(
                    milliseconds: 3000
                  )).then((value) => Navigator.push(
                        context, 
                        MaterialPageRoute(builder: (context) => const HomeScreen(),
                      )
                    ),
                  ) ;
                }, 
                label: const Text('Validar Usuario'),
                icon: const Icon(Icons.login),
              ) 
            ),
            Positioned(
              top: 330,
              child: SizedBox(
                height: 300,
                child: isValidating 
                  ? Image.asset('assets/loading.gif') 
                  : Container()
              )
            )
          ],
        ),
      )
    );
  }
}