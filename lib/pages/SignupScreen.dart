import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/pages/skinTypeSelection.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import '../SplashScreen.dart';
import '../providers/userDataProvider.dart';
import 'LoginScreen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupscreenState();
}

class _SignupscreenState extends State<SignupScreen> {
  bool registerPressed=false;
  bool termsAccepted=false;
  bool passwordVisibility=true;
  String dropdownValue="Male";
  TextEditingController _dateController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _weightController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  bool hasConnection = true;

  @override
  void initState() {
    super.initState();
    checkConnection();
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (selectedDate != null) {
      setState(() {
        _dateController.text = "${selectedDate.toLocal()}".split(' ')[0];
      });
      FocusScope.of(context).unfocus();
    }
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
          "Create an account",
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
            padding: EdgeInsets.symmetric(horizontal: (isTablet(context))?screenWidth*0.15:screenWidth*0.15),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: (isTablet(context))?screenHeight*0.06:screenHeight*0.02,),
                  TextFormField(
                    controller: _nameController,
                    cursorColor: Colors.black54,
                    cursorWidth: 1.5,
                    style: TextStyle(color: Colors.black87, fontSize: (isTablet(context))?screenWidth* 0.032:screenWidth* 0.039,//(isTablet(context))?23:15
                    ),
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      errorStyle: TextStyle(color: Colors.red),
                      contentPadding: EdgeInsets.only(left: screenWidth*0.03,right: screenWidth*0.03,top: (isTablet(context))?screenHeight*0.003:screenHeight*0.015),
                      hintText: "Name",
                      hintStyle: TextStyle(
    fontFamily: 'Lato',
                            color: Colors.black54,
                            fontSize: (isTablet(context))?screenWidth* 0.034:screenWidth* 0.041,//(isTablet(context))?23:16,
                          ),
                      enabledBorder: UnderlineInputBorder(
                        //borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          width: 1.5,
                          color: Colors.grey,
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        //borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          width: 1.5,
                          color: Colors.black54,
                        ),
                      ),

