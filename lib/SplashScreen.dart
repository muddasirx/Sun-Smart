import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/pages/LoginScreen.dart';
import 'package:untitled/pages/countDownScreen.dart';
import 'package:untitled/pages/estimatedBloodLevel.dart';
import 'package:untitled/pages/estimatedVitaminDLevel.dart';
import 'package:untitled/pages/firstPage.dart';
import 'package:untitled/pages/graphScreen.dart';
import 'package:untitled/pages/sessionFinished.dart';
import 'package:untitled/pages/skinTypeSelection.dart';
import 'package:untitled/pages/spf.dart';
import 'package:untitled/pages/disclaimer.dart';
import 'package:untitled/providers/sessionDetailsProvider.dart';
import 'package:untitled/providers/userDataProvider.dart';

import 'graphTesting.dart';
import 'main.dart';


class SplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  static const String keyLogin= "login";
  static const String theme= "light" ;
  static late var isLight;

  @override
  void initState() {
    super.initState();
    _initializeFirebase();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;
    Orientation orientation = MediaQuery.orientationOf(context);

    return Scaffold(
      backgroundColor: Colors.white//Color(0xff062929)//Color(0xff052020)//Theme.of(context).colorScheme.background
      ,body: Center(
      child: FadeTransition(
        opacity: _animation,
        child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/d1.jpg',height: screenHeight*0.25,),
            //SizedBox(height: screenHeight*0.015,),

          ],
        ),



      ),
    ),
    );
  }

  Future<void> _initializeFirebase() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyDxJA_FtbJIUZtFvmW09DUkXA_r3BDA41I",
          appId: "1:672685347058:android:a1a224084ad409fd88406b",
          messagingSenderId: "672685347058",
          projectId: "app-x-ce80a",
          storageBucket: "app-x-ce80a.appspot.com"
      ),
    );

    checkUserStatus();
    final loginData = Provider.of<UserDataNotifier>(context, listen: false);
    print("------------------------ UserID: ${loginData.uid} ------------------------");
    _controller.forward().then((_) {
      Timer(Duration(seconds: 3), () async {
        var pref= await SharedPreferences.getInstance();
        var isLoggedIn= pref.getBool(keyLogin);

        if (isLoggedIn == null || isLoggedIn == false) {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) => firstPage(),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  var begin = Offset(1.0, 0.0);
                  var end = Offset.zero;
                  var tween = Tween(begin: begin, end: end);
                  var offsetAnimation = animation.drive(tween);

                  return SlideTransition(
                    position: offsetAnimation,
                    child: child,
                  );
                },
              ),
            );
        }
        else {
          if(loginData.user['skinType']!=0){
            Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation1, animation2) => GraphScreen(),//Spf(),//firstPage(),////UserPrescription(), //
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    var begin = Offset(1.0, 0.0);
                    var end = Offset.zero;
                    var tween = Tween(begin: begin, end: end);
                    var offsetAnimation = animation.drive(tween);

                    return SlideTransition(
                      position: offsetAnimation,
                      child: child,
                    );
                  },
                ),
              );
          }
          else if(loginData.user['skinType']==0){
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) => SkinType(),//UserPrescription(), //
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  var begin = Offset(1.0, 0.0);
                  var end = Offset.zero;
                  var tween = Tween(begin: begin, end: end);
                  var offsetAnimation = animation.drive(tween);

                  return SlideTransition(
                    position: offsetAnimation,
                    child: child,
                  );
                },
              ),
            );
          }

        }
      });
    });
  }

  Future<void> checkUserStatus() async{
    final loginData = Provider.of<UserDataNotifier>(context, listen: false);
    final sessionDetails = Provider.of<sessionDetailsNotifier>(context, listen: false);

    SharedPreferences prefLogin = await SharedPreferences.getInstance();
    loginData.email= await prefLogin.getString('email') ?? '';
    loginData.uid= await prefLogin.getString('uid') ?? '';
    loginData.appSettingsApplied= await prefLogin.getBool('appSettings') ?? false;
    print("fetching user session!");
    if(loginData.uid.isNotEmpty){
      await loginData.fetchUserData(loginData.uid);
      print("checking session attended!");
      if(loginData.user['sessionID']!='none') {
        print("Session Id: ${loginData.user['sessionID']}");
        await loginData.fetchUserSessions(loginData.user['sessionID']);
        print("Calculating iu consumed today.");
        loginData.iuConsumedToday(sessionDetails);
        print(loginData.userSessions.toString());
      } else
        print("The user hasn't taken any session yet.");
    }else
      print("------------New User--------------");
  }



}
