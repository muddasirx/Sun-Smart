import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EstimatedVitaminDlevel extends StatefulWidget {
  const EstimatedVitaminDlevel({super.key});

  @override
  State<EstimatedVitaminDlevel> createState() => _EstimatedVitaminDlevelState();
}

class _EstimatedVitaminDlevelState extends State<EstimatedVitaminDlevel> {
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
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(onPressed: (){
                      Navigator.pop(context);
                    },
                        icon: Icon(Icons.arrow_back,size: (isTablet(context))?screenWidth* 0.05:screenWidth* 0.065,color: Colors.black87,)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: screenWidth*0.05),
                      child: Center(
                        child: Column(
                          children: [
                            SizedBox(height: (isTablet(context))?screenHeight*0.12:screenHeight*0.09),
                            Text(
                              "Recommended/Optional",
                              style: GoogleFonts.brunoAceSc(
                                textStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: (isTablet(context))?screenWidth*0.044:screenWidth*0.05,
                                  //fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(height: screenHeight*0.02),
                            Text(
                              "Estimated Vitamin D blood level",
                              style: GoogleFonts.raleway(
                                textStyle: TextStyle(
                                  color: Colors.black87,
                                  fontSize: (isTablet(context))?screenWidth*0.036:screenWidth*0.042,
                                  //fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(height: screenHeight*0.02),
                            Container(
                                decoration: BoxDecoration(
                                    color: Colors.cyan,
                                    borderRadius: BorderRadius.circular(50)
                                ),
                                child:Padding(
                                  padding: EdgeInsets.symmetric(horizontal: screenWidth*0.06,vertical: screenHeight*0.015),
                                  child: Text(
                                    "24",
                                    style: GoogleFonts.brunoAceSc(
                                      textStyle: TextStyle(
                                        color: Colors.white,
                                        fontSize: (isTablet(context))?screenWidth*0.034:screenWidth*0.04,
                                        //fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                )
                            ),
                            SizedBox(height: screenHeight*0.02),
                            Text(
                              "ng/ml",
                              style: GoogleFonts.raleway(
                                textStyle: TextStyle(
                                  color: Colors.black87,
                                  fontSize: (isTablet(context))?screenWidth*0.036:screenWidth*0.042,
                                  //fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(height: screenHeight*0.06),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Deficient",
                                  style: GoogleFonts.brunoAceSc(
                                    textStyle: TextStyle(
                                      color: Colors.black87,
                                      fontSize: (isTablet(context))?screenWidth*0.036:screenWidth*0.042,
                                      //fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Text(
                                  "Less than 31",
                                  style: GoogleFonts.raleway(
                                    textStyle: TextStyle(
                                      color: Colors.black87,
                                      fontSize: (isTablet(context))?screenWidth*0.034:screenWidth*0.04,
                                      //fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: screenHeight*0.03),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Low  Normal",
                                  style: GoogleFonts.brunoAceSc(
                                    textStyle: TextStyle(
                                      color: Colors.black87,
                                      fontSize: (isTablet(context))?screenWidth*0.036:screenWidth*0.042,
                                      //fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Text(
                                  "31-39",
                                  style: GoogleFonts.raleway(
                                    textStyle: TextStyle(
                                      color: Colors.black87,
                                      fontSize: (isTablet(context))?screenWidth*0.034:screenWidth*0.04,
                                      //fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: screenHeight*0.03),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Recommended",
                                  style: GoogleFonts.brunoAceSc(
                                    textStyle: TextStyle(
                                      color: Colors.black87,
                                      fontSize: (isTablet(context))?screenWidth*0.036:screenWidth*0.042,
                                      //fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Text(
                                  "40-60",
                                  style: GoogleFonts.raleway(
                                    textStyle: TextStyle(
                                      color: Colors.black87,
                                      fontSize: (isTablet(context))?screenWidth*0.034:screenWidth*0.04,
                                      //fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: screenHeight*0.03),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "High Normal",
                                  style: GoogleFonts.brunoAceSc(
                                    textStyle: TextStyle(
                                      color: Colors.black87,
                                      fontSize: (isTablet(context))?screenWidth*0.036:screenWidth*0.042,
                                      //fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Text(
                                  "61-80",
                                  style: GoogleFonts.raleway(
                                    textStyle: TextStyle(
                                      color: Colors.black87,
                                      fontSize: (isTablet(context))?screenWidth*0.034:screenWidth*0.04,
                                      //fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: screenHeight*0.03),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "High But Not Toxic",
                                  style: GoogleFonts.brunoAceSc(
                                    textStyle: TextStyle(
                                      color: Colors.black87,
                                      fontSize: (isTablet(context))?screenWidth*0.036:screenWidth*0.042,
                                      //fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Text(
                                  "81-149",
                                  style: GoogleFonts.raleway(
                                    textStyle: TextStyle(
                                      color: Colors.black87,
                                      fontSize: (isTablet(context))?screenWidth*0.034:screenWidth*0.04,
                                      //fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: screenHeight*0.03),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Toxicity Possible",
                                  style: GoogleFonts.brunoAceSc(
                                    textStyle: TextStyle(
                                      color: Colors.black87,
                                      fontSize: (isTablet(context))?screenWidth*0.036:screenWidth*0.042,
                                      //fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Text(
                                  "Greater than 149",
                                  style: GoogleFonts.raleway(
                                    textStyle: TextStyle(
                                      color: Colors.black87,
                                      fontSize: (isTablet(context))?screenWidth*0.034:screenWidth*0.04,
                                      //fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: screenHeight*0.07),
                            GestureDetector(
                              onTap: (){
                                Navigator.pushNamed(context, "/Spf");
                              },
                              child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.cyan,
                                      borderRadius: BorderRadius.circular(50)
                                  ),
                                  child:Padding(
                                    padding: EdgeInsets.symmetric(horizontal: screenWidth*0.06,vertical: screenHeight*0.015),
                                    child: Text(
                                      "Finish",
                                      style: GoogleFonts.brunoAceSc(
                                        textStyle: TextStyle(
                                          color: Colors.white,
                                          fontSize: (isTablet(context))?screenWidth*0.032:screenWidth*0.04,
                                          //fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  )
                              ),
                            ),

                          ],
                        ),
                      ),

                    )

                  ],
                ),
              ),
            )
          ],
        ),
    );
  }
  bool isTablet(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return screenWidth >= 600 && screenWidth <= 1024;
  }

}
