import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';

class LocationAccess extends StatefulWidget {
  const LocationAccess({super.key});

  @override
  State<LocationAccess> createState() => _LocationAccessState();
}

class _LocationAccessState extends State<LocationAccess> {
  bool fetchLocation=false;
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
          style: GoogleFonts.brunoAceSc(
            textStyle: TextStyle(
              color: Colors.black,
              fontSize: (isTablet(context))?screenWidth* 0.039:screenWidth* 0.051,//(isTablet(context))?27:20,
              //fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body:Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth*0.08),
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(height: screenHeight*0.04,),
              Text(
                "You are all set now, let's reach your goals together with us",
                style: GoogleFonts.raleway(
                  textStyle: TextStyle(
                    color: Colors.black87,
                    fontSize: (isTablet(context))?screenWidth*0.035:screenWidth*0.044,
                    //fontWeight: FontWeight.bold,
                  ),
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
                    await _getLocation();
                    if(fetchLocation)
                    Navigator.pushNamed(context, "/UpcomingSession");

                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white, padding: EdgeInsets.symmetric(horizontal: (isTablet(context))?screenWidth*0.14:screenWidth*0.18, vertical: (isTablet(context))?screenHeight*0.016:screenHeight*0.02), // Text color
                    textStyle: TextStyle(fontSize: (isTablet(context))?screenWidth*0.04:screenWidth*0.05, fontWeight: FontWeight.bold),
                  ),
                  child: Text('Enable Location'),
                ),
              ),

              /*Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(50.0), // Rounded corners
                ),
                child: TextButton(

                  onPressed: () {
                    //Navigator.pushNamed(context, "/SourcesOfVitaminD");
                  },
                  style: TextButton.styleFrom(
                    splashFactory: NoSplash.splashFactory,
                    foregroundColor: Colors.black87, padding: EdgeInsets.symmetric(horizontal: (isTablet(context))?screenWidth*0.14:screenWidth*0.15, vertical: (isTablet(context))?screenHeight*0.014:screenHeight*0.02), // Text color
                    textStyle: TextStyle(fontSize: (isTablet(context))?screenWidth*0.04:screenWidth*0.05, fontWeight: FontWeight.bold
                    ),
                  ),
                  child: Text('Not Now'),
                ),
              ),*/


            ],
          ),
        ),
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
}
