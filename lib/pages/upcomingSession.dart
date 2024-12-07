import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:untitled/pages/countDownScreen.dart';
import '../providers/countDownDetailsProvider.dart';
import '../providers/sessionDetailsProvider.dart';
import '../weather_service.dart';
import '../providers/userDataProvider.dart';

class UpcomingSession extends StatefulWidget {
  const UpcomingSession({super.key});

  @override
  State<UpcomingSession> createState() => _UpcomingSessionState();
}

class _UpcomingSessionState extends State<UpcomingSession> {
  double uvIndex=0.0;
  int sessionDuration=0;
  int timeTillSunset=0;
  bool indexFetched=false;
  bool hasConnection = true;

  @override
  void initState() {
    super.initState();
    fetchUVIndex();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;
    final userData = Provider.of<UserDataNotifier>(context, listen: false);
    final sessionDetails = Provider.of<sessionDetailsNotifier>(context, listen: false);

    return WillPopScope(
      onWillPop: ()async{
        bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();
        if (isLocationServiceEnabled) {
          if(sessionDetails.sessionUpdated){
            sessionDetails.sessionUpdated=false;
            Navigator.pop(context);
          }else{
            Navigator.popUntil(context, ModalRoute.withName('/ClothingType'));
          }
        }else{
          Navigator.pop(context);
        }
        return false;
      },
      child: Scaffold(
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(onPressed: () async {
                      bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();
                      if (isLocationServiceEnabled) {
                        if(sessionDetails.sessionUpdated){
                          sessionDetails.sessionUpdated=false;
                          Navigator.pop(context);
                        }else{
                          Navigator.popUntil(context, ModalRoute.withName('/ClothingType'));
                        }
                      }else{
                        Navigator.pop(context);
                      }
                    },
                        icon: Icon(Platform.isIOS?Icons.arrow_back_ios:Icons.arrow_back,size: (isTablet(context))?screenWidth* 0.05:screenWidth* 0.065,color: Colors.black87,)),
                    Center(
                      child: (indexFetched)?
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: screenWidth*0.06),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: isTablet(context)?screenHeight*0.13:screenHeight*0.07,),
                            Center(
                              child: Column(
                                children: [
                                  Text(
                                    "Upcoming Session Details",
                                    style: TextStyle(
                                      fontFamily: 'BrunoAceSC',
                                        color: Colors.black,
                                        fontSize: (isTablet(context))?screenWidth*0.039:screenWidth*0.048,
                                        //fontWeight: FontWeight.bold,
                                      ),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: screenHeight*0.03,),
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
                                        fontSize: (isTablet(context))?screenWidth*0.038:screenWidth*0.045,
                                        //fontWeight: FontWeight.bold,

                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: (isTablet(context))?screenHeight*0.04:screenHeight*0.05,),
                            Center(
                              child: Text(
                                "Recommended session duration",
                                style: TextStyle(
                                  fontFamily: 'BrunoAceSC',
                                    color: Colors.black,
                                    fontSize: (isTablet(context))?screenWidth*0.036:screenWidth*0.039,
                                    //fontWeight: FontWeight.bold,

                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(height: screenHeight*0.02,),
                            Center(
                              child: Text(
                                "${(sessionDetails.sessionDurationMinutes ~/ 60<10)?"0${sessionDetails.sessionDurationMinutes ~/ 60}":"${sessionDetails.sessionDurationMinutes ~/ 60}"} : ${(sessionDetails.sessionDurationMinutes % 60<10)?"0${sessionDetails.sessionDurationMinutes % 60}":"${sessionDetails.sessionDurationMinutes % 60}"}",
                                style: TextStyle(
                                  fontFamily: 'BrunoAceSC',
                                    color: Colors.cyan,
                                    fontSize: (isTablet(context))?screenWidth*0.042:screenWidth*0.06,
                                    //fontWeight: FontWeight.bold,

                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(height: screenHeight*0.05,),
                            Text(
                              "Time till sunset",
                              style: TextStyle(
                                fontFamily: 'BrunoAceSC',
                                  color: Colors.black,
                                  fontSize: (isTablet(context))?screenWidth*0.036:screenWidth*0.039,
                                  //fontWeight: FontWeight.bold,

                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: screenHeight*0.02,),
                            Center(
                              child: Text(
                                  "${(sessionDetails.timeTillSunsetMinutes ~/ 60<10)?"0${sessionDetails.timeTillSunsetMinutes ~/ 60}":"${sessionDetails.timeTillSunsetMinutes ~/ 60}"} : ${(sessionDetails.timeTillSunsetMinutes % 60<10)?"0${sessionDetails.timeTillSunsetMinutes % 60}":"${sessionDetails.timeTillSunsetMinutes % 60}"}",
                                style: TextStyle(
                                  fontFamily: 'BrunoAceSC',
                                    color: Colors.orangeAccent,
                                    fontSize: (isTablet(context))?screenWidth*0.042:screenWidth*0.06,
                                    //fontWeight: FontWeight.bold,
                                  ),

                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(height: screenHeight*0.05,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      "Vitamin D intake",
                                      style: TextStyle(
                                        fontFamily: 'BrunoAceSC',
                                          color: Colors.black,
                                          fontSize: (isTablet(context))?screenWidth*0.036:screenWidth*0.039,
                                          //fontWeight: FontWeight.bold,

                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "${sessionDetails.vitaminDIntake}",
                                          style: TextStyle(
                                            fontFamily: 'BrunoAceSC',
                                              color: Colors.cyan,
                                              fontSize: (isTablet(context))?screenWidth*0.042:screenWidth*0.06,
                                              //fontWeight: FontWeight.bold,
                                            ),
                                          textAlign: TextAlign.center,
                                        ),
                                        Text(
                                          " IU",
                                          style: TextStyle(
                                            fontFamily: 'Raleway',
                                            color: Colors.cyan,
                                              fontSize: (isTablet(context))?screenWidth*0.042:screenWidth*0.045,
                                              //fontWeight: FontWeight.bold,
                                            ),

                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),

                                  ],
                                ),
                                Column(
                                  children: [
                                    Text(
                                      "UV Index",
                                      style:  TextStyle(
                                        fontFamily: 'BrunoAceSC',
                                          color: Colors.black,
                                          fontSize: (isTablet(context))?screenWidth*0.036:screenWidth*0.039,
                                          //fontWeight: FontWeight.bold,
                                        ),

                                      textAlign: TextAlign.center,
                                    ),
                                    Text(
                                      "$uvIndex",
                                      style: TextStyle(
                                        fontFamily: 'BrunoAceSC',
                                          color: Colors.cyan,
                                          fontSize: (isTablet(context))?screenWidth*0.042:screenWidth*0.06,
                                          //fontWeight: FontWeight.bold,

                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                )
                              ],
                            ),
                            SizedBox(height: isTablet(context)?screenHeight*0.05:screenHeight*0.07,),
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
                                  onPressed: () async{
                                    await checkConnection();
                                    if(hasConnection){
                                      final countDownDetails = Provider.of<countDownDetailsNotifier>(context, listen: false);
                                      countDownDetails.resetData();
                                      Navigator.pushNamed(context, '/countDownScreen');
                                    }
                                  },
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.white, padding: EdgeInsets.symmetric(horizontal: (isTablet(context))?screenWidth*0.09:screenWidth*0.15, vertical: (isTablet(context))?screenHeight*0.014:screenHeight*0.01), // Text color
                                    textStyle: TextStyle(fontSize: (isTablet(context))?screenWidth*0.04:screenWidth*0.043, fontWeight: FontWeight.bold),
                                  ),
                                  child: Text('Start Session'),
                                ),
                              ),
                            )
                          ],
                        ),
                      ):SizedBox(),
                    ),
                  ],
                ),
              ),
              (!indexFetched)?Center(
                  child: SizedBox(
                      height:isTablet(context)?60:40,
                      width: isTablet(context)?60:40,
                      child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.orangeAccent),strokeWidth: isTablet(context)?3.5:3,))
              ):SizedBox(),
              !hasConnection?
              Container(
                height: double.infinity,
                width: double.infinity,
                color: Colors.white38,

              ):Container(),
              !hasConnection
                  ? Padding(
                padding: EdgeInsets.only(left: isTablet(context)?screenWidth*0.05:0,right: isTablet(context)?screenWidth*0.05:0),
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
          ),
      ),
    );
  }

  Future<void> fetchUVIndex() async {
    final sessionDetails = Provider.of<sessionDetailsNotifier>(context, listen: false);

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    print("Latitude: ${position.latitude}, Longitude: ${position.longitude}");

    final result = await WeatherService.fetchUVIndex(position.latitude, position.longitude,sessionDetails);
    uvIndex=result!;

    sessionDetails.addUvIndex(uvIndex);
    print("----------About to check----------");
    if(uvIndex<=0){
      sessionDetails.sessionSuspended();
      print("----------checking now----------");
      print("----------UV Index: ${uvIndex}----------");
      //Navigator.popUntil(context, ModalRoute.withName('/Spf'));
      Navigator.popUntil(context, ModalRoute.withName('/Spf'));
      Navigator.pop(context);
    }else{
      calculateSessionDetails();
      setState(() {
        uvIndex = result;
        indexFetched=true;
      });
    }
  }

  void calculateSessionDetails(){

    print("------Inside calculation method--------");
    final sessionDetails = Provider.of<sessionDetailsNotifier>(context, listen: false);
    final userData = Provider.of<UserDataNotifier>(context, listen: false);
    double ageFactor;
    if(userData.user['age']<=15)
      ageFactor=0.5;
    else
      ageFactor=1.0;

    List<double> typeValues = [12.98, 10.2, 7.4, 5.35, 3.75, 2.45];
    double typeFactor=typeValues[userData.user['skinType']-1];

    List<double> coverValues=[1.0,0.82,0.45,0.16,0.12,0.1];
    double coverFactor=coverValues[sessionDetails.clothingTypeNumber-1];

    List<double> exposureValues=[0.10,0.30,0.50,0.70,0.80];
    double exposure = exposureValues[sessionDetails.clothingTypeNumber-1];

    double sessionTimeInMin=(sessionDetails.vitaminDIntake*coverFactor)/(uvIndex*typeFactor*ageFactor);
    if(sessionDetails.spf!=0){
      sessionTimeInMin=sessionTimeInMin*sessionDetails.spf;
    }

    if(sessionTimeInMin.round()<=sessionDetails.timeTillSunsetMinutes){
      sessionDetails.addSessionDuration(sessionTimeInMin.round());
    }else{
      sessionDetails.addSessionDuration(sessionDetails.timeTillSunsetMinutes);
      sessionDetails.addSessionDuration(sessionDetails.timeTillSunsetMinutes);
      double vitaminDPerMinute = sessionDetails.vitaminDIntake / sessionTimeInMin;
      double adjustedVitaminD = vitaminDPerMinute * sessionDetails.timeTillSunsetMinutes;
      sessionDetails.addVitaminDIntake(adjustedVitaminD.round());
    }

    print("Session vitamin D calculated: ${sessionDetails.vitaminDIntake}");
    print("Session time calculated: ${sessionTimeInMin}");



  }

  bool isTablet(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return screenWidth >= 600 && screenWidth <= 1024;
  }

  Future<void> checkConnection() async {
    var result = await InternetConnectionChecker().hasConnection;
    if (mounted) {
      print("-----connection : $result ------");
      setState(() {
        hasConnection = result;
      });
    }
  }

}
