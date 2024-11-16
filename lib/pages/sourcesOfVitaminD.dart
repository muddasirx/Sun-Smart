import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/userDataProvider.dart';

class SourcesOfVitaminD extends StatefulWidget {
  const SourcesOfVitaminD({super.key});

  @override
  State<SourcesOfVitaminD> createState() => _SourcesOfVitaminDState();
}

class _SourcesOfVitaminDState extends State<SourcesOfVitaminD> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;
    final loginData = Provider.of<UserDataNotifier>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black87,
          size: (isTablet(context))?screenWidth* 0.046:screenWidth* 0.06,//(isTablet(context))?30:23
        ),
        centerTitle: true,
        title: Text(
          "Sources of Vitamin D",
          style: GoogleFonts.brunoAceSc(
            textStyle: TextStyle(
              color: Colors.black,
              fontSize: (isTablet(context))?screenWidth* 0.038:screenWidth* 0.051,//(isTablet(context))?27:20,
              //fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth*0.06),
        child: Column(
          children: [
            SizedBox(height: screenHeight*0.02,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "1. Sun",
                  style: GoogleFonts.brunoAceSc(
                    textStyle: TextStyle(
                      color: Colors.black,
                      //fontWeight: FontWeight.bold,
                      fontSize: (isTablet(context))?screenWidth* 0.04:screenWidth* 0.046,//(isTablet(context))?20:15,
                    ),
                  ),
                  softWrap: true,
                ),
                Image.asset('assets/images/vitaminDSources/x1.png',height: screenHeight*0.15,),
              ],
            ),
            SizedBox(height: screenHeight*0.05,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "2. Supplements",
                      style: GoogleFonts.brunoAceSc(
                        textStyle: TextStyle(
                          color: Colors.black,
                          //fontWeight: FontWeight.bold,
                          fontSize: (isTablet(context))?screenWidth* 0.04:screenWidth* 0.046,//(isTablet(context))?20:15,
                        ),
                      ),
                      softWrap: true,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: screenWidth*0.06,top: screenHeight*0.01),
                      child: Text(
                        "Daily Cal\nWIL-D\nPlant Cal\nSea Mega\nSea Mega Plus\nOthers",
                        style: GoogleFonts.raleway(
                          textStyle: TextStyle(
                            color: Colors.black,
                            //fontWeight: FontWeight.bold,
                            fontSize: (isTablet(context))?screenWidth* 0.034:screenWidth* 0.04,//(isTablet(context))?20:15,
                          ),
                        ),
                        softWrap: true,
                      ),
                    ),
                  ],
                ),
                Image.asset('assets/images/vitaminDSources/x2.png',height: (isTablet(context))?screenHeight*0.14:screenHeight*0.11,),
              ],
            ),
            SizedBox(height: screenHeight*0.05,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "3. Food",
                      style: GoogleFonts.brunoAceSc(
                        textStyle: TextStyle(
                          color: Colors.black,
                         // fontWeight: FontWeight.bold,
                          fontSize: (isTablet(context))?screenWidth* 0.04:screenWidth* 0.046,//(isTablet(context))?20:15,
                        ),
                      ),
                      softWrap: true,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: screenWidth*0.06,top: screenHeight*0.01),
                      child: Text(
                        "Milk\nEggs\nMushrooms\nBeef Liver\nRicotta Cheese",
                        style: GoogleFonts.raleway(
                          textStyle: TextStyle(
                            color: Colors.black,
                            //fontWeight: FontWeight.bold,
                            fontSize: (isTablet(context))?screenWidth* 0.034:screenWidth* 0.04,//(isTablet(context))?20:15,
                          ),
                        ),
                        softWrap: true,
                      ),
                    ),
                  ],
                ),
                Image.asset('assets/images/vitaminDSources/x3.png',height: (isTablet(context))?screenHeight*0.19:screenHeight*0.15,),
              ],
            ),
            SizedBox(height: screenHeight*0.08,),
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
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  await prefs.setBool('appSettings', true);
                  if(loginData.user['sessionID']!='none'){
                    Navigator.pushNamed(context, "/GraphScreen");
                  }else
                  Navigator.pushNamed(context, "/Spf");
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white, padding: EdgeInsets.symmetric(horizontal: (isTablet(context))?screenWidth*0.15:screenWidth*0.15, vertical: (isTablet(context))?screenHeight*0.014:screenHeight*0.01), // Text color
                  textStyle: TextStyle(fontSize: (isTablet(context))?screenWidth*0.04:screenWidth*0.047, fontWeight: FontWeight.bold),
                ),
                child: Text('Proceed'),
              ),
            ),

          ],
        ),
      ),
    );
  }

  bool isTablet(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return screenWidth >= 600 && screenWidth <= 1024;
  }

}
