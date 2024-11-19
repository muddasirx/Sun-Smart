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
import '../SplashScreen.dart';
import '../providers/historyProvider.dart';
import '../providers/sessionDetailsProvider.dart';
import '../providers/testResultsProvider.dart';
import '../providers/userDataProvider.dart';

class GraphScreen extends StatefulWidget {
  const GraphScreen({super.key});

  @override
  State<GraphScreen> createState() => _GraphScreenState();
}



class _GraphScreenState extends State<GraphScreen> {
  bool hasConnection = true;
  bool logoutPressed = false;
  bool yearPressed = false,
      monthPressed = false,
      weekPressed = true;
  String selectedRange = 'Week';
  DateTime currentDate = DateTime.now();
  DateTime rangeStart = DateTime.now();
  DateTime rangeEnd = DateTime.now();
  final List<String> menuItems = [
    'Update profile',
    'Update my history',
    'Logout'
  ];
  bool vitaminDIntakeComplete=false;

  @override
  void initState() {
    super.initState();
    checkConnection();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery
        .sizeOf(context)
        .width;
    double screenHeight = MediaQuery
        .sizeOf(context)
        .height;
    final userData = Provider.of<UserDataNotifier>(context, listen: false);
    final sessionDetails = Provider.of<sessionDetailsNotifier>(
        context, listen: false);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
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
                case 'Update profile':
                  userData.updateProfile=true;
                  userData.skinType=userData.user['skinType'];
                  Navigator.pushNamed(context, "/SkinType");
                  break;
                case 'Update my history':
                  userData.updateHistoryPressed = true;
                  fetchUserHistory();
                  Navigator.pushNamed(context, "/UserPrescription");
                  break;
                case 'Logout':
                  setState(() {
                    logoutPressed = true;
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
          hasConnection?
          Column(
            children: [
              CircleAvatar(
                radius: isTablet(context)
                    ? screenHeight * 0.045
                    : screenHeight * 0.04,
                backgroundImage: (userData.user['gender'] == 'Female')
                    ? AssetImage('assets/images/avatars/female.jpg')
                    : AssetImage('assets/images/avatars/male.jpeg'),
              ),
              SizedBox(height: screenHeight * 0.01,),
              Text(
                "${userData.user['name']}",
                style: TextStyle(
                    fontFamily: 'Raleway',
                    color: Colors.black,
                    fontSize: (isTablet(context))
                        ? screenWidth * 0.033
                        : screenWidth * 0.038,
                    //fontWeight: FontWeight.bold,
                  ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: screenHeight * 0.02),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios_new, size: screenWidth * 0.055,
                        color: Colors.black87,),
                      onPressed: moveToPreviousRange,
                    ),
                    Text(
                      getRangeLabel(),
                      style: TextStyle(
                         fontFamily: 'BrunoAceSC',
                          color: Colors.black,
                          fontSize: (isTablet(context))
                              ? screenWidth * 0.03
                              : screenWidth * 0.039,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                          Icons.arrow_forward_ios, size: screenWidth * 0.055),
                      color: isForwardButtonEnabled() ? Colors.black87 : Colors
                          .grey,
                      onPressed: isForwardButtonEnabled()
                          ? moveToNextRange
                          : null,
                    ),
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.01,),
              SizedBox(
                height: MediaQuery
                    .of(context)
                    .size
                    .height * 0.38,
                child: Padding(
                  padding: EdgeInsets.only(
                      left: screenWidth * 0.03, right: screenWidth * 0.01),
                  child: BarChart(
                    BarChartData(
                      maxY: selectedRange == 'Year' ? 30000 : 1000,
                      barGroups: getBarGroups(),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                              getTitlesWidget: (value, meta) {
                                if (selectedRange == 'Week') {
                                  List<String> weekDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                                  return Text(
                                    weekDays[value.toInt()],
                                    style: TextStyle(
                                      fontFamily: 'Raleway',
                                        color: Colors.black,
                                        fontSize: (isTablet(context)) ? screenWidth * 0.026 : screenWidth * 0.035,
                                    ),
                                  );
                                } else if (selectedRange == 'Month') {
                                  int day = value.toInt() + 1;
                                  if ([1, 5, 10, 15, 20, 25, 30].contains(day)) {
                                    return Text(
                                      day.toString(),
                                      style: TextStyle(
                                        fontFamily: 'Raleway',
                                          color: Colors.black,
                                          fontSize: (isTablet(context)) ? screenWidth * 0.026 : screenWidth * 0.035,
                                      ),
                                    );
                                  }
                                } else if (selectedRange == 'Year') {
                                  List<String> months = [
                                    'J', 'F', 'M', 'A', 'M', 'J', 'J', 'A', 'S', 'O', 'N', 'D'
                                  ];
                                  return Text(
                                    months[value.toInt()],
                                    style: TextStyle(
                                      fontFamily: 'Raleway',
                                        color: Colors.black,
                                        fontSize: (isTablet(context)) ? screenWidth * 0.026 : screenWidth * 0.035,
                                    ),
                                  );
                                }
                                return Text('');
                              }
                          ),
                        ),
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: screenWidth * 0.115,
                            getTitlesWidget: (value, meta) {
                              String formattedValue;
                              if (value >= 1000) {
                                formattedValue =
                                '${(value ~/ 1000)}k'; // Convert to "k" format
                              } else {
                                formattedValue = value.toInt()
                                    .toString(); // Display the number as is
                              }
                              return Padding(
                                padding: EdgeInsets.only(
                                    left: screenWidth * 0.03),
                                child: Text(
                                  '${formattedValue}',
                                  style: TextStyle(
                                    fontFamily: 'Raleway',
                                      color: Colors.black,
                                      fontSize: (isTablet(context))
                                          ? screenWidth * 0.026
                                          : screenWidth * 0.035,
                                    ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      gridData: FlGridData(show: false),
                    ),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.03,),
              Center(
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    // Center the containers within the row
                    children: [
                      InkWell(
                        onTap: () {
                          if (!weekPressed) {
                            setState(() {
                              weekPressed = true;
                              monthPressed = false;
                              yearPressed = false;
                              selectedRange = 'Week';
                              updateDateRange();
                            });
                          }
                        },
                        child: Container(
                          height: screenHeight * 0.055,
                          width: screenWidth * 0.2,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20.0),
                              bottomLeft: Radius.circular(20.0),
                            ),
                            color: weekPressed ? Colors.cyan : Color(
                                0xFFDEDEDE),
                          ),
                          child: Center(
                            child: Text(
                              "Week",
                              style: TextStyle(
                              fontFamily: 'BrunoAceSC',
                                  color: weekPressed ? Colors.white : Colors
                                      .black,
                                  fontSize: (isTablet(context)) ? screenWidth *
                                      0.029 : screenWidth * 0.038,
                                ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          if (!monthPressed) {
                            setState(() {
                              weekPressed = false;
                              monthPressed = true;
                              yearPressed = false;
                              selectedRange = 'Month';
                              updateDateRange();
                            });
                          }
                        },
                        child: Container(
                          height: screenHeight * 0.055,
                          width: screenWidth * 0.2,
                          color: monthPressed ? Colors.cyan : Color(0xFFDEDEDE),
                          child: Center(
                            child: Text(
                              "Month",
                              style: TextStyle(
                                  fontFamily: 'BrunoAceSC',
                                  color: monthPressed ? Colors.white : Colors
                                      .black,
                                  fontSize: (isTablet(context)) ? screenWidth *
                                      0.029 : screenWidth * 0.038,
                                ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          if (!yearPressed) {
                            setState(() {
                              weekPressed = false;
                              monthPressed = false;
                              yearPressed = true;
                              selectedRange = 'Year';
                              updateDateRange();
                            });
                          }
                        },
                        child: Container(
                          height: screenHeight * 0.055,
                          width: screenWidth * 0.2,
                          decoration: BoxDecoration(
                            color: yearPressed ? Colors.cyan : Color(
                                0xFFDEDEDE),
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(20.0),
                              bottomRight: Radius.circular(20.0),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              "Year",
                              style: TextStyle(
                              fontFamily: 'BrunoAceSC',
                                  color: yearPressed ? Colors.white : Colors
                                      .black,
                                  fontSize: (isTablet(context)) ? screenWidth *
                                      0.029 : screenWidth * 0.038,
                                ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(
                height: isTablet(context) ? screenHeight * 0.04 : screenHeight *
                    0.03,),
              Text(
                "Vitamin D intake - ${userData.todayIuConsumed}IU",
                style: TextStyle(
                fontFamily: 'Raleway',
                    color: Colors.black,
                    fontSize: (isTablet(context))
                        ? screenWidth * 0.036
                        : screenWidth * 0.04,
                    //fontWeight: FontWeight.bold,
                  ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: screenHeight * 0.04,),
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
                  onPressed: () {
                    if(sessionDetails.vitaminDIntake==0){
                      setState(() {
                        vitaminDIntakeComplete=true;
                      });
                    }else
                      Navigator.pushNamed(context, "/Spf");
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                        horizontal: (isTablet(context))
                            ? screenWidth * 0.09
                            : screenWidth * 0.15,
                        vertical: (isTablet(context))
                            ? screenHeight * 0.014
                            : screenHeight * 0.01),
                    // Text color
                    textStyle: TextStyle(fontSize: (isTablet(context))
                        ? screenWidth * 0.04
                        : screenWidth * 0.043, fontWeight: FontWeight.bold),
                  ),
                  child: Text('Start Session'),
                ),
              ),

            ],
          ):SizedBox(),
          Consumer<sessionDetailsNotifier>(builder: (context, value, child) {
            return (!value.sessionPossible) ?
            Container(
              height: double.infinity,
              width: double.infinity,
              color: Colors.transparent, //Colors.white12,
            ) : Container();
          }),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: isTablet(context) ? screenWidth * 0.05 : 0),
            child: Consumer<sessionDetailsNotifier>(
                builder: (context, value, child) {
                  return (!value.sessionPossible && !value.nightTime) ?
                  Center(
                    child: AlertDialog(
                      title: Text(
                        "Sun is resting now",
                        style: TextStyle(
                          fontFamily: 'BrunoAceSC',
                            color: Colors.white,
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
                          Image.asset(
                            'assets/images/sun.png', height: screenHeight *
                              0.15,),
                          Text(
                            "Currently, sunlight isn’t available due to certain conditions—this could be due to cloud cover, a low UV index, or other atmospheric factors.\nFor now, it may be best to wait and check again later when conditions improve for natural Vitamin D exposure!",
                            style: TextStyle(
                              fontFamily: 'Raleway',
                                color: Colors.white,
                                fontSize: (isTablet(context)) ? screenWidth *
                                    0.03 : screenWidth * 0.035,
                                //fontWeight: FontWeight.bold,
                              ),
                            textAlign: TextAlign.center,
                            ),

                        ],
                      ),
                      backgroundColor: Color(0xFFEC9500),
                      actions: [
                        TextButton(
                          onPressed: () {
                            SystemNavigator.pop();
                          },
                          child: Text(
                            "Exit",
                            style: TextStyle(
                              fontFamily: 'BrunoAceSC',
                                color: Colors.white,
                                fontSize: (isTablet(context)) ? screenWidth *
                                    0.038 : screenWidth * 0.04,
                                //fontWeight: FontWeight.bold,
                              ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            sessionDetails.sessionWillProceed();
                          },
                          child: Text(
                            "Retry",
                            style:  TextStyle(
                              fontFamily: 'BrunoAceSC',
                                color: Colors.white,
                                fontSize: (isTablet(context)) ? screenWidth *
                                    0.038 : screenWidth * 0.04,
                                //fontWeight: FontWeight.bold,
                              ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],),
                  )
                      : Container();
                }),
          ),
          Padding(
            padding: EdgeInsets.only(left: isTablet(context) ? screenWidth * 0.05 : 0,right: isTablet(context) ? screenWidth * 0.05 : 0,bottom: screenHeight*0.07),
            child: Consumer<sessionDetailsNotifier>(
                builder: (context, value, child) {
                  return (!value.sessionPossible && value.nightTime) ?
                  Center(
                    child: AlertDialog(
                      title: Text(
                        "Sun is unavailable",
                        style: TextStyle(
                          fontFamily: 'BrunoAceSC',
                            color: Colors.white,
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
                          Image.asset(
                            'assets/images/moon.png', height: screenHeight * 0.15,),
                          Text(
                            "It's already evening, so sunlight for Vitamin D isn't available now. Aim to get some sun exposure tomorrow, preferably around midday for maximum benefit."
                            , style: TextStyle(
                            fontFamily: 'Raleway',
                              color: Colors.white,
                              fontSize: (isTablet(context))
                                  ? screenWidth * 0.03
                                  : screenWidth * 0.035,
                              //fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      backgroundColor: Color(0xFF323232),
                      actions: [
                        TextButton(
                          onPressed: () {
                            setState(() {
                              value.sessionPossible =true;
                              value.nightTime=false;
                            });
                          },
                          child: Text(
                            "Ok",
                            style: TextStyle(
                              fontFamily: 'BrunoAceSC',
                                color: Colors.white,
                                fontSize: (isTablet(context)) ? screenWidth *
                                    0.038 : screenWidth * 0.04,
                                //fontWeight: FontWeight.bold,
                              ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],),
                  )
                      : Container();
                }),
          ),
          (!hasConnection||logoutPressed|| vitaminDIntakeComplete) ?
          Container(
            height: double.infinity,
            width: double.infinity,
            color: Colors.white24,

          ) : Container(),
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
              : Container(),
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
                      "Are you sure you want to logout from session?"
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
          ) : Container(),
          vitaminDIntakeComplete?
          Padding(
            padding: EdgeInsets.only(bottom: screenHeight * 0.1,
                left: isTablet(context) ? screenWidth * 0.05 : 0,
                right: isTablet(context) ? screenWidth * 0.05 : 0),
            child: Center(
                child: AlertDialog(
                  title: Text(
                    "Vitamin D IU Completed",
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
                      Image.asset('assets/images/iuCompleted.png',
                        height: screenHeight * 0.2,),
                      Text(
                        'You already have consumed 1000 IU for today so no further session required',
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
                  backgroundColor: Colors.orangeAccent,
                  actions: [
                    TextButton(
                      onPressed: () async {
                        setState(() {
                          vitaminDIntakeComplete=false;
                        });
                      },
                      child: Text(
                        "Ok",
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
          ):SizedBox.shrink()
        ],
      )

      ,
    );
  }

  String formatTimestamp(Timestamp timestamp) {
    // Convert Timestamp to DateTime
    DateTime dateTime = timestamp.toDate();

    // Get the current date
    DateTime now = DateTime.now();

    // Check if the dateTime matches today's date
    if (dateTime.year == now.year && dateTime.month == now.month &&
        dateTime.day == now.day) {
      return "Today";
    }

    // Format DateTime to a readable string, e.g., 'Nov 03, 2024'
    String formattedDate = DateFormat('MMM dd, yyyy').format(dateTime);

    return formattedDate;
  }

  bool isTablet(BuildContext context) {
    var screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    return screenWidth >= 600 && screenWidth <= 1024;
  }

  Future<void> checkConnection() async {
    var result = await InternetConnectionChecker().hasConnection;
    if (mounted) {
      if(result)
      updateDateRange();
      setState(() {
        hasConnection = result;
      });
    }
  }

  void updateDateRange() {
    setState(() {
      if (selectedRange == 'Week') {
        int weekday = currentDate.weekday;
        rangeStart = currentDate.subtract(Duration(days: weekday - 1)); // Start from Monday
        rangeEnd = rangeStart.add(Duration(days: 6)); // End on Sunday
      } else if (selectedRange == 'Month') {
        rangeStart = DateTime(currentDate.year, currentDate.month, 1);
        rangeEnd = DateTime(currentDate.year, currentDate.month + 1, 0);
      } else if (selectedRange == 'Year') {
        rangeStart = DateTime(currentDate.year, 1, 1);
        rangeEnd = DateTime(currentDate.year, 12, 31);
      }
    });
  }

  void moveToPreviousRange() {
    setState(() {
      if (selectedRange == 'Week') {
        currentDate = currentDate.subtract(Duration(days: 7));
      } else if (selectedRange == 'Month') {
        currentDate = DateTime(currentDate.year, currentDate.month - 1);
      } else if (selectedRange == 'Year') {
        currentDate = DateTime(currentDate.year - 1);
      }
      updateDateRange();
    });
  }

  void moveToNextRange() {
    setState(() {
      if (selectedRange == 'Week') {
        currentDate = currentDate.add(Duration(days: 7));
      } else if (selectedRange == 'Month') {
        currentDate = DateTime(currentDate.year, currentDate.month + 1);
      } else if (selectedRange == 'Year') {
        currentDate = DateTime(currentDate.year + 1);
      }
      updateDateRange();
    });
  }

  bool isForwardButtonEnabled() {
    if (selectedRange == 'Week') {
      return currentDate.isBefore(
          DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1)));
    } else if (selectedRange == 'Month') {
      return currentDate.isBefore(DateTime(DateTime.now().year, DateTime.now().month, 1));
    } else if (selectedRange == 'Year') {
      return currentDate.year < DateTime.now().year;
    }
    return false;
  }

  String getRangeLabel() {
    if (selectedRange == 'Week') {
      return '${DateFormat('MMM dd').format(rangeStart)} - ${DateFormat(
          'MMM dd').format(rangeEnd)}';
    } else if (selectedRange == 'Month') {
      return DateFormat('MMM yyyy').format(currentDate);
    } else if (selectedRange == 'Year') {
      return DateFormat('yyyy').format(currentDate);
    }
    return '';
  }

  List<BarChartGroupData> getBarGroups() {
    final userData = Provider.of<UserDataNotifier>(context, listen: false);

    double screenWidth = MediaQuery.sizeOf(context).width;

    int numberOfBars;
    if (selectedRange == 'Week') {
      numberOfBars = 7; // 7 days
    } else if (selectedRange == 'Month') {
      numberOfBars = DateTime(currentDate.year, currentDate.month + 1, 0).day;
    } else {
      numberOfBars = 12; // 12 months
    }

    double barWidth = screenWidth / (numberOfBars * 2);

    List<BarChartGroupData> barGroups = [];

    for (int i = 0; i < numberOfBars; i++) {
      DateTime periodStart;

      if (selectedRange == 'Week') {
        periodStart = rangeStart.add(Duration(days: i)); // Start from Monday
      } else if (selectedRange == 'Month') {
        periodStart = DateTime(currentDate.year, currentDate.month, i + 1);
      } else {
        periodStart = DateTime(currentDate.year, i + 1, 1);
      }

      double iuSum = 0;

      if (selectedRange == 'Year') {
        // Group and sum `iuConsumed` by month
        userData.userGraphDetails?.forEach((session) {
          DateTime sessionDate = session['date'];
          if (sessionDate.year == currentDate.year &&
              sessionDate.month == i + 1) {
            iuSum += session['iuConsumed']?.toDouble() ?? 0;
          }
        });
      } else {
        // Fetch `iuConsumed` for a specific day (Week/Month case)
        var session = userData.userGraphDetails?.firstWhere(
              (session) =>
          DateFormat('yyyy-MM-dd').format(session['date']) ==
              DateFormat('yyyy-MM-dd').format(periodStart),
          orElse: () => {'iuConsumed': 0},
        );
        iuSum = session['iuConsumed']?.toDouble() ?? 0;
      }

      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: iuSum,
              color: iuSum > 0 ? Colors.orangeAccent : Color(0xFFE7E7E7),
              width: barWidth,
              borderRadius: BorderRadius.circular(8),
            ),
          ],
        ),
      );
    }

    return barGroups;
  }

  void fetchUserHistory() {
    final userData = Provider.of<UserDataNotifier>(context, listen: false);
    final historyProvider = Provider.of<HistoryNotifier>(
        context, listen: false);
    final testResultsProvider = Provider.of<TestResultsNotifier>(
        context, listen: false);
    if (userData.user['pills'].isNotEmpty) {
      List<String> userMed = userData.user['pills'].split(',');
      if (userMed.contains('Daily Cal')) {
        historyProvider.m1Pressed(true);
        userMed.remove('Daily Cal');
      }
      if (userMed.contains('Insta CAL-D')) {
        historyProvider.m2Pressed(true);
        userMed.remove('Insta CAL-D');
      }
      if (userMed.contains('WIL-D')) {
        historyProvider.m3Pressed(true);
        userMed.remove('WIL-D');
      }
      if (userMed.isNotEmpty) {
        historyProvider.supplementsController.text = userMed.join(',');
      }
      historyProvider.pillSelected();
    } else
      historyProvider.pillRemoved();

    if (userData.user['test date'].isNotEmpty) {
      testResultsProvider.dateController.text = userData.user['test date'];
      testResultsProvider.testValueController.text =
          userData.user['test value'].toString();
      testResultsProvider.addResult();
    }
    else
      testResultsProvider.removeResult();
  }
}