                      prefixIcon: Padding(
                        padding:  EdgeInsets.only(right: (isTablet(context))?screenWidth* 0.015:0),
                        child: Icon(Icons.account_box_outlined,size: (isTablet(context))?screenWidth* 0.048:screenWidth* 0.06,//(isTablet(context))?34:24,
                            color: Colors.grey),
                      )
                    ),
                  ),
                  SizedBox(height: (isTablet(context))?screenHeight*0.018:screenHeight*0.012,),
                  TextFormField(
                    controller: _ageController,
                    cursorColor: Colors.black54,
                    cursorWidth: 1.5,
                    style: TextStyle(color: Colors.black87, fontSize: (isTablet(context))?screenWidth* 0.032:screenWidth* 0.039,//(isTablet(context))?23:15
                    ),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        errorStyle: TextStyle(color: Colors.red),
                        contentPadding: EdgeInsets.only(left: screenWidth*0.03,right: screenWidth*0.03,top: (isTablet(context))?screenHeight*0.003:screenHeight*0.015),
                        hintText: "Age",
                        hintStyle: TextStyle(
    fontFamily: 'Lato',
                              color: Colors.black54,
                              fontSize: (isTablet(context))?screenWidth* 0.034:screenWidth* 0.041,//(isTablet(context))?23:16,
                            ),
                        enabledBorder: UnderlineInputBorder(
                          //borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            width: 1.5,
                            color: Colors.grey,
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          //borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            width: 1.5,
                            color: Colors.black54,
                          ),
                        ),

                        prefixIcon: Padding(
                          padding:  EdgeInsets.only(right: (isTablet(context))?screenWidth* 0.015:0),
                          child: Icon(Icons.badge_outlined,size: (isTablet(context))?screenWidth* 0.048:screenWidth* 0.06,//(isTablet(context))?34:24,
                              color: Colors.grey),
                        )
                    ),
                  ),
                  SizedBox(height: (isTablet(context))?screenHeight*0.018:screenHeight*0.012,),
                  Row(
                    children: [
                      SizedBox(width: screenWidth*0.03),
                      Text(
                        "Gender:  ",
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: (isTablet(context))?screenWidth* 0.036:screenWidth* 0.043,//(isTablet(context))?24:17,
                        ),
                      ),
                      SizedBox(width: screenWidth*0.03),
                      DropdownButton<String>(
                        value: dropdownValue,
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownValue = newValue!;
                          });
                        },
                        dropdownColor: Colors.grey[300],
                        style: TextStyle(
                          color:  Colors.black87,
                          fontSize: (isTablet(context))?screenWidth* 0.032:screenWidth* 0.039,//(isTablet(context))?23:15,
                        ),
                        underline: Container(
                          height: 2,
                          color:Colors.grey,
                        ),
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: Colors.black54,
                        ),
                        items: <String>['Male','Female']
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
                  SizedBox(height: (isTablet(context))?screenHeight*0.018:screenHeight*0.012,),
                  TextFormField(
                    controller: _dateController,
                    readOnly: true,
                    style: TextStyle(color: Colors.black87, fontSize: (isTablet(context))?screenWidth* 0.032:screenWidth* 0.039,//(isTablet(context))?23:15
                    ),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(left: screenWidth*0.03,right: screenWidth*0.03,top: (isTablet(context))?screenHeight*0.003:screenHeight*0.016),
                        hintText: 'Date of Birth',
                        hintStyle: TextStyle(
    fontFamily: 'Lato',
                              color: Colors.black54,
                              fontSize: (isTablet(context))?screenWidth* 0.034:screenWidth* 0.041,//(isTablet(context))?23:16,
                              // fontWeight: themeNotifier.isDarkTheme? FontWeight.normal:FontWeight.bold
                            ),
                        focusedErrorBorder: UnderlineInputBorder(
                          // borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            width: 1.5,
                            color: Colors.black54,
                          ),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          //borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            width: 1.5,
                            color: Colors.grey,
                          ),
                        ),
                        prefixIcon: Padding(
                          padding:  EdgeInsets.only(right: (isTablet(context))?screenWidth* 0.015:0),
                          child: Icon(Icons.calendar_month,color: Colors.grey,size: (isTablet(context))?screenWidth* 0.048:screenWidth* 0.06,),
                        )//(isTablet(context))?34:24,)
                    ),

                    onTap: () => _selectDate(context),
                  ),
                  SizedBox(height: (isTablet(context))?screenHeight*0.018:screenHeight*0.012,),
                  TextFormField(
                    controller: _weightController,
                    cursorColor: Colors.black54,
                    cursorWidth: 1.5,
                    inputFormatters: [LengthLimitingTextInputFormatter(3),],
                    style: TextStyle(color: Colors.black87, fontSize: (isTablet(context))?screenWidth* 0.032:screenWidth* 0.039,),//(isTablet(context))?23:15),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        errorStyle: TextStyle(color: Colors.red),
                        contentPadding: EdgeInsets.only(left: screenWidth*0.03,right: screenWidth*0.03,top: (isTablet(context))?screenHeight*0.003:screenHeight*0.013),
                        hintText: "Weight",
                        hintStyle: TextStyle(
                        fontFamily: 'Lato',
                              color: Colors.black54,
                              fontSize: (isTablet(context))?screenWidth* 0.034:screenWidth* 0.041,//(isTablet(context))?23:16,
                              // fontWeight: themeNotifier.isDarkTheme? FontWeight.normal:FontWeight.bold
                            ),
                        enabledBorder: UnderlineInputBorder(
                          //borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            width: 1.5,
                            color: Colors.grey,
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          //borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            width: 1.5,
                            color: Colors.black54,
                          ),
                        ),

                        prefixIcon: Padding(
                          padding: EdgeInsets.only(right: (isTablet(context))?screenWidth* 0.015:0),
                          child: Icon(Icons.monitor_weight_outlined,size: (isTablet(context))?screenWidth* 0.048:screenWidth* 0.06,//(isTablet(context))?32:24,
                            color: Colors.grey,),
                        ),
                      suffixText: "KG",
                      suffixStyle: TextStyle(
                        color: Colors.orange,
                        fontSize: (isTablet(context))?screenWidth* 0.038:screenWidth* 0.047,//18,
                      ),
                    ),
                  ),
                  SizedBox(height: (isTablet(context))?screenHeight*0.018:screenHeight*0.012,),
                  TextFormField(
                    controller: _emailController,
                    cursorColor: Colors.black54,
                    cursorWidth: 1.5,
                    //inputFormatters: [LengthLimitingTextInputFormatter(13),],
                    style: TextStyle(color: Colors.black87, fontSize: (isTablet(context))?screenWidth* 0.032:screenWidth* 0.039,),//(isTablet(context))?23:15),
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        errorStyle: TextStyle(color: Colors.red),
                        contentPadding: EdgeInsets.only(left: screenWidth*0.03,right: screenWidth*0.03,top: (isTablet(context))?screenHeight*0.003:screenHeight*0.015),
                        hintText: "Email",
                        hintStyle: TextStyle(
                          fontFamily: 'Lato',
                              color: Colors.black54,
                              fontSize: (isTablet(context))?screenWidth* 0.034:screenWidth* 0.041,//(isTablet(context))?23:16,
                            ),
                        enabledBorder: UnderlineInputBorder(
                          //borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            width: 1.5,
                            color: Colors.grey,
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          //borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            width: 1.5,
                            color: Colors.black54,
                          ),
                        ),

                        prefixIcon: Padding(
                          padding:  EdgeInsets.only(right: (isTablet(context))?screenWidth* 0.015:0),
                          child: Icon(Icons.email_outlined,size: (isTablet(context))?screenWidth* 0.048:screenWidth* 0.06//(isTablet(context))?32:24
                              ,color: Colors.grey),
                        )
                    ),

                  ),
                  SizedBox(height: (isTablet(context))?screenHeight*0.018:screenHeight*0.012,),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: passwordVisibility,
                    cursorColor: Colors.black54,
                    cursorWidth: 1.5,
                    //inputFormatters: [LengthLimitingTextInputFormatter(13),],
                    style: TextStyle(color: Colors.black87, fontSize: (isTablet(context))?screenWidth* 0.032:screenWidth* 0.039,),//(isTablet(context))?23:15),
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        errorStyle: TextStyle(color: Colors.red),
                        contentPadding: EdgeInsets.only(left: screenWidth*0.03,right: screenWidth*0.03,top: (isTablet(context))?screenHeight*0.003:screenHeight*0.015),
                        hintText: "Password",
                        hintStyle: TextStyle(
    fontFamily: 'Lato',
                              color: Colors.black54,
                              fontSize: (isTablet(context))?screenWidth* 0.034:screenWidth* 0.041,//(isTablet(context))?23:16,
                              // fontWeight: themeNotifier.isDarkTheme? FontWeight.normal:FontWeight.bold
                            ),
                        enabledBorder: UnderlineInputBorder(
                          //borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            width: 1.5,
                            color: Colors.grey,
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          //borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            width: 1.5,
                            color: Colors.black54,
                          ),
                        ),
                        prefixIcon: Padding(
                          padding:  EdgeInsets.only(right: (isTablet(context))?screenWidth* 0.015:0),
                          child: Icon(Icons.lock_outline,size: (isTablet(context))?screenWidth* 0.048:screenWidth* 0.06,//(isTablet(context))?32:24,
                              color: Colors.grey),
                        ),
                        suffixIcon: IconButton(
                        onPressed: (){
                  setState(() {
                  passwordVisibility=!passwordVisibility;
                  });
                  },
                    icon: Icon(passwordVisibility?Icons.visibility_off:Icons.visibility,color: Colors.grey,size: (isTablet(context))?screenWidth* 0.04:screenWidth* 0.052,),//(isTablet(context))?28:21,),
                  )
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Name cannot be Empty";
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {});
                    },
                  ),
                  SizedBox(height: (isTablet(context))?screenHeight*0.035:screenHeight*0.01,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Transform.scale(
                        scale: (isTablet(context)) ? 1.33 : 0.9,
                        child: Checkbox(
                          value: termsAccepted,
                          checkColor: Colors.white,
                          activeColor: Colors.orange,
                          side: BorderSide(color: Colors.black54, width: 2),
                          onChanged: (bool? value) {
                            setState(() {
                              termsAccepted = value!;
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            SizedBox(height: (isTablet(context)) ? screenHeight*0.007 : screenHeight*0.01,),
                            RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  fontFamily: 'Lato',
                                    color: Colors.black54,
                                    fontSize: (isTablet(context)) ? screenHeight*0.02 :screenWidth* 0.033,//(isTablet(context)) ? 20 : 13,
                                ),
                                children: [
                                  TextSpan(text: 'By continuing you accept our '),
                                  TextSpan(
                                    text: 'Privacy Policy',
                                    style: TextStyle(
    fontFamily: 'Lato',
                                        color: Colors.black54,
                                        fontSize: (isTablet(context)) ? screenHeight*0.02:screenWidth* 0.033,//(isTablet(context)) ? 20 : 13,
                                        decoration: TextDecoration.underline,
                                        decorationColor: Colors.black54,
                                    ),
                                  ),
                                  TextSpan(text: ' and ',style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: (isTablet(context)) ? screenHeight*0.02:screenWidth* 0.033,//(isTablet(context)) ? 20 : 13,
                                  )),
                                  TextSpan(
                                    text: 'Terms of Use',
                                    style: TextStyle(
    fontFamily: 'Lato',
                                        color: Colors.black54,
                                        fontSize: (isTablet(context)) ? screenHeight*0.02:screenWidth* 0.033,//(isTablet(context)) ? 20 : 13,
                                        decoration: TextDecoration.underline,
                                        decorationColor: Colors.black54,

                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: (isTablet(context))?screenHeight*0.04:screenHeight*0.035,),
                  GestureDetector(
                    onTap: () async{
                      if(!registerPressed){
                        if(_validateFields()){
                          await checkConnection();
                          print("----------has Connection: ${hasConnection} -------------");
                          if(hasConnection){
                            setState(() {
                              registerPressed= true;
                            });
                            _register();
                          }
                        }
                      }
                    },
                    child: Container(
                      height: screenHeight*0.06,
                      width: screenWidth*0.4,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFFFCC54E), Color(0xFFFDA34F)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(50.0), // Rounded corners
                      ),
                      child: Center(
                        child: registerPressed?Padding(
                          padding:  EdgeInsets.symmetric(vertical:  screenHeight*0.019),
                          child: LoadingIndicator(
                            indicatorType: Indicator. lineScaleParty,
                            colors: const [Colors.white],
                            strokeWidth: 1,
                          ),
                        ):Text('Register',style: TextStyle(fontSize: (isTablet(context))?screenWidth* 0.037:screenWidth* 0.042,//(isTablet(context))?24:16,
                           color: Colors.white,fontWeight: FontWeight.bold),),
                      ),

                    ),
                  ),
                  SizedBox(height: screenHeight*0.005,),

                ],
              ),
            ),
          ),
          !hasConnection?
          Container(
          height: double.infinity,
              width: double.infinity,
              color: Colors.white24,

          ):Container(),
          !hasConnection
              ? Padding(
            padding: EdgeInsets.only(top: isTablet(context)?screenHeight*0.1:0,left: isTablet(context)?screenWidth*0.05:0,right: isTablet(context)?screenWidth*0.05:0),
            child: Center(
                child: AlertDialog(
                  title: Text(
                    "No Internet Available",
                    style: TextStyle(
                      fontFamily: 'BrunoAceSC',
                        color: Colors.black,
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
    fontFamily: 'Raleway',
                            color: Colors.black,
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
                          fontFamily: 'BrunoAceSC',
                            color: Colors.black,
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
    fontFamily: 'BrunoAceSC',
                            color: Colors.black,
                            fontSize: (isTablet(context))?screenWidth*0.038:screenWidth*0.04,
                            //fontWeight: FontWeight.bold,
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
     bottomNavigationBar: Image.asset('assets/images/backgrounds/bg3.jpg',width: double.infinity,),
    );
  }

  bool isTablet(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return screenWidth >= 600 && screenWidth <= 1024;
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

    if(_emailController.text.isNotEmpty && _ageController.text.isNotEmpty && _passwordController.text.isNotEmpty && _dateController.text.isNotEmpty && _weightController.text.isNotEmpty && _nameController.text.isNotEmpty) {
      if (int.parse(_ageController.text.trim()) > 0) {
        if(int.parse(_weightController.text.trim()) > 0){
          if (_isValidEmail(_emailController.text.trim())) {
            if (termsAccepted) {
              return true;
            }
            else {
              Fluttertoast.showToast(
                fontSize: (isTablet(context))?screenWidth*0.03:screenWidth*0.035,
                msg: "Please accept the terms and conditions to proceed.",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                // Change this to your desired background color
                textColor: Colors.white,
              );
              return false;
            }
          } else {
            Fluttertoast.showToast(
              fontSize: (isTablet(context))?screenWidth*0.03:screenWidth*0.035,
              msg: "The provided email is invalid.",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              // Change this to your desired background color
              textColor: Colors.white,
            );
            _emailController.text = "";
            return false;
          }
        }else{
          Fluttertoast.showToast(
            fontSize: (isTablet(context))?screenWidth*0.03:screenWidth*0.035,
            msg: "Invalid Weight",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            // Change this to your desired background color
            textColor: Colors.white,
          );
          return false;
        }
      }
      else {
        Fluttertoast.showToast(
          fontSize: (isTablet(context))?screenWidth*0.03:screenWidth*0.035,
          msg: "Invalid Age",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          // Change this to your desired background color
          textColor: Colors.white,
        );
        return false;
      }
    }
    else{
      Fluttertoast.showToast(
        fontSize: (isTablet(context))?screenWidth*0.03:screenWidth*0.035,
        msg: "Please fill in all required fields to continue.",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red, // Change this to your desired background color
        textColor: Colors.white,
      );

      return false;
    }
  }

  void _register() async{
    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;

    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      final user = userCredential.user;
      if(user != null){
        await FirebaseFirestore.instance.collection('UserInfo').add({
          'uid': user.uid,
          'email': _emailController.text.trim(),
          'age': int.parse(_ageController.text.trim()),
          'name': _nameController.text.trim(),
          'gender': dropdownValue,
          'date_of_birth':_dateController.text.trim(),
          'weight': int.parse(_weightController.text.trim()),
          'sessionID':"none",
          'skinType':0,
          'test date':'',
          'test value':0,
          'pills':''

        });
        final loginData = Provider.of<UserDataNotifier>(context, listen: false);

        loginData.email=_emailController.text.trim();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool(SplashScreenState.keyLogin, true);
        await prefs.setString('email', _emailController.text.trim());
        await prefs.setString('uid', userCredential.user!.uid);
        loginData.uid=userCredential.user!.uid;
        loginData.fetchUserData(userCredential.user!.uid);
        setState(() {
          registerPressed=false;
        });
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SkinType()),
        );
      }

    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(
        fontSize: (isTablet(context))?screenWidth*0.03:screenWidth*0.035,
        msg: "-----${e.message}",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      print("${e.message}");
      setState(() {
        registerPressed=false;
      });
    } catch (e) {
      print("${e.toString()}");
      Fluttertoast.showToast(
        fontSize: (isTablet(context))?screenWidth*0.03:screenWidth*0.035,
        msg: "${e.toString()}",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      setState(() {
        registerPressed=false;
      });
    }
  }

  Future<void> checkConnection() async {
    print("-------Inside check connection method---------");
    var result = await InternetConnectionChecker().hasConnection;
    if (mounted) {
      setState(() {

        print("----------Connection being checked: ${hasConnection} -------------");
        hasConnection = result;
      });
    }
  }


}
