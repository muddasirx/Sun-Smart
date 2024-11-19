import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:neon_circular_timer/neon_circular_timer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:untitled/pages/sessionFinished.dart';

import '../providers/countDownDetailsProvider.dart';
import '../providers/sessionDetailsProvider.dart';
import '../providers/userDataProvider.dart';
import 'clothingType.dart';

class countDownScreen extends StatefulWidget {
  const countDownScreen({super.key});

  @override
  State<countDownScreen> createState() => _countDownScreenState();
}

class _countDownScreenState extends State<countDownScreen> with SingleTickerProviderStateMixin{
  bool cancelPressed=true;
  late AnimationController _controller;
  final CountDownController controller = new CountDownController();
  bool quitPressed=false;
  bool updatePressed=false;
  bool hasConnection=true;


  @override
  void initState() {
    super.initState();
    final sessionDetails = Provider.of<sessionDetailsNotifier>(context, listen: false);
    final countdownDetails = Provider.of<countDownDetailsNotifier>(context, listen: false);
    countdownDetails.incrementMilliSeconds=((sessionDetails.sessionDurationMinutes*60*1000)/sessionDetails.vitaminDIntake).toInt()-5;
    print("--------------Increment milliSeconds: ${countdownDetails.incrementMilliSeconds}-----------------");
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 5),
    )..repeat();
    countdownDetails.startIncrementTimer(sessionDetails);
  }

  @override
  void dispose() {
    final countdownDetails = Provider.of<countDownDetailsNotifier>(context, listen: false);
    _controller.dispose();
    countdownDetails.incrementTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;
    final userData = Provider.of<UserDataNotifier>(context, listen: false);
    final sessionDetails = Provider.of<sessionDetailsNotifier>(context, listen: false);
    final countDownDetails = Provider.of<countDownDetailsNotifier>(context, listen: false);

    return WillPopScope(
      onWillPop: () async{
        setState(() {
          quitPressed=true;
          countDownDetails.isPaused=true;
          controller.pause();
        });
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text(
            "Session in Progress",
            style: TextStyle(
              fontFamily: 'BrunoAceSC',
                color: Colors.black,
                fontSize: (isTablet(context))?screenWidth* 0.038:screenWidth* 0.051,//(isTablet(context))?27:20,
                //fontWeight: FontWeight.bold,
              ),
          ),
          leading: IconButton(
            icon: Icon(Icons.close,size: (isTablet(context))?screenWidth* 0.05:screenWidth* 0.063,),
            onPressed: () {
              setState(() {
                quitPressed=true;
                countDownDetails.isPaused=true;
                controller.pause();
              });
            },
          ),
        ),
        body: Stack(
          children: [
            Padding(
              padding:  EdgeInsets.symmetric(horizontal: screenWidth*0.1),
              child: Center(
                child: Column(
                  children: [
                    SizedBox(height:0.03* screenHeight,),
                    CircleAvatar(
                      radius: screenHeight*0.055,
                      backgroundImage: (userData.user['gender']=='Female')?AssetImage('assets/images/avatars/female.jpg'):AssetImage('assets/images/avatars/male.jpeg'),
                    ),
                    SizedBox(height: screenHeight*0.01,),
                    Text(
                      "${userData.user['name']}",
                      style: TextStyle(
                        fontFamily: 'Raleway',
                          color: Colors.black,
                          fontSize: (isTablet(context))?screenWidth*0.04:screenWidth*0.043,
                          //fontWeight: FontWeight.bold,
                        ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: screenHeight*0.035,),

                    AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        return Stack(
                          alignment: Alignment.center,
                          children: [
                            Transform.rotate(
                              angle: _controller.value * 2 * pi, // Inverse rotation
                              child: Container(
                                width: isTablet(context)?screenWidth*0.39:screenWidth*0.49,
                                height: isTablet(context)?screenHeight*0.25:screenHeight*0.24,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [Color(0xff20bdff), Color(0xffa5fecb)],
                                    stops: [0.5, 1],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  )


                                  ,
                                  borderRadius: BorderRadius.circular(isTablet(context)?99:80),
                                ),
                              ),
                            ),
                            Transform.rotate(
                              angle: -_controller.value * 2 * pi, // Standard rotation
                              child: Container(
                                width: isTablet(context)?screenWidth*0.37:screenWidth*0.475,
                                height: isTablet(context)?screenHeight*0.23:screenHeight*0.225,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [Color(0xFFFCC54E), Color(0xFFFDA34F)],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(isTablet(context)?99:80),
                                ),
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Received today",
                                  style: TextStyle(
                                    fontFamily: 'Raleway',
                                      color: Colors.white,
                                      fontSize: (isTablet(context))?screenWidth*0.038:screenWidth*0.044,
                                      //fontWeight: FontWeight.bold,
                                    ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 5),
                                Consumer<countDownDetailsNotifier>(builder: (context,value,child){
                                return Text(
                                        "${countDownDetails.iuConsumed}",
                                        style: TextStyle(
                                          fontFamily: 'BrunoAceSC',
                                            color: Colors.white,
                                            fontSize: (isTablet(context))?screenWidth*0.065:screenWidth*0.075,
                                            //fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      );
                                }),
                                SizedBox(height: 5),
                                Text(
                                  "from daily IU",
                                  style: TextStyle(
                                    fontFamily: 'Raleway',
                                      color: Colors.white,
                                      fontSize: (isTablet(context))?screenWidth*0.038:screenWidth*0.044,
                                      //fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),

                    SizedBox(height: screenHeight*0.03,),
                    Text(
                      "UV Index: ${sessionDetails.uvIndex}",
                      style: TextStyle(
                        fontFamily: 'Raleway',
                          color: Colors.black,
                          fontSize: (isTablet(context))?screenWidth*0.037:screenWidth*0.040,
                          //fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: screenHeight*0.03,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                    Consumer<countDownDetailsNotifier>(builder: (context,value,child){
                    return Column(
                          children: [
                            IconButton(
                              onPressed: (){
                                if(countDownDetails.isPaused){
                                  controller.resume();
                                  countDownDetails.startIncrementTimer(sessionDetails);
                                  setState(() {
                                    countDownDetails.isPaused=false;
                                  });
                                }else{
                                  controller.pause();
                                  countDownDetails.incrementTimer?.cancel();
                                  setState(() {
                                    countDownDetails.isPaused=true;
                                  });
                                }
                              },
                                icon: Icon(countDownDetails.isPaused?Icons.play_arrow:Icons.pause,size: (isTablet(context))?screenWidth* 0.056:screenWidth* 0.069,)),
                            Text(
                              countDownDetails.isPaused?"Resume":"Pause",
                              style: TextStyle(
                                fontFamily: 'Raleway',
                                  color: Colors.black,
                                  fontSize: (isTablet(context))?screenWidth*0.037:screenWidth*0.040,
                                  //fontWeight: FontWeight.bold,
                                ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        );}),
                        NeonCircularTimer(
                          width: isTablet(context)?screenWidth*0.28:screenWidth*0.36,
                          textFormat: (sessionDetails.sessionDurationMinutes>60)?TextFormat.HH_MM_SS:TextFormat.MM_SS,
                          onComplete: (){
                            uploadDataToDB();
                            countDownDetails.timeSpentInSeconds = (sessionDetails.sessionDurationMinutes * 60) - controller.getTimeInSeconds();
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => SessionFinished()),
                                  (Route<dynamic> route) => false,
                            );
                          },
                          duration:sessionDetails.sessionDurationMinutes*60,
                          textStyle: TextStyle(
                            fontFamily: 'BrunoAceSC',
                              color: Colors.black,
                              fontSize: (isTablet(context))?((sessionDetails.sessionDurationMinutes>60)?screenWidth*0.04:screenWidth*0.05):(sessionDetails.sessionDurationMinutes>60)?screenWidth*0.05:screenWidth*0.06,

                          ),
                          controller : controller,
                          isTimerTextShown: true,
                          isReverse: true,
                          isReverseAnimation: true,
                          innerFillGradient: LinearGradient(colors: [
                            Colors.greenAccent.shade200,
                            Colors.blueAccent.shade400
                          ]),
                          neonGradient: LinearGradient(colors: [
                            Colors.greenAccent.shade200,
                            Colors.blueAccent.shade400
                          ]),
                        ),
                        Column(
                          children: [
                            IconButton(onPressed: (){
                                  setState(() {
                                    updatePressed=true;
                                    countDownDetails.isPaused=true;
                                    controller.pause();
                                  });
                            },
                                icon: Icon(Icons.edit_note,size: (isTablet(context))?screenWidth* 0.056:screenWidth* 0.069,)),
                            Text(
                              "Update",
                              style: TextStyle(
                                fontFamily: 'Raleway',
                                  color: Colors.black,
                                  fontSize: (isTablet(context))?screenWidth*0.037:screenWidth*0.040,
                                  //fontWeight: FontWeight.bold,
                                ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: isTablet(context)?screenHeight*0.045:screenHeight*0.05,),
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
                            //print(controller.getTime());
                            //print(int.parse(controller.getTime()));
                            setState(() {
                              quitPressed=true;
                              countDownDetails.isPaused=true;
                              controller.pause();
                            });
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white, padding: EdgeInsets.symmetric(horizontal: (isTablet(context))?screenWidth*0.12:screenWidth*0.15, vertical: (isTablet(context))?screenHeight*0.018:screenHeight*0.01), // Text color
                            textStyle: TextStyle(fontSize: (isTablet(context))?screenWidth*0.042:screenWidth*0.043, fontWeight: FontWeight.bold),
                          ),
                          child: Text('Finish'),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            (quitPressed||updatePressed)?Container(
              height: double.infinity,
              width: double.infinity,
              color: Colors.white24,
            ):Container(),
            quitPressed?Padding(
              padding:  EdgeInsets.only(bottom: screenHeight*0.1),
              child: Center(
                        child:AlertDialog(
                          title: Text(
                            "End session",
                            style: TextStyle(
                              fontFamily: 'BrunoAceSC',
                                color: Colors.black,
                                fontSize: (isTablet(context))?screenWidth*0.042:screenWidth*0.05,
                                //fontWeight: FontWeight.bold,
                              ),
                          ),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                  "Are you sure you want to end session?"
                                ,style: TextStyle(
                                fontFamily: 'Raleway',
                                  color: Colors.black,
                                  fontSize: (isTablet(context))?screenWidth*0.035:screenWidth*0.037,
                                  //fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          backgroundColor: Color(0xFFD6D6D6),
                          actions: [
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  quitPressed=false;
                                  countDownDetails.isPaused=false;
                                  controller.resume();
                                });
                                countDownDetails.startIncrementTimer(sessionDetails);
                              } ,
                              child: Text(
                                "No",
                                style: TextStyle(
                                  fontFamily: 'BrunoAceSC',
                                    color: Colors.black,
                                    fontSize: (isTablet(context))?screenWidth*0.035:screenWidth*0.04,
                                    //fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            TextButton(
                              onPressed: () async{
                                await checkConnection();
                                if(hasConnection){
                                  uploadDataToDB();
                                  countDownDetails.timeSpentInSeconds = (sessionDetails.sessionDurationMinutes * 60) - controller.getTimeInSeconds();
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(builder: (context) => SessionFinished()),
                                        (Route<dynamic> route) => false,
                                  );
                                }
                              } ,
                              child: Text(
                                "Yes",
                                style: TextStyle(
                                  fontFamily: 'BrunoAceSC',
                                    color: Colors.black,
                                    fontSize: (isTablet(context))?screenWidth*0.035:screenWidth*0.04,
                                    //fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],),

              ),
            ):Container(),
            updatePressed?Padding(
              padding:  EdgeInsets.only(bottom: screenHeight*0.1,left:isTablet(context)?screenWidth*0.1:0,right:isTablet(context)?screenWidth*0.1:0),
              child: Center(
                child:AlertDialog(
                  title: Text(
                    "Update session",
                    style: TextStyle(
                      fontFamily: 'BrunoAceSC',
                        color: Colors.black,
                        fontSize: (isTablet(context))?screenWidth*0.042:screenWidth*0.05,
                        //fontWeight: FontWeight.bold,
                      ),
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "The current session will be ended and an updated session will be restarted, Are you sure you want to update session?"
                        ,style: TextStyle(
                        fontFamily: 'Raleway',
                          color: Colors.black,
                          fontSize: (isTablet(context))?screenWidth*0.035:screenWidth*0.037,
                          //fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  backgroundColor: Color(0xFFD6D6D6),
                  actions: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          countDownDetails.isPaused=false;
                          updatePressed=false;
                          controller.resume();
                        });
                        countDownDetails.startIncrementTimer(sessionDetails);
                      } ,
                      child: Text(
                        "No",
                        style: TextStyle(
                          fontFamily: 'BrunoAceSC',
                            color: Colors.black,
                            fontSize: (isTablet(context))?screenWidth*0.035:screenWidth*0.04,
                            //fontWeight: FontWeight.bold,
                          ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                       await checkConnection();
                       if(hasConnection){
                         uploadDataToDB();
                         countDownDetails.timeSpentInSeconds = (sessionDetails.sessionDurationMinutes * 60) - controller.getTimeInSeconds();
                         sessionDetails.sessionUpdated=true;
                         Navigator.pushReplacement(
                           context,
                           PageRouteBuilder(
                               pageBuilder: (context, animation1, animation2) => ClothingType()),//UserPrescription(), //
                         );
                       }
                      } ,
                      child: Text(
                        "Yes",
                        style: TextStyle(
                          fontFamily: 'BrunoAceSC',
                            color: Colors.black,
                            fontSize: (isTablet(context))?screenWidth*0.035:screenWidth*0.04,
                            //fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],),

              ),
            ):Container(),
            !hasConnection
                ? Padding(
              padding: EdgeInsets.only(left: isTablet(context)?screenWidth*0.05:0,right: isTablet(context)?screenWidth*0.05:0,bottom: screenHeight*0.1),
              child: Center(
                  child: AlertDialog(
                    title: Text(
                      "No Internet Available",
                      style: TextStyle(
                        fontFamily: 'BrunoAceSC',
                        color: Colors.black,
                        fontSize: (isTablet(context))?screenWidth*0.042:screenWidth*0.048,
                        //fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset('assets/images/noConnection.png',height: screenHeight*0.2,),
                        Text(
                          'You need an internet connection to proceed. Please check your connection and try again.',
                          style: TextStyle(
                            fontFamily: 'Raleway',
                            color: Colors.black,
                            fontSize: (isTablet(context))?screenWidth*0.03:screenWidth*0.04,
                            //fontWeight: FontWeight.bold,

                          ),
                          textAlign: TextAlign.center,),
                      ],
                    ),
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    actions: [
                      TextButton(
                        onPressed: () => SystemNavigator.pop(),
                        child:  Text(
                          "Exit",
                          style: TextStyle(
                            fontFamily: 'BrunoAceSC',
                            color: Colors.black,
                            fontSize: (isTablet(context))?screenWidth*0.038:screenWidth*0.04,
                            //fontWeight: FontWeight.bold,
                          ),

                          textAlign: TextAlign.center,
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          await checkConnection();
                          // Navigator.pop() can be used here if desired
                        },
                        child:  Text(
                          "Retry",
                          style: TextStyle(
                            fontFamily: 'BrunoAceSC',
                            color: Colors.black,
                            fontSize: (isTablet(context))?screenWidth*0.038:screenWidth*0.04,
                            //fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],)
              ),
            )
                : Container(),
          ],
        )
      ),
    );
  }

  bool isTablet(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return screenWidth >= 600 && screenWidth <= 1024;
  }


  String formatTime(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  Future<void> uploadDataToDB() async {
    final sessionDetails = Provider.of<sessionDetailsNotifier>(context, listen: false);
    final userData = Provider.of<UserDataNotifier>(context, listen: false);
    final countDownDetails = Provider.of<countDownDetailsNotifier>(context, listen: false);

    userData.todayIuConsumed = userData.todayIuConsumed + countDownDetails.iuConsumed;
    sessionDetails.vitaminDIntake = 1000 - userData.todayIuConsumed;

    print("${sessionDetails.vitaminDIntake}");

    DateTime currentDateOnly = DateTime.now();
    DateTime currentDateWithoutTime = DateTime(currentDateOnly.year, currentDateOnly.month, currentDateOnly.day);

    if (userData.user['sessionID'] == 'none') {
      // Create new session
      DocumentReference docRef = await FirebaseFirestore.instance.collection("Sessions").add({
        'sessionData': [
          {
            'iuConsumed': countDownDetails.iuConsumed,
            'date': currentDateWithoutTime,
          }
        ],
      });

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('UserInfo')
          .where('uid', isEqualTo: userData.uid)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentReference userDoc = querySnapshot.docs.first.reference;

        await userDoc.update({
          'sessionID': docRef.id,
        });

        userData.fetchUserData(userData.uid);
      }
    } else {
      // Update existing session
      print(userData.userSessions.toString());

      DocumentReference docRef = FirebaseFirestore.instance.collection("Sessions").doc(userData.user['sessionID']);
      DocumentSnapshot docSnapshot = await docRef.get();

      bool dateExists = false;

      print("Checking if today's IU consumed date exists");

      for (int i = 0; i < userData.userSessions!.length; i++) {
        DateTime entryDate = userData.userSessions?[i]['date'];
        DateTime entryDateWithoutTime = DateTime(entryDate.year, entryDate.month, entryDate.day);

        // Compare the dates (ignoring time)
        if (entryDateWithoutTime.isAtSameMomentAs(currentDateWithoutTime)) {
          // If the date exists, update the IU Consumed
          print("Today's date : $currentDateWithoutTime , IU Consumed date: $entryDateWithoutTime");
          userData.userSessions?[i]['iuConsumed'] = userData.userSessions?[i]['iuConsumed'] + countDownDetails.iuConsumed;
          dateExists = true;
          break;
        }
      }

      if (dateExists) {
        await docRef.update({
          'sessionData': userData.userSessions,
        });
        print("IU Consumed updated successfully for the existing date.");
        userData.fetchUserSessions(userData.user['sessionID']);
      } else {
        await docRef.update({
          'sessionData': FieldValue.arrayUnion([
            {
              'iuConsumed': countDownDetails.iuConsumed,
              'date': currentDateWithoutTime,
            }
          ]),
        });
        userData.fetchUserSessions(userData.user['sessionID']);
      }
    }
  }

  Future<void> checkConnection() async {
    var result = await InternetConnectionChecker().hasConnection;
    if (mounted) {
      setState(() {
        hasConnection = result;
      });
    }
  }

}
