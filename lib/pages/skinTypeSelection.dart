import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:provider/provider.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import '../providers/userDataProvider.dart';

// MediaQuery.of(context).size.width* 0.02(percentage)

class SkinType extends StatefulWidget {
  const SkinType({super.key});

  @override
  State<SkinType> createState() => _SkinTypeState();
}

class _SkinTypeState extends State<SkinType> {
  bool hasConnection = true;

  @override
  void initState() {
    super.initState();
    checkConnection();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;
    final userData = Provider.of<UserDataNotifier>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black87,
          size: (isTablet(context))?screenWidth* 0.046:screenWidth* 0.06,//(isTablet(context))?30:23
        ),

      ),
      resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            SafeArea(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: screenWidth*0.08),
                    child: Column(
                      children: [
                        Text(
                          "What's your Skin Type?",
                          style: GoogleFonts.brunoAceSc(
                            textStyle: TextStyle(
                              color: Colors.black,
                              fontSize: (isTablet(context))?screenWidth*0.04:screenWidth*0.051,
                              //fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: screenHeight*0.01,),
                        Column(
                            children: [
                             Text(
                                  "Select any of the following skin type",
                                  softWrap: true,
                                  style: GoogleFonts.lato(
                                    textStyle: TextStyle(
                                      color: Colors.black54,
                                      fontSize:(isTablet(context))?screenWidth*0.027:screenWidth*0.035,

                                      //fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),

                              Text(
                                "to proceed",
                                softWrap: true,
                                style: GoogleFonts.lato(
                                  textStyle: TextStyle(
                                    color: Colors.black54,
                                    fontSize: (isTablet(context))?screenWidth*0.027:screenWidth*0.035,

                                    //fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        SizedBox(height: screenHeight*0.03,),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            gradient: LinearGradient(
                              colors: [Color(0xffe65c00), Color(0xfff9d424)],
                              stops: [0, 1],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Column(
                                  children: [
                                    InkWell(
                                      onTap: (){

                                        if(userData.updateProfile){
                                          Navigator.pushNamed(context, "/UpdateProfile");
                                          userData.changeSkinType(1);
                                        }else{
                                          updateSkinType(1);
                                          Navigator.pushNamed(context, "/UserPrescription" );
                                          userData.changeSkinType(1);
                                        }
                                      },
                                      splashFactory: NoSplash.splashFactory,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03,vertical: screenHeight*0.02),
                                        child: Row(
                                          children: [
                                            Image.asset('assets/images/skinTypes/s2.png',
                                                height: (isTablet(context))
                                                    ? screenHeight * 0.052
                                                    : 0.043 * screenHeight),
                                            SizedBox(width: screenWidth * 0.02),
                                            Text(
                                              ":   ",
                                              softWrap: true,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: (isTablet(context)) ? screenWidth*0.033 : screenWidth*0.04,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Expanded(
                                              child: Center(
                                                child:Text(
                                                      "Always burns, never tans",
                                                      textAlign: TextAlign.center,
                                                      softWrap: true,
                                                      style: GoogleFonts.raleway(
                                                        textStyle: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: (isTablet(context)) ? screenWidth*0.033 : screenWidth*0.041,
                                                        ),
                                                      ),
                                                    ),
                                              ),
                                            ),
                                            Consumer<UserDataNotifier>(builder: (context,value,child) {
                                              return (userData.skinType == 1) ?
                                              Icon(Icons.check_circle_rounded,
                                                color: Color(0xFF0DA500),)
                                                  : SizedBox();
                                            })
                                          ],
                                        ),
                                      ),
                                    ),
                                    Divider(
                                        thickness: 1,
                                      color: Colors.white,
                                    ),
                                    InkWell(
                                      splashFactory: NoSplash.splashFactory,
                                      onTap: (){
                                        if(userData.updateProfile){
                                          Navigator.pushNamed(context, "/UpdateProfile");
                                          userData.changeSkinType(2);
                                        }else{
                                          Navigator.pushNamed(context, "/UserPrescription" );
                                          updateSkinType(2);
                                          userData.changeSkinType(2);
                                        }
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03,vertical: screenHeight*0.02),
                                        child: Row(
                                          children: [
                                            Image.asset('assets/images/skinTypes/s1.png',
                                                height: (isTablet(context))
                                                    ? screenHeight * 0.065
                                                    : 0.055 * screenHeight),
                                            SizedBox(width: screenWidth * 0.02),
                                            Text(
                                              ":   ",
                                              softWrap: true,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: (isTablet(context)) ? screenWidth*0.033 : screenWidth*0.041,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Expanded(
                                              child: Center(
                                                child: Text(
                                                      textAlign: TextAlign.center,
                                                      "Usually burns, Sometimes tans",
                                                      softWrap: true,
                                                      style: GoogleFonts.raleway(
                                                        textStyle: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: (isTablet(context)) ? screenWidth*0.033 : screenWidth*0.041,
                                                        ),
                                                    ),
                                                  ),
                                              ),
                                            ),
                                            Consumer<UserDataNotifier>(builder: (context,value,child) {
                                              return (userData.skinType == 2) ?
                                              Icon(Icons.check_circle_rounded,
                                                color: Color(0xFF0DA500),)
                                                  : SizedBox();
                                            })
                                          ],
                                        ),
                                      ),
                                    ),
                                    Divider(
                                      thickness: 1,
                                      color: Colors.white,
                                    ),
                                    InkWell(
                                      splashFactory: NoSplash.splashFactory,
                                      onTap: (){
                                        if(userData.updateProfile){
                                          Navigator.pushNamed(context, "/UpdateProfile");
                                          userData.changeSkinType(3);
                                        }else{
                                          Navigator.pushNamed(context, "/UserPrescription" );
                                          updateSkinType(3);
                                          userData.changeSkinType(3);
                                        }
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03,vertical: screenHeight*0.02),
                                        child: Row(
                                          children: [
                                            Image.asset('assets/images/skinTypes/s3.png',
                                                height: (isTablet(context))
                                                    ? screenHeight * 0.06
                                                    : 0.05 * screenHeight),
                                            SizedBox(width: screenWidth * 0.02),
                                            Text(
                                              ":   ",
                                              softWrap: true,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: (isTablet(context)) ? screenWidth*0.033 : screenWidth*0.041,
                                                  fontWeight: FontWeight.bold),
                                            ),// Add some spacing
                                            Expanded(
                                              child: Center(
                                                child:Text(
                                                      "Sometimes mild burns, tans uniformly",
                                                      softWrap: true,
                                                      textAlign: TextAlign.center,
                                                      style: GoogleFonts.raleway(
                                                        textStyle: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: (isTablet(context)) ? screenWidth*0.033 : screenWidth*0.041,
                                                        ),
                                                    ),
                                                  ),
                                              ),
                                            ),
                                            Consumer<UserDataNotifier>(builder: (context,value,child) {
                                              return (userData.skinType == 3) ?
                                              Icon(Icons.check_circle_rounded,
                                                color: Color(0xFF0DA500),)
                                                  : SizedBox();
                                            })
                                          ],
                                        ),
                                      ),
                                    ),
                                    Divider(
                                      thickness: 1,
                                      color: Colors.white,
                                    ),
                                    InkWell(
                                      splashFactory: NoSplash.splashFactory,
                                      onTap: (){
                                        if(userData.updateProfile){
                                          Navigator.pushNamed(context, "/UpdateProfile");
                                          userData.changeSkinType(4);
                                        }else{
                                          Navigator.pushNamed(context, "/UserPrescription" );
                                          updateSkinType(4);
                                          userData.changeSkinType(4);
                                        }
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03,vertical: screenHeight*0.02),
                                        child: Row(
                                          children: [
                                            Image.asset('assets/images/skinTypes/s4.png',
                                                height: (isTablet(context))
                                                    ? screenHeight * 0.06
                                                    : 0.05 * screenHeight),
                                            SizedBox(width: screenWidth * 0.02),
                                            Text(
                                              ":   ",
                                              softWrap: true,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: (isTablet(context)) ? screenWidth*0.033 : screenWidth*0.041,
                                                  fontWeight: FontWeight.bold),
                                            ),// Add some spacing
                                            Expanded(
                                              child: Center(
                                                child:Text(
                                                      "Burns minimally, always tans well",
                                                      textAlign: TextAlign.center,
                                                      softWrap: true,
                                                      style: GoogleFonts.raleway(
                                                        textStyle: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: (isTablet(context)) ? screenWidth*0.033 : screenWidth*0.041,
                                                        ),
                                                    ),
                                                  ),

                                              ),
                                            ),
                                            Consumer<UserDataNotifier>(builder: (context,value,child) {
                                              return (userData.skinType == 4) ?
                                              Icon(Icons.check_circle_rounded,
                                                color: Color(0xFF0DA500),)
                                                  : SizedBox();
                                            })
                                          ],
                                        ),
                                      ),
                                    ),
                                    Divider(
                                      thickness: 1,
                                      color: Colors.white,
                                    ),
                                    InkWell(
                                      splashFactory: NoSplash.splashFactory,
                                      onTap: (){
                                        if(userData.updateProfile){
                                          Navigator.pushNamed(context, "/UpdateProfile");
                                          userData.changeSkinType(5);
                                        }else{
                                          Navigator.pushNamed(context, "/UserPrescription" );
                                          updateSkinType(5);
                                          userData.changeSkinType(5);
                                        }
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03,vertical: screenHeight*0.02),
                                        child: Row(
                                          children: [
                                            Image.asset('assets/images/skinTypes/s5.png',
                                                height: (isTablet(context))
                                                    ? screenHeight * 0.06
                                                    : 0.05 * screenHeight),
                                            SizedBox(width: screenWidth * 0.02),
                                            Text(
                                              ":   ",
                                              softWrap: true,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: (isTablet(context)) ? screenWidth*0.033 : screenWidth*0.041,
                                                  fontWeight: FontWeight.bold),
                                            ),// Add some spacing
                                            Expanded(
                                              child: Center(
                                                child:Text(
                                                      "Burns rarely, tans very easily",
                                                      softWrap: true,
                                                      textAlign: TextAlign.center,
                                                      style: GoogleFonts.raleway(
                                                        textStyle: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: (isTablet(context)) ? screenWidth*0.033 : screenWidth*0.041,
                                                        ),
                                                    ),
                                                  ),
                                              ),
                                            ),
                                            Consumer<UserDataNotifier>(builder: (context,value,child) {
                                              return (userData.skinType == 5) ?
                                              Icon(Icons.check_circle_rounded,
                                                color: Color(0xFF0DA500),)
                                                  : SizedBox();
                                            })
                                          ],
                                        ),
                                      ),
                                    ),
                                    Divider(
                                      thickness: 1,
                                      color: Colors.white,
                                    ),
                                    InkWell(
                                      splashFactory: NoSplash.splashFactory,
                                      onTap: (){
                                        if(userData.updateProfile){
                                          Navigator.pushNamed(context, "/UpdateProfile");
                                          userData.changeSkinType(6);
                                        }else{
                                          Navigator.pushNamed(context, "/UserPrescription" );
                                          userData.changeSkinType(6);
                                          updateSkinType(6);
                                        }
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03,vertical: screenHeight*0.02),
                                        child: Row(
                                          children: [
                                            Image.asset('assets/images/skinTypes/s6.png',
                                                height: (isTablet(context))
                                                    ? screenHeight * 0.06
                                                    : 0.05 * screenHeight),
                                            SizedBox(width: screenWidth * 0.02),
                                            Text(
                                              ":   ",
                                              softWrap: true,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: (isTablet(context)) ? screenWidth*0.033 : screenWidth*0.041,
                                                  fontWeight: FontWeight.bold),
                                            ),// Add some spacing
                                            Expanded(
                                              child: Center(
                                                child:Text(
                                                      "Never burns deeply",
                                                      softWrap: true,
                                                      textAlign: TextAlign.center,
                                                      style: GoogleFonts.raleway(
                                                        textStyle: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: (isTablet(context)) ? screenWidth*0.033 : screenWidth*0.041,
                                                        ),
                                                    ),
                                                  ),
                                              ),
                                            ),
                                            Consumer<UserDataNotifier>(builder: (context,value,child) {
                                              return (userData.skinType == 6) ?
                                              Icon(Icons.check_circle_rounded,
                                                color: Color(0xFF0DA500),)
                                                  : SizedBox();
                                            })
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                        )

                      ],
                    ),
                  ),
                ),
              ),
            !hasConnection?
            Expanded(
              child: Container(
                color: Colors.white24,
              ),
            ):Container(),
            !hasConnection
                ? Padding(
              padding: EdgeInsets.only(left: isTablet(context)?screenWidth*0.05:0,right: isTablet(context)?screenWidth*0.05:0),
              child: Center(
                  child: AlertDialog(
                    title: Text(
                      "No Internet Available",
                      style: GoogleFonts.brunoAceSc(
                        textStyle: TextStyle(
                          color: Colors.black,
                          fontSize: (isTablet(context))?screenWidth*0.042:screenWidth*0.048,
                          //fontWeight: FontWeight.bold,
                        ),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset('assets/images/noConnection.png',height: screenHeight*0.2,),
                        Text(
                          'You need an internet connection to proceed. Please check your connection and try again.',
                          style: GoogleFonts.raleway(
                            textStyle: TextStyle(
                              color: Colors.black,
                              fontSize: (isTablet(context))?screenWidth*0.03:screenWidth*0.04,
                              //fontWeight: FontWeight.bold,
                            ),
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
                          style: GoogleFonts.brunoAceSc(
                            textStyle: TextStyle(
                              color: Colors.black,
                              fontSize: (isTablet(context))?screenWidth*0.038:screenWidth*0.04,
                              //fontWeight: FontWeight.bold,
                            ),
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
                          style: GoogleFonts.brunoAceSc(
                            textStyle: TextStyle(
                              color: Colors.black,
                              fontSize: (isTablet(context))?screenWidth*0.038:screenWidth*0.04,
                              //fontWeight: FontWeight.bold,
                            ),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],)
              ),
            )
                : Container(),
          ],
        ),
    );
  }
 Future<void> updateSkinType(int skinTypeNumber) async{
   final loginData = Provider.of<UserDataNotifier>(context, listen: false);

   CollectionReference userCollection = FirebaseFirestore.instance.collection('UserInfo');

   try {
     print(loginData.uid);
     QuerySnapshot querySnapshot = await userCollection.where('uid', isEqualTo: loginData.uid).get();

     if (querySnapshot.docs.isNotEmpty) {
       DocumentReference userDoc = querySnapshot.docs.first.reference;

       await userDoc.update({
         'skinType':skinTypeNumber
       });

       loginData.fetchUserData(loginData.uid);

       print('User info updated successfully');
     } else {
       print('No user found with the provided userID');
     }
   } catch (e) {
     print('Error updating user info: $e');
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
