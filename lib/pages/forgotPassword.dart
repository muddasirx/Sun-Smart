import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_indicator/loading_indicator.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController emailController = TextEditingController();
  bool submitPressed=false;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: Colors.black87,
            size: (isTablet(context))?screenWidth* 0.046:screenWidth* 0.06
        ),
        centerTitle: true,
        title: Text(
          "Reset Password",
          style: GoogleFonts.brunoAceSc(
            textStyle: TextStyle(
              color: Colors.black,
              fontSize: (isTablet(context))?screenWidth* 0.038:screenWidth* 0.051,
              //fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: (isTablet(context))?screenWidth*0.15:screenWidth*0.1),
        child:Column(
          children: [
            SizedBox(height: screenHeight*0.07,),
            TextFormField(
              controller: emailController,
              cursorColor: Color(0xFF505050),
              cursorWidth: 1.5,
              style: TextStyle(color: Colors.black, fontSize: (isTablet(context))?screenWidth* 0.034:screenWidth* 0.039),
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                errorStyle: TextStyle(color: Colors.red),
                contentPadding: EdgeInsets.only(left: screenWidth*0.04,right: screenWidth*0.01,top: screenHeight*0.025,bottom: screenHeight*0.025),
                labelText: "Email",
                labelStyle: GoogleFonts.lato(
                    textStyle:TextStyle(
                      color: Color(0xFF505050),
                      fontSize: (isTablet(context))?screenWidth* 0.038:screenWidth* 0.045,
                      // fontWeight: themeNotifier.isDarkTheme? FontWeight.normal:FontWeight.bold
                    )),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 1.5,
                    color: Color(0xFF505050),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 1.5,
                    color: Color(0xFF505050),
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
            SizedBox(height: screenHeight*0.04,),
            GestureDetector(
              onTap: () async {
                if(!submitPressed){
                    if(validateField()){
                      setState(() {
                        submitPressed=true;
                      });
                      if(await checkIfAccountExist(emailController.text.trim())){
                        sendPasswordResetEmail();
                      }else{
                        setState(() {
                          submitPressed=false;
                        });
                        Fluttertoast.showToast(
                          fontSize: (isTablet(context))?22:13,
                          msg: "Oops! It seems there's no account registered with this email.",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red, // Change this to your desired background color
                          textColor: Colors.white,
                        );
                      }
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
                  child: submitPressed?Padding(
                    padding:  EdgeInsets.symmetric(vertical:  screenHeight*0.019),
                    child: LoadingIndicator(
                      indicatorType: Indicator. lineScaleParty, /// Required, The loading type of the widget
                      colors: const [Colors.white],       /// Optional, The color collections
                      strokeWidth: 1,              /// Optional, the stroke backgroundColor
                    ),
                  ):Text('Submit',style: TextStyle(fontSize: (isTablet(context))?screenWidth* 0.036:screenWidth* 0.044, color: Colors.white,fontWeight: FontWeight.bold),),
                ),

              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Image.asset('assets/images/backgrounds/bg3.jpg',width: double.infinity,),
    );
  }
  bool _isValidEmail(String email) {
    final RegExp emailRegex = RegExp(
      r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
    );
    return emailRegex.hasMatch(email);
  }

  bool validateField(){
    if(emailController.text.isNotEmpty){
      if(_isValidEmail(emailController.text.trim())){
        return true;
      }
      else{
        Fluttertoast.showToast(
          fontSize: (isTablet(context))?22:13,
          msg: "Invalid email.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red, // Change this to your desired background color
          textColor: Colors.white,
        );
        return false;
      }
    }
    else{
      Fluttertoast.showToast(
        fontSize: (isTablet(context))?22:13,
        msg: "Please provide the email to reset password.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red, // Change this to your desired background color
        textColor: Colors.white,
      );

      return false;
    }
  }

  Future<bool> checkIfAccountExist(String email) async{
    CollectionReference usersCollection = FirebaseFirestore.instance.collection('UserInfo');

    QuerySnapshot querySnapshot = await usersCollection.where('email', isEqualTo: email).get();

    if (querySnapshot.docs.isNotEmpty) {

      print('Email exists in the collection.');
      return true;

    } else {

      print('No document found with the provided email.');
      return false;
    }
  }

  void sendPasswordResetEmail(){
    try{
      final FirebaseAuth auth = FirebaseAuth.instance;
      auth.sendPasswordResetEmail(email: emailController.text.trim());

      Fluttertoast.showToast(
        fontSize: (isTablet(context))?22:13,
        msg: "A password reset email has been sent to you.",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey[300],
        textColor:Colors.black,
      );
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/LoginPage',
            (route) => false,
      );

    }on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(
        fontSize: (isTablet(context))?22:13,
        msg: '${e.message}',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey[300],
        textColor:Colors.black,
      );
      setState(() {
        submitPressed=false;
      });
    }

  }

  bool isTablet(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return screenWidth >= 600 && screenWidth <= 1024;
  }

}
