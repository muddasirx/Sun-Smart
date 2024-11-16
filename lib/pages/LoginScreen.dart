
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/pages/graphScreen.dart';
import 'package:untitled/pages/skinTypeSelection.dart';
import 'package:untitled/pages/spf.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../SplashScreen.dart';
import '../providers/sessionDetailsProvider.dart';
import '../providers/userDataProvider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  FocusNode emailFocusNode= FocusNode();
  FocusNode passwordFocusNode= FocusNode();
  bool emailFocused=false;
  bool passwordFocused=false;
  bool passwordVisibility=true;
  bool loginPressed=false;
  bool hasConnection = true;

  @override
  void initState() {
    super.initState();
    checkConnection();
    emailFocusNode.addListener(() {
      setState(() {
        emailFocused = emailFocusNode.hasFocus;
      });
    });
    passwordFocusNode.addListener(() {
      setState(() {
        passwordFocused = passwordFocusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    passwordFocusNode.dispose();
    emailFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;

    return Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              SingleChildScrollView(
                            child: Padding(
                              padding:  EdgeInsets.symmetric(horizontal: (isTablet(context))?screenWidth*0.15:screenWidth*0.1),
                              child: Column(
                                children: [
                                  SizedBox(height: screenHeight*0.02),
                                  Image.asset('assets/images/login.png',height: (isTablet(context))?screenHeight*0.29:0.27*screenHeight),
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [BoxShadow(
                                            color: emailFocused?Color(0xFFFD8C23): Colors.black54,
                                            blurRadius: emailFocused?20:20,
                                            offset: emailFocused?Offset(0,5):Offset(0, 10),
                                            spreadRadius: 3
                                        )]
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.only(left: (isTablet(context))?screenWidth* 0.01:0),
                                      child: TextFormField(
                                        controller: emailController,
                                        focusNode: emailFocusNode,
                                        cursorColor: Colors.grey,
                                        cursorWidth: 1.5,
                                        style: TextStyle(color: Colors.black, fontSize: (isTablet(context))?screenWidth* 0.034:screenWidth* 0.039,//(isTablet(context))?23:15
                                        ),
                                        keyboardType: TextInputType.emailAddress,
                                        decoration: InputDecoration(
                                            errorStyle: TextStyle(color: Colors.red),
                                            contentPadding: EdgeInsets.only(left: screenWidth*0.02,right: screenWidth*0.04,top: screenHeight*0.023,bottom: screenHeight*0.023),
                                            hintText: "Email",
                                            hintStyle: GoogleFonts.lato(
                                                textStyle:TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: (isTablet(context))?screenWidth* 0.038:screenWidth* 0.045,//(isTablet(context))?25:17,
                                                  // fontWeight: themeNotifier.isDarkTheme? FontWeight.normal:FontWeight.bold
                                                )),
                                            border: InputBorder.none,
                                            prefixIcon: Padding(
                                              padding:  EdgeInsets.only(right: (isTablet(context))?screenWidth* 0.015:0),
                                              child: Icon(Icons.email_outlined,size: (isTablet(context))?screenWidth* 0.055:screenWidth* 0.06,//(isTablet(context))?34:24,
                                                color: Colors.grey,),
                                            )
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "Email cannot be Empty";
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: screenHeight*0.02,),
                                  Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(10),
                                          boxShadow: [BoxShadow(
                                              color: passwordFocused?Color(0xFFFD8C23): Colors.black54,
                                              blurRadius: passwordFocused?20:20,
                                              offset: passwordFocused?Offset(0,5):Offset(0, 10),
                                              spreadRadius: 3
                                          )]
                                      ),
                                      child: Padding(
                                        padding:  EdgeInsets.only(left: screenWidth* 0.01),
                                        child: TextFormField(
                                          controller: passwordController,
                                          focusNode: passwordFocusNode,
                                          cursorColor: Colors.grey,
                                          cursorWidth: 1.5,
                                          style: TextStyle(color: Colors.black, fontSize: (isTablet(context))?screenWidth* 0.034:screenWidth* 0.039,//(isTablet(context))?23:15
                                          ),
                                          keyboardType: TextInputType.text,
                                          obscureText: passwordVisibility,
                                          decoration: InputDecoration(
                                              errorStyle: TextStyle(color: Colors.red),
                                              contentPadding: EdgeInsets.only(left: screenWidth*0.020,right: screenWidth*0.07,top: screenHeight*0.023,bottom: screenHeight*0.023),
                                              hintText: "Password",
                                              hintStyle: GoogleFonts.lato(
                                                  textStyle:TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: (isTablet(context))?screenWidth* 0.038:screenWidth* 0.045,//(isTablet(context))?25:17,
                                                    // fontWeight: themeNotifier.isDarkTheme? FontWeight.normal:FontWeight.bold
                                                  )),
                                              border: InputBorder.none,
                                              prefixIcon: Padding(
                                                padding: EdgeInsets.only(right: (isTablet(context))?screenWidth* 0.015:0),
                                                child: Icon(Icons.lock_outline,size: (isTablet(context))?screenWidth* 0.055:screenWidth* 0.06,//(isTablet(context))?34:24,
                                                  color: Colors.grey,),
                                              ),
                                              suffixIcon: IconButton(
                                                onPressed: (){
                                                  setState(() {
                                                    passwordVisibility=!passwordVisibility;
                                                  });
                                                },
                                                icon: Icon(passwordVisibility?Icons.visibility_off:Icons.visibility,color: Colors.grey,size: (isTablet(context))?screenWidth* 0.048:screenWidth* 0.056,//(isTablet(context))?30:22,
                                                ),
                                              )
                                          ),
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return "Password cannot be Empty";
                                            }
                                            return null;
                                          },
                                        ),
                                      )
          
                                  ),
                                  SizedBox(height: screenHeight*0.025,),
                                  InkWell(
                                    onTap: (){
                                      if(!loginPressed){
                                          Navigator.pushNamed(context, '/forgotPassword');
                                      }
                                    },
                                    child: Text(
                                        "Forgot password?",
                                        style: GoogleFonts.raleway(
                                          textStyle: TextStyle(
                                            color: Colors.black54,
                                            fontSize: (isTablet(context))?screenWidth* 0.032:screenWidth* 0.0407,//(isTablet(context))?22:16,
                                          ),
                                        ),
                                      ),
                                  ),
                                  SizedBox(height: screenHeight*0.03,),
                                  GestureDetector(
                                    onTap: () async {
                                      if(!loginPressed){
                                        if(_validateFields()){
                                          setState(() {
                                            loginPressed=true;
                                          });
                                          if(await _checkLogin()){
          
                                            final loginData = Provider.of<UserDataNotifier>(context, listen: false);
                                            if(loginData.user['skinType']!=0){
                                              if(loginData.user['sessionID']!='none'){
                                                Navigator.pushAndRemoveUntil(
                                                  context,
                                                  MaterialPageRoute(builder: (context) => GraphScreen()),
                                                      (route) => false,
                                                );
                                              }else{
                                                Navigator.pushAndRemoveUntil(
                                                  context,
                                                  MaterialPageRoute(builder: (context) => Spf()),
                                                      (route) => false,
                                                );
                                              }
                                            }
                                            else {
                                              print("move to skin type");
                                                Navigator.pushAndRemoveUntil(
                                                  context,
                                                  MaterialPageRoute(builder: (context) => SkinType()),
                                                      (route) => false,
                                                );
                                              }
                                            setState(() {
                                              loginPressed=false;
                                            });
                                          }else{
                                            setState(() {
                                              loginPressed=false;
                                            });
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
                                        child: loginPressed?Padding(
                                          padding:  EdgeInsets.symmetric(vertical:  screenHeight*0.019),
                                          child: LoadingIndicator(
                                            indicatorType: Indicator. lineScaleParty, /// Required, The loading type of the widget
                                            colors: const [Colors.white],       /// Optional, The color collections
                                            strokeWidth: 1,              /// Optional, the stroke backgroundColor
                                          ),
                                        ):Text('Login',style: TextStyle(fontSize: (isTablet(context))?screenWidth* 0.041:screenWidth* 0.047,//(isTablet(context))?26:18
                                             color: Colors.white,fontWeight: FontWeight.bold),),
                                      ),
          
                                    ),
                                  ),
                                  SizedBox(height: screenHeight*0.04,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Don't have an account? ",
                                        style: GoogleFonts.raleway(
                                          textStyle: TextStyle(
                                            color: Colors.black54,
                                            fontSize: (isTablet(context))?screenWidth* 0.032:screenWidth* 0.0407//(isTablet(context))?22:16,
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: (){
                                            if(!loginPressed){
                                              Navigator.pushNamed(context, "/Register");
                                              emailController.text="";
                                              passwordController.text="";
                                            }
                                        },
                                        child: Text(
                                          "Register",
                                          style: GoogleFonts.raleway(
                                            textStyle: TextStyle(
                                              color: Colors.orange,
                                              fontSize: (isTablet(context))?screenWidth* 0.032:screenWidth* 0.0407,//(isTablet(context))?22:16,
                                              fontWeight: FontWeight.bold
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
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
                padding: EdgeInsets.only(top: isTablet(context)?screenHeight*0.15:screenHeight*0.1,left: isTablet(context)?screenWidth*0.05:0,right: isTablet(context)?screenWidth*0.05:0),
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

  bool _validateFields(){
    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;

    if(emailController.text.isNotEmpty && passwordController.text.isNotEmpty)
    {
      if (_isValidEmail(emailController.text.trim())) {
         return true;

      } else {
        Fluttertoast.showToast(
          fontSize: (isTablet(context))?screenWidth*0.03:screenWidth*0.035,
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

  Future<bool> _checkLogin() async{
    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;
    print("inside Login check method");
    final credential;
    try{
      credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    }
    catch(e){
      Fluttertoast.showToast(
        fontSize: (isTablet(context))?screenWidth*0.03:screenWidth*0.035,
        msg: "Invalid email or password.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red, // Change this to your desired background color
        textColor: Colors.white,
      );
      print(e.toString());
      return false;
    }
    if(credential!=null){
      final sessionDetails = Provider.of<sessionDetailsNotifier>(context, listen: false);
      final loginData = Provider.of<UserDataNotifier>(context, listen: false);
      loginData.email=emailController.text.trim();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool(SplashScreenState.keyLogin, true);
      await prefs.setString('email', emailController.text.trim());
      await prefs.setString('uid', credential.user!.uid);
      loginData.uid=credential.user!.uid;
      print("user data fetched!");
      await loginData.fetchUserData(credential.user!.uid);
      print("fetching user session!");
      print("${loginData.user["name"]}");
      loginData.fetchUserSessions(loginData.user['sessionID']);
      print("checking session attended!");
      print("session id: "+loginData.user['sessionID'].toString());
      if(loginData.user['sessionID']!='none') {
        print("Session Id: ${loginData.user['sessionID']}");
        await loginData.fetchUserSessions(loginData.user['sessionID']);
        print("Calculating iu consumed today.");
        loginData.iuConsumedToday(sessionDetails);
        print(loginData.userSessions.toString());
      } else
        print("The user hasn't taken any session yet.");
      return true;
    }else
      return false;
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
