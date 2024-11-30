import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/pages/LoginScreen.dart';

import '../../SplashScreen.dart';
import '../../providers/adminPanelProvider.dart';

class UserAnalysis extends StatefulWidget {
  const UserAnalysis({super.key});

  @override
  State<UserAnalysis> createState() => _UserAnalysisState();
}

class _UserAnalysisState extends State<UserAnalysis> {
  bool logoutPressed=false;
  bool hasConnection = true;
  final List<String> menuItems = [
    'Manage Ads',
    'Update password',
    'Logout'
  ];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    checkConnection();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;
    final adminPanel = Provider.of<AdminPanelNotifier>(context, listen: false);

    return Scaffold(
      resizeToAvoidBottomInset: false,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Welcome Admin",
            style: TextStyle(
              fontFamily: 'BrunoAceSC',
              color: Colors.black,
              fontSize: (isTablet(context))?screenWidth* 0.038:screenWidth* 0.051,//(isTablet(context))?27:20,
              //fontWeight: FontWeight.bold,
            ),
          ),
          iconTheme: IconThemeData(
            color: Colors.black87,
            size: (isTablet(context)) ? screenWidth * 0.046 : screenWidth *
                0.06, //(isTablet(context))?30:23
          ),
          actions: [
            PopupMenuButton<String>(
              icon: Icon(Icons.more_vert, color: Colors.black),
              onSelected: (value) {
                // Handle menu item selection
                switch (value) {
                  case 'Manage Ads':
                  Navigator.pushNamed(context, "/ManageAds");
                    break;
                  case 'Update password':
                    Navigator.pushNamed(context, "/UpdatePassword" );
                    break;
                  case 'Logout':
                    setState(() {
                      logoutPressed=true;
                    });
                    break;
                }
              },
              itemBuilder: (BuildContext context) {
                return menuItems.map((item) {
                  if (item == 'Logout') {
                    return PopupMenuItem<String>(
                      value: item,
                      child: Row(
                        children: [
                          Icon(Icons.exit_to_app, color: Colors.grey,
                            size: isTablet(context)
                                ? screenWidth * 0.02
                                : screenWidth * 0.05,),
                          // Logout icon
                          SizedBox(width: screenWidth * 0.015),
                          // Add some spacing
                          Text(
                            item,
                            style: TextStyle(
                              fontFamily: 'Raleway',
                              color: Colors.black,
                              fontSize: (isTablet(context)) ? screenWidth *
                                  0.028 : screenWidth * 0.037,
                              //fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  } else {
                    return PopupMenuItem<String>(
                      value: item,
                      child: Text(
                        item,
                        style: TextStyle(
                          fontFamily: 'Raleway',
                          color: Colors.black,
                          fontSize: (isTablet(context))
                              ? screenWidth * 0.028
                              : screenWidth * 0.037,
                          //fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    );
                  }
                }).toList();
              },
              color: Color(0xFFDADADA),
              // Background color of the menu
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10), // Rounded corners
              ),
            ),
          ],

        ),

      body: Stack(
        children: [
          (hasConnection)?

      Consumer<AdminPanelNotifier>(
          builder: (context, value, child) {
            return (value.dataFetched)?
          Padding(
            padding:  EdgeInsets.symmetric(horizontal: screenWidth*0.07),
            child: Column(
              children: [
                SizedBox(height: screenHeight*0.05,),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: [BoxShadow(
                          color: Colors.black54,
                          blurRadius: 20,
                          offset: Offset(0, 8),
                      )]
                  ),
                  child: TextField(
                    controller: searchController,
                    cursorColor: Colors.grey,
                    decoration: InputDecoration(
                        hintText: "Search any user",
                        contentPadding:EdgeInsets.only(left:screenWidth*0.08,top: 18,bottom: 18,right:screenWidth*0.05),
                        hintStyle: TextStyle(
                            color: Colors.grey
                        ),
                        labelStyle: TextStyle(
                          fontFamily: 'Lato',
                          color: Colors.grey,
                          fontSize: (isTablet(context))?screenWidth* 0.038:screenWidth* 0.045,//(isTablet(context))?25:17,
                          // fontWeight: themeNotifier.isDarkTheme? FontWeight.normal:FontWeight.bold
                        ),
                        border: InputBorder.none,
                        suffixIcon: IconButton(icon:Icon(Icons.search),
                          color: Colors.black54,
                          onPressed: () {
                            if(searchController.text.isEmpty){
                            }
                            else{

                            }
                          },)
                    ),
                  ),
                ),
                SizedBox(height: screenHeight*0.1,),
                Text(
                  'Total Users',
                  style: TextStyle(
                    fontFamily: 'Raleway',
                    color: Colors.black,
                    fontSize: (isTablet(context))
                        ? screenWidth * 0.036
                        : screenWidth * 0.046,
                    //fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,),
                SizedBox(height: screenHeight*0.005,),
                Text(
                  value.totalUsers.toString(),
                  style: TextStyle(
                    fontFamily: 'BrunoAceSC',
                    color: Colors.cyan,
                    fontSize: (isTablet(context))
                        ? screenWidth * 0.05
                        : screenWidth * 0.06,
                    //fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,),
                SizedBox(height: screenHeight*0.05,),
                Text(
                  'Active Today',
                  style: TextStyle(
                    fontFamily: 'Raleway',
                    color: Colors.black,
                    fontSize: (isTablet(context))
                        ? screenWidth * 0.036
                        : screenWidth * 0.046,
                    //fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,),
                SizedBox(height: screenHeight*0.005,),
                Text(
                  value.activeUsersToday.toString(),
                  style: TextStyle(
                    fontFamily: 'BrunoAceSC',
                    color: Colors.cyan,
                    fontSize: (isTablet(context))
                        ? screenWidth * 0.05
                        : screenWidth * 0.06,
                    //fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,),

              ],
            ),
          )
              :Center(
              child: Padding(
                padding:  EdgeInsets.only(bottom: screenHeight*0.15),
                child: SizedBox(
                    height:isTablet(context)?60:40,
                    width: isTablet(context)?60:40,
                    child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.orangeAccent),strokeWidth: 3.5,)),
              )
          );})
              : SizedBox.shrink(),


          (!hasConnection || logoutPressed) ?
          Container(
            height: double.infinity,
            width: double.infinity,
            color: Colors.white38,

          ) : SizedBox.shrink(),

          !hasConnection
              ? Padding(
            padding: EdgeInsets.only(bottom: screenHeight * 0.1,
                left: isTablet(context) ? screenWidth * 0.05 : 0,
                right: isTablet(context) ? screenWidth * 0.05 : 0),
            child: Center(
                child: AlertDialog(
                  title: Text(
                    "No Internet Available",
                    style: TextStyle(
                      fontFamily: 'BrunoAceSC',
                      color: Colors.black,
                      fontSize: (isTablet(context))
                          ? screenWidth * 0.042
                          : screenWidth * 0.048,
                      //fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset('assets/images/noConnection.png',
                        height: screenHeight * 0.2,),
                      Text(
                        'You need an internet connection to proceed. Please check your connection and try again.',
                        style: TextStyle(
                          fontFamily: 'Raleway',
                          color: Colors.black,
                          fontSize: (isTablet(context))
                              ? screenWidth * 0.03
                              : screenWidth * 0.04,
                          //fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,),
                    ],
                  ),
                  backgroundColor: Theme
                      .of(context)
                      .colorScheme
                      .secondary,
                  actions: [
                    TextButton(
                      onPressed: () => SystemNavigator.pop(),
                      child: Text(
                        "Exit",
                        style: TextStyle(
                          fontFamily: 'BrunoAceSC',
                          color: Colors.black,
                          fontSize: (isTablet(context))
                              ? screenWidth * 0.038
                              : screenWidth * 0.04,
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
                      child: Text(
                        "Retry",
                        style: TextStyle(
                          fontFamily: 'BrunoAceSC',
                          color: Colors.black,
                          fontSize: (isTablet(context))
                              ? screenWidth * 0.038
                              : screenWidth * 0.04,
                          //fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],)
            ),
          )
              : SizedBox.shrink(),

          logoutPressed ?
          Padding(
            padding: EdgeInsets.only(bottom: screenHeight * 0.05,
                left: isTablet(context) ? screenWidth * 0.05 : 0,
                right: isTablet(context) ? screenWidth * 0.05 : 0),
            child: Center(
              child: AlertDialog(
                title: Text(
                  "Log out",
                  style: TextStyle(
                    fontFamily: 'BrunoAceSC',
                    color: Colors.black,
                    fontSize: (isTablet(context))
                        ? screenWidth * 0.05
                        : screenWidth * 0.055,
                    //fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/images/logout.png', height: screenHeight * 0.2,),
                    Text(
                      "Are you sure you want to logout?"
                      , style: TextStyle(
                      fontFamily: 'Raleway',
                      color: Colors.black,
                      fontSize: (isTablet(context))
                          ? screenWidth * 0.04
                          : screenWidth * 0.04,
                      //fontWeight: FontWeight.bold,
                    ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                backgroundColor: Theme
                    .of(context)
                    .colorScheme
                    .secondary,
                actions: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        logoutPressed = false;
                      });
                    },
                    child: Text(
                      "No",
                      style: TextStyle(
                        fontFamily: 'BrunoAceSC',
                        color: Colors.black,
                        fontSize: (isTablet(context))
                            ? screenWidth * 0.04
                            : screenWidth * 0.04,
                        //fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      SharedPreferences prefs = await SharedPreferences
                          .getInstance();
                      prefs.setBool(SplashScreenState.keyLogin, false);
                      prefs.setString('email', '');
                      prefs.setString('uid', '');
                      prefs.setBool('appSettings', false);
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                            (route) => false,
                      );
                    },
                    child: Text(
                      "Yes",
                      style: TextStyle(
                        fontFamily: 'BrunoAceSC',
                        color: Colors.black,
                        fontSize: (isTablet(context))
                            ? screenWidth * 0.04
                            : screenWidth * 0.04,
                        //fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                ],),
            ),
          ) : SizedBox.shrink(),
        ],
      ),
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
    var screenWidth = MediaQuery.of(context).size.width;
    return screenWidth >= 600 && screenWidth <= 1024;
  }

}
