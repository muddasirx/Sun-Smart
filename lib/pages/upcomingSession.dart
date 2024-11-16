import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
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
  double uvIndex=3.4;
  int sessionDuration=0;
  int timeTillSunset=0;
  bool indexFetched=true;

  @override
  void initState() {
    final sessionDetails = Provider.of<sessionDetailsNotifier>(context, listen: false);
    super.initState();
    //fetchUVIndex();
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
                        icon: Icon(Icons.arrow_back,size: (isTablet(context))?screenWidth* 0.05:screenWidth* 0.065,color: Colors.black87,)),
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
                                    style: GoogleFonts.brunoAceSc(
                                      textStyle: TextStyle(
                                        color: Colors.black,
                                        fontSize: (isTablet(context))?screenWidth*0.039:screenWidth*0.048,
                                        //fontWeight: FontWeight.bold,
                                      ),
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
                                    style: GoogleFonts.raleway(
                                      textStyle: TextStyle(
                                        color: Colors.black,
                                        fontSize: (isTablet(context))?screenWidth*0.038:screenWidth*0.045,
                                        //fontWeight: FontWeight.bold,
                                      ),
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
                                style: GoogleFonts.brunoAceSc(
                                  textStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: (isTablet(context))?screenWidth*0.036:screenWidth*0.039,
                                    //fontWeight: FontWeight.bold,
                                  ),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(height: screenHeight*0.02,),
                            Center(
                              child: Text(
                                "${(sessionDetails.sessionDurationMinutes ~/ 60<10)?"0${sessionDetails.sessionDurationMinutes ~/ 60}":"${sessionDetails.sessionDurationMinutes ~/ 60}"} : ${(sessionDetails.sessionDurationMinutes % 60<10)?"0${sessionDetails.sessionDurationMinutes % 60}":"${sessionDetails.sessionDurationMinutes % 60}"}",
                                style: GoogleFonts.brunoAceSc(
                                  textStyle: TextStyle(
                                    color: Colors.cyan,
                                    fontSize: (isTablet(context))?screenWidth*0.042:screenWidth*0.06,
                                    //fontWeight: FontWeight.bold,
                                  ),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(height: screenHeight*0.05,),
                            Text(
                              "Time till sunset",
                              style: GoogleFonts.brunoAceSc(
                                textStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: (isTablet(context))?screenWidth*0.036:screenWidth*0.039,
                                  //fontWeight: FontWeight.bold,
                                ),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: screenHeight*0.02,),
                            Center(
                              child: Text(
                                  "${(sessionDetails.timeTillSunsetMinutes ~/ 60<10)?"0${sessionDetails.timeTillSunsetMinutes ~/ 60}":"${sessionDetails.timeTillSunsetMinutes ~/ 60}"} : ${(sessionDetails.timeTillSunsetMinutes % 60<10)?"0${sessionDetails.timeTillSunsetMinutes % 60}":"${sessionDetails.timeTillSunsetMinutes % 60}"}",
                                style: GoogleFonts.brunoAceSc(
                                  textStyle: TextStyle(
                                    color: Colors.orangeAccent,
                                    fontSize: (isTablet(context))?screenWidth*0.042:screenWidth*0.06,
                                    //fontWeight: FontWeight.bold,
                                  ),
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
                                      style: GoogleFonts.brunoAceSc(
                                        textStyle: TextStyle(
                                          color: Colors.black,
                                          fontSize: (isTablet(context))?screenWidth*0.036:screenWidth*0.039,
                                          //fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "${sessionDetails.vitaminDIntake}",
                                          style: GoogleFonts.brunoAceSc(
                                            textStyle: TextStyle(
                                              color: Colors.cyan,
                                              fontSize: (isTablet(context))?screenWidth*0.042:screenWidth*0.06,
                                              //fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        Text(
                                          " IU",
                                          style: GoogleFonts.raleway(
                                            textStyle: TextStyle(
                                              color: Colors.cyan,
                                              fontSize: (isTablet(context))?screenWidth*0.042:screenWidth*0.045,
                                              //fontWeight: FontWeight.bold,
                                            ),
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
                                      style: GoogleFonts.brunoAceSc(
                                        textStyle: TextStyle(
                                          color: Colors.black,
                                          fontSize: (isTablet(context))?screenWidth*0.036:screenWidth*0.039,
                                          //fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    Text(
                                      "$uvIndex",
                                      style: GoogleFonts.brunoAceSc(
                                        textStyle: TextStyle(
                                          color: Colors.cyan,
                                          fontSize: (isTablet(context))?screenWidth*0.042:screenWidth*0.06,
                                          //fontWeight: FontWeight.bold,
                                        ),
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
                                  onPressed: () {
                                    final countDownDetails = Provider.of<countDownDetailsNotifier>(context, listen: false);
                                    countDownDetails.resetData();
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(builder: (context) => countDownScreen()),
                                          (Route<dynamic> route) => false,
                                    );
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

    double sessionTimeInMin=sessionDetails.vitaminDIntake/(uvIndex*typeFactor*ageFactor*coverFactor);
    if(sessionDetails.spf!=0){
      sessionTimeInMin=sessionTimeInMin*sessionDetails.spf;
    }

    print("Session vitamin D calculated: ${sessionDetails.vitaminDIntake}");
    print("Session time calculated: ${sessionTimeInMin}");
    sessionDetails.addSessionDuration(sessionTimeInMin.round());



    //double sunsetTimeInMin=sessionTimeInMin * 1.3;
    //sessionDetails.addSunsetDuration(sunsetTimeInMin.round());

    /*Map<int, double> vitaminDIntake = {};

    print("------About to calculate iu--------");
    for (int i = 0; i < typeValues.length; i++) {
      double iu = uvIndex * sessionDetails.sessionDurationMinutes * typeValues[i];
      vitaminDIntake[i] = iu;
    }
    print("------IU calculated--------");
    sessionDetails.vitaminDIntake= vitaminDIntake[userData.user['skinType']-1]!.toInt();
    print("------${vitaminDIntake[userData.user['skinType']-1]!.round()}------");
    print(sessionDetails.vitaminDIntake);  */

  }

  bool isTablet(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return screenWidth >= 600 && screenWidth <= 1024;
  }


}
