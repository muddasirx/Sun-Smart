import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../providers/sessionDetailsProvider.dart';

class Spf extends StatefulWidget {
  const Spf({super.key});

  @override
  State<Spf> createState() => _SpfState();
}

class _SpfState extends State<Spf> {
 String dropDownValue="0";


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;
    final sessionDetails = Provider.of<sessionDetailsNotifier>(context, listen: false);

    return Scaffold(
        appBar:AppBar(
          iconTheme: IconThemeData(
            color: Colors.black87,
            size: (isTablet(context))?screenWidth* 0.046:screenWidth* 0.06,//(isTablet(context))?30:23
          ),
          centerTitle: true,

        ),
      body: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth*0.045),
            child: Column(
              children: [
                SizedBox(height: screenHeight*0.01,),
                Text(
                  "Sun Screen used during Sun Exposure",
                  style: TextStyle(
                    fontFamily: 'BrunoAceSC',
                      color: Colors.black,
                      fontSize: (isTablet(context))?screenWidth*0.042:screenWidth*0.048,
                      //fontWeight: FontWeight.bold,

                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: screenHeight*0.03,),
                Image.asset('assets/images/spf/spf.png',height: screenHeight*0.2,),
                Container(
                  width: (isTablet(context))?screenWidth*0.2:screenWidth*0.24,
                    height: (isTablet(context))?screenHeight*0.05:screenHeight*0.04,
                    decoration: BoxDecoration(
                        color: Colors.cyan,
                        borderRadius: BorderRadius.circular(70),
                    ),
                    child:Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "SPF",
                            style: TextStyle(
                              fontFamily: 'Raleway',
                                color: Colors.black,
                                fontSize: (isTablet(context))?screenWidth*0.036:screenWidth*0.037,
                                //fontWeight: FontWeight.bold,
                              ),

                          ),
                          SizedBox(width: screenWidth*0.02,),
                          DropdownButton<String>(
                              value: dropDownValue,
                              onChanged: (String? newValue) {
                                setState(() {
                                  dropDownValue = newValue!;
                                });
                              },
                              dropdownColor: Colors.grey[300],
                              style: TextStyle(
                                color:  Colors.black87,
                                fontSize: (isTablet(context))?screenWidth* 0.034:screenWidth* 0.037,//(isTablet(context))?23:15,
                              ),
                              icon: Icon(
                                Icons.arrow_drop_down,
                                color: Colors.black54,
                              ),
                              items: <String>['0','15','20','30','50']
                                  .map<DropdownMenuItem<String>>(
                                    (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                },
                              ).toList()
                          ),
                        ],
                      ),

                ),
                SizedBox(height: screenHeight*0.04,),
                Text(
                  "Please select the SPF value of the sunscreen you applied to help us accurately track the amount of vitamin IU consumed",
                  style: TextStyle(
                    fontFamily: 'Raleway',
                      color: Colors.black54,
                      fontSize: (isTablet(context))?screenWidth*0.034:screenWidth*0.035,
                      //fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: screenHeight*0.03,),
                Image.asset('assets/images/spf/spfTubes.png',height: screenHeight*0.2,),
                SizedBox(height: screenHeight*0.05,),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFFCC54E), Color(0xFFFDA34F)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(50), // Rounded corners
                  ),
                  child: TextButton(
                    onPressed: () async{
                      final sessionDetails = Provider.of<sessionDetailsNotifier>(context, listen: false);
                      sessionDetails.addSPF(int.parse(dropDownValue));

                      print("SPF: ${sessionDetails.spf}");
                      Navigator.pushNamed(context, "/ClothingType");
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white, padding: EdgeInsets.symmetric(horizontal: (isTablet(context))?screenWidth*0.18:screenWidth*0.2, vertical: (isTablet(context))?screenHeight*0.014:screenHeight*0.01), // Text color
                      textStyle: TextStyle(fontSize: (isTablet(context))?screenWidth*0.04:screenWidth*0.046, fontWeight: FontWeight.bold),
                    ),
                    child: Text('Next'),
                  ),
                )
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
