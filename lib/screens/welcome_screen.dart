import 'package:flashchat/screens/login_screen.dart';
import 'package:flashchat/screens/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:flashchat/Components/but.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';


class WelcomeScreen extends StatefulWidget {
  static String id= 'welcome';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin{

  late AnimationController controller;
  late Animation animation ;

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp().whenComplete(() {
      print("completed");
      setState(() {});
    });
    controller=AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    );
    animation = CurvedAnimation(parent: controller, curve: Curves.bounceInOut);
    controller.forward();
    controller.addListener((){  setState((){});});
  }

  @override
  void dispose(){
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: 60.0,
                  ),
                ),
                Text(
                  'Flash Chat',
                  style: TextStyle(
                    color: Colors.black.withOpacity(animation.value*0.75),
                    fontSize: 45.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            But(
              Colors.lightBlueAccent,
              'Log In',
                (){
                  Navigator.pushNamed(context, LoginScreen.id);
                },
              'logi'
            ),
            But(
              Colors.blueAccent,
              'Register',
                (){
                  Navigator.pushNamed(context, RegistrationScreen.id);
                },
              'regi'
            ),

          ],
        ),
      ),
    );
  }
}

