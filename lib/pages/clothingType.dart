import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../providers/countDownDetailsProvider.dart';
import '../providers/sessionDetailsProvider.dart';
import '../providers/userDataProvider.dart';

class ClothingType extends StatefulWidget {
  const ClothingType({super.key});

  @override
  State<ClothingType> createState() => _ClothingTypeState();
}

class _ClothingTypeState extends State<ClothingType> {
  bool c1=false,c2=true,c3=false,c4=false,c5=false;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;
    final sessionDetails = Provider.of<sessionDetailsNotifier>(context, listen: false);
    final countDownDetails = Provider.of<countDownDetailsNotifier>(context, listen: false);
    final userData = Provider.of<UserDataNotifier>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black87,
          size: (isTablet(context))?screenWidth* 0.046:screenWidth* 0.06,//(isTablet(context))?30:23
        ),
        centerTitle: true,
        title: Text(
          "Clothing Type",
          style: GoogleFonts.brunoAceSc(
            textStyle: TextStyle(
              color: Colors.black,
              fontSize: (isTablet(context))?screenWidth* 0.039:screenWidth* 0.051,//(isTablet(context))?27:20,
              //fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),

      body: Center(
            child: Column(
                children: [
                  SizedBox(height: screenHeight*0.01,),
                  Image.asset('assets/images/clothing.png',height: screenHeight*0.2,),
                  SizedBox(height: screenHeight*0.03,),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: screenWidth*0.05),
                    child: Text(
                      "Could you please confirm the type of clothes you are currently wearing?",
                      style: GoogleFonts.raleway(
                        textStyle: TextStyle(
                          color: Colors.black87,
                          fontSize: (isTablet(context))?screenWidth*0.034:screenWidth*0.037,
                          //fontWeight: FontWeight.bold,
                        ),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: screenHeight*0.05,),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: screenWidth*0.05),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Wearing",
                          style: GoogleFonts.brunoAceSc(
                            textStyle: TextStyle(
                              color: Colors.black87,
                              fontSize: (isTablet(context))?screenWidth*0.034:screenWidth*0.04,
                              //fontWeight: FontWeight.bold,
                            ),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          "% Exposed",
                          style: GoogleFonts.brunoAceSc(
                            textStyle: TextStyle(
                              color: Colors.black87,
                              fontSize: (isTablet(context))?screenWidth*0.034:screenWidth*0.04,
                             // fontWeight: FontWeight.bold,
                            ),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: screenHeight*0.02,),
                  c1?selectedChoice("Long pants, sleeved shirt", 10):choice("Long pants, sleeved shirt", 10),
                  c2?selectedChoice("Short sleeves, pants", 30):choice("Short sleeves, pants", 30),
                  c3?selectedChoice("Short sleeves, shorts", 50):choice("Short sleeves, shorts", 50),
                  c4?selectedChoice("Shorts, no shirt", 70):choice("Shorts, no shirt", 70),
                  c5?selectedChoice("Swinwear", 80):choice("Swinwear", 80),
                  SizedBox(height: screenHeight*0.05,),
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
                        if(!sessionDetails.sessionUpdated){
                          sessionDetails.addClothingTypeNumber(checkClothingType());
                          print("Clothing type ${sessionDetails.clothingTypeNumber}");
                          if(!userData.locationProvided){
                            Navigator.pushNamed(context, "/LocationAccess");
                            userData.locationProvided=true;
                          }else
                            Navigator.pushNamed(context, "/UpcomingSession");
                        }else{
                          sessionDetails.addClothingTypeNumber(checkClothingType());
                          Navigator.pushNamed(context, "/UpcomingSession");
                        }

                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white, padding: EdgeInsets.symmetric(horizontal: (isTablet(context))?screenWidth*0.09:screenWidth*0.15, vertical: (isTablet(context))?screenHeight*0.014:screenHeight*0.01), // Text color
                        textStyle: TextStyle(fontSize: (isTablet(context))?screenWidth*0.04:screenWidth*0.043, fontWeight: FontWeight.bold),
                      ),
                      child: Text('Start Session'),
                    ),
                  )            ],
              ),

          ),

    );
  }

  Widget selectedChoice(String str,int exp){
    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth*0.03),
      child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFCC54E), Color(0xFFFDA34F)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(50), // Rounded corners
          ),
        child:Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth*0.03,vertical: screenHeight*0.02),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                str,
                style: GoogleFonts.raleway(
                  textStyle: TextStyle(
                    color: Colors.black87,
                    fontSize: (isTablet(context))?screenWidth*0.034:screenWidth*0.038,
                    //fontWeight: FontWeight.bold,
                  ),
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                "${exp}",
                style: GoogleFonts.raleway(
                  textStyle: TextStyle(
                    color: Colors.black87,
                    fontSize: (isTablet(context))?screenWidth*0.034:screenWidth*0.039,
                    //fontWeight: FontWeight.bold,
                  ),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        )
      ),
    );
  }

  Widget choice(String str,int exp){
    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth*0.03),
      child: InkWell(
        splashFactory: NoSplash.splashFactory,
        onTap: (){
          if(exp==10){
            setState(() {
              c1=true;
              c2=false;
              c3=false;
              c4=false;
              c5=false;
            });
          } else if(exp==30){
            setState(() {
              c2=true;
              c1=false;
              c3=false;
              c4=false;
              c5=false;
            });
          } else if(exp==50){
            setState(() {
              c3=true;
              c1=false;
              c2=false;
              c4=false;
              c5=false;
            });
          } else if(exp==70){
            setState(() {
              c4=true;
              c1=false;
              c3=false;
              c2=false;
              c5=false;
            });
          } else if(exp==80){
            setState(() {
              c5=true;
              c1=false;
              c3=false;
              c4=false;
              c2=false;
            });
          }
        },
        child: Container(
            child:Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth*0.03,vertical: screenHeight*0.02),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    str,
                    style: GoogleFonts.raleway(
                      textStyle: TextStyle(
                        color: Colors.black87,
                        fontSize: (isTablet(context))?screenWidth*0.034:screenWidth*0.038,
                        //fontWeight: FontWeight.bold,
                      ),
                    ),
                    textAlign: TextAlign.center,
                  ),Text(
                    "${exp}",
                    style: GoogleFonts.raleway(
                      textStyle: TextStyle(
                        color: Colors.black87,
                        fontSize: (isTablet(context))?screenWidth*0.034:screenWidth*0.039,
                        //fontWeight: FontWeight.bold,
                      ),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
        ),
      ),
    );
  }

  bool isTablet(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return screenWidth >= 600 && screenWidth <= 1024;
  }

  int checkClothingType(){
    if(c1){
      return 1;
    }else if(c2){
      return 2;
    }else if(c3){
      return 3;
    }else if(c4){
      return 4;
    }else {
      return 5;
    }
  }



}