import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Disclaimer extends StatefulWidget {
  const Disclaimer({super.key});

  @override
  State<Disclaimer> createState() => _DisclaimerState();
}

class _DisclaimerState extends State<Disclaimer> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;

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
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(onPressed: (){
                    //Navigator.pop(context);
                  },
                      icon: Icon(Icons.arrow_back,size: (isTablet(context))?screenWidth* 0.05:screenWidth* 0.065,color: Colors.black87,)),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: screenWidth*0.1),
                      child: Column(
                        children: [
                          SizedBox(height: screenHeight*0.04,),
                          Text(
                            "Wil-D SUN2D",
                            style: GoogleFonts.brunoAceSc(
                              textStyle: TextStyle(
                                color: Colors.orangeAccent,
                                fontSize: (isTablet(context))?screenWidth*0.034:screenWidth*0.065,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            "20% off for App Users",
                            style: GoogleFonts.raleway(
                              textStyle: TextStyle(
                                color: Colors.orangeAccent,
                                fontSize: (isTablet(context))?screenWidth*0.034:screenWidth*0.05,
                                //fontWeight: FontWeight.bold,
                              ),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: screenHeight*0.04,),
                          Row(
                            children: [
                              Image.asset('assets/images/clothing.png',height: screenHeight*0.2,),
                            ],
                          )
                        ],
                      ),
                    ),
                  )

                ],
            ),
          )
        ],
      )
    );
  }

  bool isTablet(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return screenWidth >= 600 && screenWidth <= 1024;
  }
}
