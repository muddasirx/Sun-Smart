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
import '../../SplashScreen.dart';
import '../../providers/sessionDetailsProvider.dart';
import '../../providers/userDataProvider.dart';
import '../LoginScreen.dart';

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({super.key});

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  bool updatePressed=false;
  String dropdownValue="Male";
  TextEditingController _dateController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _weightController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  bool hasConnection = true;
  bool dataFetched=false;

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
    final userData = Provider.of<UserDataNotifier>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black87,
          size: (isTablet(context)) ? screenWidth * 0.046 : screenWidth * 0.06, //(isTablet(context))?30:23
        ),
        centerTitle: true,
        title: Text(
          "Update Profile",
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'BrunoAceSC', // Correctly specify the font family here
            //fontWeight: FontWeight.bold, // Use an appropriate weight for the font
            fontSize: (isTablet(context)) ? screenWidth * 0.038 : screenWidth * 0.051, //(isTablet(context))?27:20,
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
                              color: Colors.black54,
                              fontFamily: 'Lato',
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
                              color: Colors.black54,
                              fontFamily: 'Lato',
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
                  SizedBox(height: screenHeight*0.06,),
                  InkWell(
                    splashFactory: NoSplash.splashFactory,
                    onTap: () async{
                      if(!updatePressed){
                        if(_validateFields()) {
                          await checkConnection();
                          print("-----connection : $hasConnection------");
                          if(hasConnection){
                            print("--------------inside update method-------------");
                            setState(() {
                              updatePressed=true;
                            });
                            if(userData.updateProfile){
                              userData.updateProfile=false;
                            }
                            userData.updateSkinType(userData.skinType);
                            updateData();
                            Navigator.pop(context);
                            Navigator.pop(context);
                            Fluttertoast.showToast(
                              fontSize: (isTablet(context))?screenWidth*0.03:screenWidth*0.035,
                              msg: "Profile updated successfully.",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.grey[300],
                              textColor: Colors.black,
                            );
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
                        child: updatePressed?Padding(
                          padding:  EdgeInsets.symmetric(vertical:  screenHeight*0.019),
                          child: LoadingIndicator(
                            indicatorType: Indicator. lineScaleParty,
                            colors: const [Colors.white],
                            strokeWidth: 1,
                          ),
                        ):Text('Update',style: TextStyle(fontSize: (isTablet(context))?screenWidth* 0.037:screenWidth* 0.042,//(isTablet(context))?24:16,
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
            )
          :Container(),
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
    final userData = Provider.of<UserDataNotifier>(context, listen: false);

    if(_ageController.text.isNotEmpty && _dateController.text.isNotEmpty && _weightController.text.isNotEmpty && _nameController.text.isNotEmpty) {
      if(userData.user['skinType']!=userData.skinType || _nameController.text.trim()!=userData.user['name'] || dropdownValue!=userData.user['gender'] || _ageController.text.trim()!=userData.user['age'].toString() || _weightController.text.trim()!=userData.user['weight'].toString()){
        if (int.parse(_ageController.text.trim()) != 0) {
          return true;
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
      }else{
        Fluttertoast.showToast(
          fontSize: (isTablet(context))?screenWidth*0.03:screenWidth*0.035,
          msg: "No changes were made.",
          toastLength: Toast.LENGTH_LONG,
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
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red, // Change this to your desired background color
        textColor: Colors.white,
      );

      return false;
    }
  }

  Future<void> updateData() async{
    final userData = Provider.of<UserDataNotifier>(context, listen: false);
    CollectionReference userCollection = FirebaseFirestore.instance.collection('UserInfo');

    try {
      print(userData.uid);
      QuerySnapshot querySnapshot = await userCollection.where('uid', isEqualTo: userData.uid).get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentReference userDoc = querySnapshot.docs.first.reference;

        await userDoc.update({
          'age': int.parse(_ageController.text.trim()),
          'name': _nameController.text.trim(),
          'gender': dropdownValue,
          'date_of_birth':_dateController.text.trim(),
          'weight': int.parse(_weightController.text.trim()),
        });

        userData.fetchUserData(userData.uid);

        print('User info updated successfully');
      } else {
        print('No user found with the provided userID');
      }
    } catch (e) {
      print('Error updating user info: $e');
    }
  }

  Future<void> checkConnection() async {
    print("-------inside checking method-------");
    var result = await InternetConnectionChecker().hasConnection;
    if (mounted) {
      if(result && !dataFetched){
        fetchData();
        dataFetched=true;
      }
      setState(() {
        hasConnection = result;
      });
    }
  }

  void fetchData(){
    final userData = Provider.of<UserDataNotifier>(context, listen: false);
    final sessionDetails = Provider.of<sessionDetailsNotifier>(context, listen: false);
    dropdownValue=userData.user['gender'];
    _nameController.text=userData.user['name'];
    print("checking age");
    _ageController.text=userData.user['age'].toString();
    _dateController.text=userData.user['date_of_birth'];
    _weightController.text=userData.user['weight'].toString();

  }
  
}
