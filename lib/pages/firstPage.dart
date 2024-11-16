import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'LoginScreen.dart';

class firstPage extends StatefulWidget {
  const firstPage({super.key});

  @override
  State<firstPage> createState() => _firstPageState();
}

class _firstPageState extends State<firstPage> {

  bool isTablet(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return screenWidth >= 600 && screenWidth <= 1024;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: Align(
          alignment: Alignment.center,
          child: Column(
              children: [
                SizedBox(height: (isTablet(context))?screenHeight*0.04:screenHeight*0.01,),
                Image.asset('assets/images/firstScreen.png',height: (isTablet(context))?screenHeight*0.21:0.18*screenHeight,),
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: screenWidth * 0.08, right: screenWidth * 0.15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: (isTablet(context))?screenHeight * 0.02:screenHeight * 0.015),
                        Text(
                          "Track Your Goal",
                          style: GoogleFonts.oxanium(
                            textStyle: TextStyle(
                              color: Colors.black,
                              fontSize: (isTablet(context))?screenWidth* 0.037:screenWidth* 0.056,//22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.005),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "1. ",
                              style: GoogleFonts.raleway(
                                textStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: (isTablet(context))?screenWidth* 0.027:screenWidth* 0.038,//(isTablet(context))?22:15,
                                ),
                              ),
                            ),
                            Flexible(
                              child: Text(
                                "Spread about benefits of Vitamin D",
                                style: GoogleFonts.raleway(
                                  textStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: (isTablet(context))?screenWidth* 0.027:screenWidth* 0.038,//(isTablet(context))?20:15,
                                  ),
                                ),
                                softWrap: true,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "2. ",
                              style: GoogleFonts.raleway(
                                textStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: (isTablet(context))?screenWidth* 0.027:screenWidth* 0.038,//(isTablet(context))?20:15,
                                ),
                              ),
                            ),
                            Flexible(
                              child: Text(
                                "Prevent vitamin D deficiency among children and adults",
                                style: GoogleFonts.raleway(
                                  textStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: (isTablet(context))?screenWidth* 0.027:screenWidth* 0.038,//(isTablet(context))?20:15,
                                  ),
                                ),
                                softWrap: true,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "3. ",
                              style: GoogleFonts.raleway(
                                textStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: (isTablet(context))?screenWidth* 0.027:screenWidth* 0.038,//(isTablet(context))?20:15,
                                ),
                              ),
                            ),
                            Flexible(
                              child: Text(
                                "Healthier lifestyle",
                                style: GoogleFonts.raleway(
                                  textStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: (isTablet(context))?screenWidth* 0.027:screenWidth* 0.038,//(isTablet(context))?20:15,
                                  ),
                                ),
                                softWrap: true,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "4. ",
                              style: GoogleFonts.raleway(
                                textStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: (isTablet(context))?screenWidth* 0.027:screenWidth* 0.038,//15,
                                ),
                              ),
                            ),
                            Flexible(
                              child: Text(
                                "Create more reasons for families to spend more time outdoors",
                                style: GoogleFonts.raleway(
                                  textStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: (isTablet(context))?screenWidth* 0.027:screenWidth* 0.038,//15,
                                  ),
                                ),
                                softWrap: true,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: screenHeight * 0.03),
                        Text(
                          "How App Works",
                          style: GoogleFonts.oxanium(
                            textStyle: TextStyle(
                              color: Colors.black,
                              fontSize: (isTablet(context))?screenWidth* 0.037:screenWidth* 0.056,//(isTablet(context))?27:22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.005),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "1. ",
                              style: GoogleFonts.raleway(
                                textStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: (isTablet(context))?screenWidth* 0.027:screenWidth* 0.038,//(isTablet(context))?20:15,
                                ),
                              ),
                            ),
                            Flexible(
                              child: Text(
                                "Scan the sun",
                                style: GoogleFonts.raleway(
                                  textStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: (isTablet(context))?21:screenWidth* 0.038,//(isTablet(context))?20:15,
                                  ),
                                ),
                                softWrap: true,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "2. ",
                              style: GoogleFonts.raleway(
                                textStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: (isTablet(context))?screenWidth* 0.027:screenWidth* 0.038,//(isTablet(context))?20:15,
                                ),
                              ),
                            ),
                            Flexible(
                              child: Text(
                                "Start the timer",
                                style: GoogleFonts.raleway(
                                  textStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: (isTablet(context))?screenWidth* 0.027:screenWidth* 0.038,//(isTablet(context))?20:15,
                                  ),
                                ),
                                softWrap: true,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "3. ",
                              style: GoogleFonts.raleway(
                                textStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: (isTablet(context))?screenWidth* 0.027:screenWidth* 0.038,//(isTablet(context))?20:15,
                                ),
                              ),
                            ),
                            Flexible(
                              child: Text(
                                "Know when to end the session",
                                style: GoogleFonts.raleway(
                                  textStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: (isTablet(context))?screenWidth* 0.027:screenWidth* 0.038,//(isTablet(context))?20:15,
                                  ),
                                ),
                                softWrap: true,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "4. ",
                              style: GoogleFonts.raleway(
                                textStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: (isTablet(context))?screenWidth* 0.027:screenWidth* 0.038,//(isTablet(context))?20:15,
                                ),
                              ),
                            ),
                            Flexible(
                              child: Text(
                                "Track the progress",
                                style: GoogleFonts.raleway(
                                  textStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: (isTablet(context))?screenWidth* 0.027:screenWidth* 0.038,//(isTablet(context))?20:15,
                                  ),
                                ),
                                softWrap: true,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: screenHeight * 0.03),
                        Text(
                          "Features",
                          style: GoogleFonts.oxanium(
                            textStyle: TextStyle(
                              color: Colors.black,
                              fontSize: (isTablet(context))?screenWidth* 0.037:screenWidth* 0.056,//(isTablet(context))?27:22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.005),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "1. ",
                              style: GoogleFonts.raleway(
                                textStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: (isTablet(context))?screenWidth* 0.027:screenWidth* 0.038,//(isTablet(context))?20:15,
                                ),
                              ),
                            ),
                            Flexible(
                              child: Text(
                                "Calculates the amount of vitamin D produced during each session",
                                style: GoogleFonts.raleway(
                                  textStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: (isTablet(context))?screenWidth* 0.027:screenWidth* 0.038,//(isTablet(context))?20:15,
                                  ),
                                ),
                                softWrap: true,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "2. ",
                              style: GoogleFonts.raleway(
                                textStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: (isTablet(context))?screenWidth* 0.027:screenWidth* 0.038,//(isTablet(context))?20:15,
                                ),
                              ),
                            ),
                            Flexible(
                              child: Text(
                                "Vitamin D supplement tracker",
                                style: GoogleFonts.raleway(
                                  textStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: (isTablet(context))?screenWidth* 0.027:screenWidth* 0.038,//(isTablet(context))?20:15,
                                  ),
                                ),
                                softWrap: true,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "3. ",
                              style: GoogleFonts.raleway(
                                textStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: (isTablet(context))?screenWidth* 0.027:screenWidth* 0.038,//(isTablet(context))?20:15,
                                ),
                              ),
                            ),
                            Flexible(
                              child: Text(
                                "Vitamin D supplement reminder",
                                style: GoogleFonts.raleway(
                                  textStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: (isTablet(context))?screenWidth* 0.027:screenWidth* 0.038,//(isTablet(context))?20:15,
                                  ),
                                ),
                                softWrap: true,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "4. ",
                              style: GoogleFonts.raleway(
                                textStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: (isTablet(context))?screenWidth* 0.027:screenWidth* 0.038,//(isTablet(context))?20:15,
                                ),
                              ),
                            ),
                            Flexible(
                              child: Text(
                                "Calculates session duration in the sun",
                                style: GoogleFonts.raleway(
                                  textStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: (isTablet(context))?screenWidth* 0.027:screenWidth* 0.038,//(isTablet(context))?20:15,
                                  ),
                                ),
                                softWrap: true,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "5. ",
                              style: GoogleFonts.raleway(
                                textStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: (isTablet(context))?screenWidth* 0.027:screenWidth* 0.038,//(isTablet(context))?20:15,
                                ),
                              ),
                            ),
                            Flexible(
                              child: Text(
                                "Daily goals and reminders",
                                style: GoogleFonts.raleway(
                                  textStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: (isTablet(context))?screenWidth* 0.027:screenWidth* 0.038,//(isTablet(context))?20:15,
                                  ),
                                ),
                                softWrap: true,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: (isTablet(context))?screenHeight*0.05:screenHeight*0.04,),
                Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFFFCC54E), Color(0xFFFDA34F)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(30.0), // Rounded corners
                    ),
                    child: TextButton(
                      onPressed: () {
                        print("button pressed");
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => LoginScreen()),
                        );
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white, padding: EdgeInsets.symmetric(horizontal: (isTablet(context))?screenWidth*0.12:screenWidth*0.15, vertical: (isTablet(context))?screenHeight*0.014:screenHeight*0.01), // Text color
                        textStyle: TextStyle(fontSize: (isTablet(context))?screenWidth* 0.033:screenWidth* 0.047,//18,
                            fontWeight: FontWeight.bold),
                      ),
                      child: Text('Get Started'),
                    ),
                  )
              ],
            ),
        ),
      ),
    );
  }
}
