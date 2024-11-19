import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../providers/historyProvider.dart';

class UserHistory extends StatefulWidget {
  const UserHistory({super.key});

  @override
  State<UserHistory> createState() => _UserHistoryState();
}

class _UserHistoryState extends State<UserHistory> {
 // bool yesPressed=true,noPressed=false;
  bool m1=false,m2=false,m3=false;
  TextEditingController supplementsController= TextEditingController();

  @override
  void initState() {
    super.initState();
    final historyProvider= Provider.of<HistoryNotifier>(context,listen: false);
    setState(() {
      m1=historyProvider.m1;
      m2=historyProvider.m2;
      m3=historyProvider.m3;
      supplementsController.text=historyProvider.supplementsController.text;
    });
  }

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
          "Your History",
          style: TextStyle(
            fontFamily: 'BrunoAceSC',
              color: Colors.black,
              fontSize: (isTablet(context))?screenWidth* 0.038:screenWidth* 0.051,//(isTablet(context))?27:20,
              //fontWeight: FontWeight.bold,
            ),
        ),
      ),

      body:SafeArea(
            child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth*0.03),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                          SizedBox(height: screenHeight*0.03,),
                        Column(
                          children: [
                            SizedBox(height: screenHeight*0.045,),
                            Row(
                              children: [
                                Transform.scale(
                                  scale: (isTablet(context)) ? 1.33 : 0.9,
                                  child: Checkbox(
                                    value: m1,
                                    checkColor: Colors.white,
                                    activeColor: Colors.orange,
                                    side: BorderSide(color: Colors.black, width: 2),
                                    onChanged: (bool? value) {
                                      setState(() {
                                        m1 = value!;
                                      });
                                    },
                                  ),
                                ),
                                SizedBox(width: screenWidth*0.02,),
                                Image.asset('assets/images/supplements/m2.png',height: screenHeight*0.11,),
                                SizedBox(width: screenWidth*0.02,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Daily Cal",
                                      style: TextStyle(
                                        fontFamily: 'BrunoAceSC',
                                          color: Colors.black,
                                          //fontWeight: FontWeight.bold,
                                          fontSize: (isTablet(context))?screenWidth* 0.037:screenWidth* 0.04,//(isTablet(context))?20:15,
                                        ),

                                      softWrap: true,
                                    ),
                                    Text(
                                          "Fortified with Vitamin\nD3,C & B4",
                                          style: TextStyle(
                                            fontFamily: 'Raleway',
                                              color: Colors.black,
                                              fontSize: (isTablet(context))?screenWidth*0.032:screenWidth*0.036,
                                              //fontWeight: FontWeight.bold,

                                          ),
                                          softWrap: true,
                                        ),


                                  ],
                                )
                              ],
                            ),
                            SizedBox(height: screenHeight*0.03,),
                            Row(
                              children: [
                                Transform.scale(
                                  scale: (isTablet(context)) ? 1.33 : 0.9,
                                  child: Checkbox(
                                    value: m2,
                                    checkColor: Colors.white,
                                    activeColor: Colors.orange,
                                    side: BorderSide(color: Colors.black, width: 2),
                                    onChanged: (bool? value) {
                                      setState(() {
                                        m2 = value!;
                                      });
                                    },
                                  ),
                                ),
                                SizedBox(width: screenWidth*0.02,),
                                Image.asset('assets/images/supplements/m3.png',height: screenHeight*0.11,),
                                SizedBox(width: screenWidth*0.02,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Insta CAL-D",
                                      style: TextStyle(
                                        fontFamily: 'BrunoAceSC',
                                          color: Colors.black,
                                          //fontWeight: FontWeight.bold,
                                          fontSize: (isTablet(context))?screenWidth* 0.037:screenWidth* 0.04,//(isTablet(context))?20:15,

                                      ),
                                      softWrap: true,
                                    ),
                                    Text(
                                      "Fortified with Vitamin C\nfor healthy immune\nsystem",
                                      style:  TextStyle(
                                        fontFamily: 'Raleway',
                                          color: Colors.black,
                                          fontSize: (isTablet(context))?screenWidth*0.032:screenWidth*0.036,
                                          //fontWeight: FontWeight.bold,
                                        ),

                                      softWrap: true,
                                    ),


                                  ],
                                )
                              ],
                            ),
                            SizedBox(height: screenHeight*0.03,),
                            Row(
                              children: [
                                Transform.scale(
                                  scale: (isTablet(context)) ? 1.33 : 0.9,
                                  child: Checkbox(
                                    value: m3,
                                    checkColor: Colors.white,
                                    activeColor: Colors.orange,
                                    side: BorderSide(color: Colors.black, width: 2),
                                    onChanged: (bool? value) {
                                      setState(() {
                                        m3 = value!;
                                      });
                                    },
                                  ),
                                ),
                                SizedBox(width: screenWidth*0.02,),
                                Image.asset('assets/images/supplements/m1.png',height: screenHeight*0.1,),
                                SizedBox(width: screenWidth*0.02,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "WIL-D",
                                      style:  TextStyle(
                                        fontFamily: 'BrunoAceSC',
                                          color: Colors.black,
                                          //fontWeight: FontWeight.bold,
                                          fontSize: (isTablet(context))?screenWidth* 0.037:screenWidth* 0.04,//(isTablet(context))?20:15,
                                        ),

                                      softWrap: true,
                                    ),
                                    Text(
                                      "Fortified with Vitamin D\nfor bone & heart",
                                      style: TextStyle(
                                        fontFamily: 'Raleway',
                                          color: Colors.black,
                                          fontSize: (isTablet(context))?screenWidth*0.032:screenWidth*0.036,
                                          //fontWeight: FontWeight.bold,

                                      ),
                                      softWrap: true,
                                    ),


                                  ],
                                )
                              ],
                            ),
                            SizedBox(height: screenHeight*0.07,),
                            Text(
                                "Are you taking any other supplements?",
                                style:  TextStyle(
                                  fontFamily: 'BrunoAceSC',
                                    color: Colors.black,
                                    fontSize: (isTablet(context))?screenWidth*0.035:screenWidth*0.04,
                                    //fontWeight: FontWeight.bold,

                                ),
                                textAlign: TextAlign.center,
                                softWrap: true,
                              ),
                            SizedBox(height: screenHeight*0.04,),
                            Padding(
                              padding:  EdgeInsets.symmetric(horizontal: screenWidth*0.1),
                              child: TextFormField(
                                controller: supplementsController,
                                cursorColor: Color(0xFF505050),
                                cursorWidth: 1.5,
                                style:TextStyle(fontFamily: 'Raleway',color: Colors.black, fontSize: (isTablet(context))?screenWidth* 0.035:screenWidth* 0.04),
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  errorStyle: TextStyle(color: Colors.red),
                                  contentPadding: EdgeInsets.only(left: screenWidth*0.04,right: screenWidth*0.01,top: screenHeight*0.023,bottom: screenHeight*0.023),
                                  labelText: "Other Supplements",
                                  hintText: "eg. Bonex-D, Suncell 5000...",
                                  hintStyle: TextStyle(
                                    fontFamily: 'Raleway',
                                        color: Colors.black54,
                                        fontSize: (isTablet(context))?screenWidth* 0.035:screenWidth* 0.038,
                                        // fontWeight: themeNotifier.isDarkTheme? FontWeight.normal:FontWeight.bold
                                      ),
                                  labelStyle: TextStyle(
                                    fontFamily: 'Raleway',
                                        color: Colors.black,
                                        fontSize: (isTablet(context))?screenWidth* 0.035:screenWidth* 0.04,
                                        // fontWeight: themeNotifier.isDarkTheme? FontWeight.normal:FontWeight.bold
                                      ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      width: 1.5,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      width: 1.5,
                                      color: Colors.black54,
                                    ),
                                  ),

                                ),
                              ),
                            ),
                            //SizedBox(height: screenHeight*0.01,),
                            //Image.asset('assets/images/supplements/m4.png',height: screenHeight*0.08,),
                          ],
                        ),
                        SizedBox(height: screenHeight*0.05,),
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
                                    final historyProvider = Provider.of<HistoryNotifier>(context, listen: false);

                                    historyProvider.m1Pressed(m1);
                                    historyProvider.m2Pressed(m2);
                                    historyProvider.m3Pressed(m3);
                                    historyProvider.supplementsController.text = supplementsController.text.trim();

                                    if(m1 || m2 || m3 || supplementsController.text.isNotEmpty)
                                     historyProvider.pillSelected();
                                   else
                                      historyProvider.pillRemoved();

                                   Navigator.pop(context);

                                  },
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.white, padding: EdgeInsets.symmetric(horizontal: (isTablet(context))?screenWidth*0.12:screenWidth*0.15, vertical: (isTablet(context))?screenHeight*0.014:screenHeight*0.01), // Text color
                                    textStyle: TextStyle(fontSize: (isTablet(context))?screenWidth*0.04:screenWidth*0.047, fontWeight: FontWeight.bold),
                                  ),
                                  child: Text('Confirm'),
                                ),
                              ),

                        ),
                        SizedBox(height: screenHeight*0.01,),
                      ],
                    ),
                  ),
                ),


          )

    );
  }

  Widget choiceSelected(String ch){
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(
        decoration: BoxDecoration(
            color: Colors.cyan,
            borderRadius: BorderRadius.circular(50)
        ),
        child:Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth*0.06,vertical: screenHeight*0.015),
          child: Text(
            ch,
            style: TextStyle(
              fontFamily: 'BrunoAceSC',
                color: Colors.white,
                fontSize: (isTablet(context))?screenWidth*0.032:screenWidth*0.038,
                //fontWeight: FontWeight.bold,
              ),

          ),
        )
    );
  }

  bool isTablet(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return screenWidth >= 600 && screenWidth <= 1024;
  }

}
