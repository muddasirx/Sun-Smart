import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:provider/provider.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:untitled/pages/LoginScreen.dart';

import '../../providers/sessionDetailsProvider.dart';
import '../../providers/userDataProvider.dart';

class UpdatePassword extends StatefulWidget {
  const UpdatePassword({super.key});

  @override
  State<UpdatePassword> createState() => _UpdatePasswordState();
}

class _UpdatePasswordState extends State<UpdatePassword> {
  bool hasConnection=true;
  bool updatePressed=false;
  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  FocusNode confirmPasswordFocusNode = FocusNode();
  FocusNode currentPasswordFocusNode = FocusNode();
  FocusNode newPasswordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    checkConnection();
  }

  @override
  void dispose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    confirmPasswordFocusNode.dispose();
    currentPasswordFocusNode.dispose();
    newPasswordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;
    final userData = Provider.of<UserDataNotifier>(context, listen: false);
    final sessionDetails = Provider.of<sessionDetailsNotifier>(context, listen: false);

    @override
    void initState() {
      super.initState();
      checkConnection();
    }

    return Scaffold(
     appBar:  AppBar(
        iconTheme: IconThemeData(
          color: Colors.black87,
          size: (isTablet(context))?screenWidth* 0.046:screenWidth* 0.06,//(isTablet(context))?30:23
        ),
        centerTitle: true,
        title: Text(
          "Update Password",
          style: TextStyle(
            fontFamily: 'BrunoAceSC',
            color: Colors.black,
            fontSize: (isTablet(context))?screenWidth* 0.038:screenWidth* 0.051,//(isTablet(context))?27:20,
            //fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: (isTablet(context))?screenWidth*0.15:screenWidth*0.1),
            child:Column(
              children: [
                SizedBox(height: screenHeight*0.07,),
                TextFormField(
                  focusNode: currentPasswordFocusNode,
                  controller: currentPasswordController,
                  cursorColor: Colors.black87,
                  cursorWidth: 1.5,
                  style: TextStyle(color: Colors.black, fontSize: (isTablet(context))?screenWidth* 0.034:screenWidth* 0.039),
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    errorStyle: TextStyle(color: Colors.red),
                    contentPadding: EdgeInsets.only(left: screenWidth*0.04,right: screenWidth*0.01,top: screenHeight*0.025,bottom: screenHeight*0.025),
                    labelText: "Current Password",
                    labelStyle: TextStyle(
                      fontFamily: 'Lato',
                      color: Colors.black54,
                      fontSize: (isTablet(context))?screenWidth* 0.038:screenWidth* 0.045,
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Email cannot be Empty";
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
                SizedBox(height: screenHeight*0.03,),
                TextFormField(
                  focusNode: newPasswordFocusNode,
                  controller: newPasswordController,
                  cursorColor: Colors.black87,
                  cursorWidth: 1.5,
                  style: TextStyle(color: Colors.black, fontSize: (isTablet(context))?screenWidth* 0.034:screenWidth* 0.039),
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    errorStyle: TextStyle(color: Colors.red),
                    contentPadding: EdgeInsets.only(left: screenWidth*0.04,right: screenWidth*0.01,top: screenHeight*0.025,bottom: screenHeight*0.025),
                    labelText: "New Password",
                    labelStyle: TextStyle(
                      fontFamily: 'Lato',
                      color: Colors.black54,
                      fontSize: (isTablet(context))?screenWidth* 0.038:screenWidth* 0.045,
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Email cannot be Empty";
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
                SizedBox(height: screenHeight*0.03,),
                TextFormField(
                  focusNode: confirmPasswordFocusNode,
                  controller: confirmPasswordController,
                  cursorColor: Colors.black87,
                  cursorWidth: 1.5,
                  style: TextStyle(color: Colors.black, fontSize: (isTablet(context))?screenWidth* 0.034:screenWidth* 0.039),
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    errorStyle: TextStyle(color: Colors.red),
                    contentPadding: EdgeInsets.only(left: screenWidth*0.04,right: screenWidth*0.01,top: screenHeight*0.025,bottom: screenHeight*0.025),
                    labelText: "Confirm Password",
                    labelStyle: TextStyle(
                      fontFamily: 'Lato',
                      color: Colors.black54,
                      fontSize: (isTablet(context))?screenWidth* 0.038:screenWidth* 0.045,
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Email cannot be Empty";
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
                SizedBox(height: screenHeight*0.06,),
                GestureDetector(
                  onTap: () async {
                    await checkConnection();
                    if(hasConnection){
                      if(validateFields()){
                        setState(() {
                          updatePressed=true;
                        });
                        await updatePassword();
                      }
                    }
                  },
                  child: Container(
                    height: screenHeight*0.06,
                    width: screenWidth*0.35,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFFFCC54E), Color(0xFFFDA34F)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(50.0), // Rounded corners
                    ),
                    child: Center(
                      child: updatePressed?Padding(
                        padding:  EdgeInsets.symmetric(vertical:  screenHeight*0.019),
                        child: LoadingIndicator(
                          indicatorType: Indicator. lineScaleParty, /// Required, The loading type of the widget
                          colors: const [Colors.white],       /// Optional, The color collections
                          strokeWidth: 1,              /// Optional, the stroke backgroundColor
                        ),
                      ):Text('Update',style: TextStyle(fontSize: (isTablet(context))?screenWidth* 0.036:screenWidth* 0.044, color: Colors.white,fontWeight: FontWeight.bold),),
                    ),

                  ),
                ),
              ],
            ),
          ),
          !hasConnection?
          Container(
            height: double.infinity,
            width: double.infinity,
            color: Colors.white38,
          )
              :SizedBox.shrink(),
          !hasConnection
              ? Padding(
            padding: EdgeInsets.only(top: isTablet(context)?screenHeight*0.1:0,left: isTablet(context)?screenWidth*0.05:0,right: isTablet(context)?screenWidth*0.05:0),
            child: Center(
                child: AlertDialog(
                  title: Text(
                    "No Internet Available",
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'BrunoAceSC',
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
                          color: Colors.black,
                          fontFamily: 'Raleway',
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
                          color: Colors.black,
                          fontFamily: 'BrunoAceSC',
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
                          color: Colors.black,
                          fontSize: (isTablet(context))?screenWidth*0.038:screenWidth*0.04,
                          fontFamily: 'BrunoAceSC',
                          //fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],)
            ),
          )
              : SizedBox.shrink(),
        ],
      ),
      bottomNavigationBar: Image.asset('assets/images/backgrounds/bg3.jpg',width: double.infinity,),
    );
  }
  Future<void> checkConnection() async {
    var result = await InternetConnectionChecker().hasConnection;
    if (mounted) {
      //if(result)
       // updateDateRange();
      setState(() {
        hasConnection = result;
      });
    }
  }

  bool isTablet(BuildContext context) {
    var screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    return screenWidth >= 600 && screenWidth <= 1024;
  }

  bool validateFields(){
    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;

    if(currentPasswordController.text.trim().isNotEmpty && newPasswordController.text.trim().isNotEmpty && confirmPasswordController.text.trim().isNotEmpty){
      if(newPasswordController.text.trim()==confirmPasswordController.text.trim()){
        if(newPasswordController.text.trim()!=currentPasswordController.text.trim()){
          return true;
        }else{

          confirmPasswordController.clear();
          newPasswordController.clear();
          newPasswordFocusNode.requestFocus();

          Fluttertoast.showToast(
            fontSize: (isTablet(context))?screenWidth*0.03:screenWidth*0.035,
            msg: "Current and new password cannot be same",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );

          return false;
        }

      }else{
        confirmPasswordFocusNode.requestFocus();
        confirmPasswordController.clear();

        Fluttertoast.showToast(
          fontSize: (isTablet(context))?screenWidth*0.03:screenWidth*0.035,
          msg: "Confirm password doesn’t match the new password.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red, // Change this to your desired background color
          textColor: Colors.white,
        );

        return false;
      }
    }else{
      Fluttertoast.showToast(
        fontSize: (isTablet(context))?screenWidth*0.03:screenWidth*0.035,
        msg: "Please fill in all required fields to continue.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red, // Change this to your desired background color
        textColor: Colors.white,
      );

      return false;
    }
  }

  Future<void> updatePassword() async{
    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;
    final userData = Provider.of<UserDataNotifier>(context, listen: false);
    final sessionDetails = Provider.of<sessionDetailsNotifier>(context, listen: false);

    try{
      UserCredential credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: userData.user['email'],
        password: currentPasswordController.text.trim(),
      );
      User? user = FirebaseAuth.instance.currentUser;
      await user?.updatePassword(newPasswordController.text.trim());
      Navigator.pop(context);
      Fluttertoast.showToast(
        fontSize: (isTablet(context))?screenWidth*0.03:screenWidth*0.035,
        msg: "Password updated successfully.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey[300],
        textColor: Colors.black,
      );
    }on FirebaseAuthException catch (e) {
      if (e.toString() == '[firebase_auth/invalid-credential] The supplied auth credential is incorrect, malformed or has expired.') {

        Fluttertoast.showToast(
          fontSize: (isTablet(context))?screenWidth*0.03:screenWidth*0.035,
          msg: "Current password is incorrect",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
        currentPasswordController.clear();
        currentPasswordFocusNode.requestFocus();

        setState(() {
          updatePressed= false;
        });
      } else {
        if(e.message=="Password should be at least 6 characters"){
            newPasswordController.clear();
            confirmPasswordController.clear();
            newPasswordFocusNode.requestFocus();
        }
        Fluttertoast.showToast(
          fontSize: (isTablet(context))?screenWidth*0.03:screenWidth*0.035,
          msg: '${e.message}',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
        setState(() {
          updatePressed= false;
        });
      }
    }

  }

}
