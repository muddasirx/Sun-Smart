import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:geolocator/geolocator.dart';
import 'package:neon_circular_timer/neon_circular_timer.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:untitled/pages/graphScreen.dart';
import 'package:untitled/pages/spf.dart';

import '../providers/countDownDetailsProvider.dart';
import '../providers/sessionDetailsProvider.dart';
import '../providers/userDataProvider.dart';

class SessionFinished extends StatefulWidget {
  const SessionFinished({super.key});

  @override
  State<SessionFinished> createState() => _SessionFinishedState();
}

class _SessionFinishedState extends State<SessionFinished> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;
    final userData = Provider.of<UserDataNotifier>(context, listen: false);
    final sessionDetails = Provider.of<sessionDetailsNotifier>(context, listen: false);
    final countDownDetails = Provider.of<countDownDetailsNotifier>(context, listen: false);

    return Scaffold(
      body: Stack(
        children: [
          Column(
                children: [
                  Image.asset('assets/images/backgrounds/bg6.jpg',width: screenWidth*1.7,),
                  Expanded(
                    child: Container(
                      color: Colors.white,
                    ),
                  )
                ],
              ),
          SafeArea(
              child:Center(
                child: Column(
                  children: [
                    SizedBox(height: isTablet(context)?screenHeight*0.17:screenHeight*0.12,),
                    Text(
                      "Session Results",
                      style: TextStyle(
                        fontFamily: 'BrunoAceSC',
                          color: Colors.black,
                          fontSize: (isTablet(context))?screenWidth*0.048:screenWidth*0.05,
                          //fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height:0.05* screenHeight,),
                    CircleAvatar(
                      radius: screenHeight*0.06,
                      backgroundImage: (userData.user['gender']=='Female')?AssetImage('assets/images/avatars/female.jpg'):AssetImage('assets/images/avatars/male.jpeg'),
                    ),
                    SizedBox(height: screenHeight*0.01,),
                    Text(
                      "${userData.user['name']}",
                      style: TextStyle(
                        fontFamily: 'Raleway',
                          color: Colors.black,
                          fontSize: (isTablet(context))?screenWidth*0.042:screenWidth*0.045,
                          //fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: screenHeight*0.06,),
                    Text(
                      "Vitamin units consumed",
                      style: TextStyle(
                        fontFamily: 'Raleway',
                          color: Colors.black,
                          fontSize: (isTablet(context))?screenWidth*0.042:screenWidth*0.05,
                          //fontWeight: FontWeight.bold,

                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: screenHeight*0.01,),
                    Text(
                      "${countDownDetails.iuConsumed}",
                      style: TextStyle(
                        fontFamily: 'BrunoAceSC',
                          color: Colors.orangeAccent,
                          fontSize: (isTablet(context))?screenWidth*0.08:screenWidth*0.09,
                          //fontWeight: FontWeight.bold,
                        ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: screenHeight*0.04,),
                    Text(
                      "Time spent in sun",
                      style: TextStyle(
                        fontFamily: 'Raleway',
                          color: Colors.black,
                          fontSize: (isTablet(context))?screenWidth*0.042:screenWidth*0.05,
                          //fontWeight: FontWeight.bold,

                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: screenHeight*0.01,),
                    Text(
                      "${formatSecondsToTime(countDownDetails.timeSpentInSeconds)}",
                      style: TextStyle(
                        fontFamily: 'BrunoAceSC',
                          color: Colors.cyan,
                          fontSize: (isTablet(context))?screenWidth*0.08:screenWidth*0.09,
                          //fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: isTablet(context)?screenHeight*0.06:screenHeight*0.08,),
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFFFCC54E), Color(0xFFFDA34F)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(50.0), // Rounded corners
                        ),
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => GraphScreen()),
                            );
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white, padding: EdgeInsets.symmetric(horizontal: (isTablet(context))?screenWidth*0.12:screenWidth*0.15, vertical: (isTablet(context))?screenHeight*0.018:screenHeight*0.01), // Text color
                            textStyle: TextStyle(fontSize: (isTablet(context))?screenWidth*0.042:screenWidth*0.045, fontWeight: FontWeight.bold),
                          ),
                          child: Text('Done'),
                        ),
                      ),
                    )
                  ],
                ),
              )
          )
        ],
      ),

    );
  }
  bool isTablet(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return screenWidth >= 600 && screenWidth <= 1024;
  }

  String formatSecondsToTime(int totalSeconds) {
    if (totalSeconds >= 3600) {
      // Calculate hours, minutes, and seconds
      final hours = (totalSeconds ~/ 3600).toString().padLeft(2, '0');
      final minutes = ((totalSeconds % 3600) ~/ 60).toString().padLeft(2, '0');
      final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
      return "$hours:$minutes:$seconds";
    } else {
      // Calculate only minutes and seconds
      final minutes = (totalSeconds ~/ 60).toString().padLeft(2, '0');
      final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
      return "$minutes:$seconds";
    }
  }



}
