import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class LocationAccess extends StatefulWidget {
  const LocationAccess({super.key});

  @override
  State<LocationAccess> createState() => _LocationAccessState();
}

class _LocationAccessState extends State<LocationAccess> {
  bool fetchLocation=false;
  bool hasConnection = true;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black87,
          size: (isTablet(context))?screenWidth* 0.046:screenWidth* 0.06,//(isTablet(context))?30:23
        ),
        centerTitle: true,
        title: Text(
          "Location Access",
          style: TextStyle(
            fontFamily: 'BrunoAceSC',
              color: Colors.black,
              fontSize: (isTablet(context))?screenWidth* 0.039:screenWidth* 0.051,//(isTablet(context))?27:20,
              //fontWeight: FontWeight.bold,
            ),
        ),
      ),
      body:Stack(
        children: [
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth*0.08),
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(height: screenHeight*0.04,),
                  Text(
                    "You are all set now, let's reach your goals together with us",
                    style: TextStyle(
                      fontFamily: 'Raleway',
                        color: Colors.black87,
                        fontSize: (isTablet(context))?screenWidth*0.035:screenWidth*0.044,
                        //fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: screenHeight*0.1,),
                  Image.asset('assets/images/orangeLocation.png',height: screenHeight*0.27,),
                  SizedBox(height: screenHeight*0.25,),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFFFCC54E), Color(0xFFFDA34F)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(50.0), // Rounded corners
                    ),
                    child: TextButton(
                      onPressed: () async {
                        await checkConnection();
                        if(hasConnection){
                          await _getLocation();
                          if(fetchLocation)
                            Navigator.pushNamed(context, "/UpcomingSession");
                        }

                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white, padding: EdgeInsets.symmetric(horizontal: (isTablet(context))?screenWidth*0.14:screenWidth*0.18, vertical: (isTablet(context))?screenHeight*0.016:screenHeight*0.02), // Text color
                        textStyle: TextStyle(fontSize: (isTablet(context))?screenWidth*0.04:screenWidth*0.05, fontWeight: FontWeight.bold),
                      ),
                      child: Text('Enable Location'),
                    ),
                  ),



                ],
              ),
            ),
          ),
          !hasConnection?
          Container(
            height: double.infinity,
            width: double.infinity,
            color: Colors.white24,

          ):Container(),
          !hasConnection
              ? Padding(
            padding: EdgeInsets.only(top: isTablet(context)?screenHeight*0.1:0,left: isTablet(context)?screenWidth*0.05:0,right: isTablet(context)?screenWidth*0.05:0,bottom: screenHeight*0.1),
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
    );
  }

  Future<void> _getLocation() async {
    // Check for permission
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          print("Location permissions are denied");
        });
        return;
      }
    }

    // If permissions are granted, fetch the location
    if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
        setState(() {
          fetchLocation=true;
        });
        print("Latitude: ${position.latitude}, Longitude: ${position.longitude}");

    }
  }

  bool isTablet(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return screenWidth >= 600 && screenWidth <= 1024;
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
