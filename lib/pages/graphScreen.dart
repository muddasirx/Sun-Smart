import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sidebarx/sidebarx.dart';
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
  DateTime currentWeekDate = DateTime.now();
  DateTime currentMonthDate = DateTime.now();
  DateTime currentYearDate = DateTime.now();
  DateTime rangeStart = DateTime.now();
  DateTime rangeEnd = DateTime.now();
  bool vitaminDIntakeComplete=false;
  final SidebarXController _controller = SidebarXController(selectedIndex: -1, extended: true);

  @override
  void initState() {
    super.initState();
    print("--------------------Graph Screen-------------------");
    checkConnection();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;
    final userData = Provider.of<UserDataNotifier>(context, listen: false);
    final sessionDetails = Provider.of<sessionDetailsNotifier>(context, listen: false);

    return Scaffold(
      resizeToAvoidBottomInset: false,

      drawer: Drawer(

        width: isTablet(context)?screenWidth*0.5:screenWidth * 0.6,
        child: Column(
          children: [
            SizedBox(height: screenHeight * 0.08),
            Center(
              child: CircleAvatar(
                radius: isTablet(context)
                    ? screenHeight * 0.045
                    : screenHeight * 0.04,
                backgroundImage: (userData.user['gender'] == 'Female')
                    ? AssetImage('assets/images/avatars/female.jpg')
                    : AssetImage('assets/images/avatars/male.jpeg'),
              ),
            ),
            SizedBox(height: screenHeight * 0.03),
            Expanded(
              child: SidebarX(
                showToggleButton: false,
                controller: _controller,
                extendedTheme: SidebarXTheme(
                    iconTheme: IconThemeData(size: screenHeight*0.027),
                    textStyle: TextStyle(fontSize: screenHeight*0.018),
                  width: isTablet(context)?screenWidth*0.5:screenWidth * 0.6,
                    itemTextPadding: EdgeInsets.only(left: screenWidth*0.02)
                ),
                items:  [
                  SidebarXItem(icon: Icons.person_2_outlined,
                    selectable: false,
                    label: 'Update profile',onTap: (){
                    Navigator.pop(context);
                    userData.updateProfile=true;
                    userData.skinType=userData.user['skinType'];
                    Navigator.pushNamed(context, "/SkinType");
                  },),

                  SidebarXItem(icon: Icons.history, label: 'Update my history',selectable: false,
                      onTap: (){
                    Navigator.pop(context);
                    userData.updateHistoryPressed = true;
                    clearPreviousHistory();
                    fetchUserHistory();
                    Navigator.pushNamed(context, "/UserPrescription");
                  }),

                  SidebarXItem(icon: Icons.lock_outline, label: 'Update password',selectable: false,
                      onTap: (){
                    Navigator.pop(context);
                    Navigator.pushNamed(context, "/UpdatePassword" );
                  }),

                  /*
                  SidebarXItem(icon: Icons.alarm, label: 'Supplement reminder',selectable: false,
                      onTap: (){
                        userData.sessionReminderPressed=false;
                        Navigator.pop(context);
                        Navigator.pushNamed(context, "/Reminder" );
                      }),


                  SidebarXItem(icon: Icons.alarm, label: 'Session reminder',selectable: false,
                      onTap: (){
                        userData.sessionReminderPressed=true;
                        Navigator.pop(context);
                        Navigator.pushNamed(context, "/Reminder" );
                      }),
                      */


                ],
              ),
            ),
            Padding(
              padding:  EdgeInsets.symmetric(horizontal: screenWidth*0.05,),
              child: InkWell(
                splashFactory: NoSplash.splashFactory,
                onTap: (){
                  Navigator.pop(context);
                  setState(() {
                    logoutPressed=true;
                  });
                },
                child: Container(
                  height: screenHeight*0.045,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFFCC54E), Color(0xFFFDA34F)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(50.0), // Rounded corners
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.exit_to_app,size: screenHeight*0.025,color: Colors.white,),
                      Text(' Log out',style: TextStyle(
                        color: Colors.white,
                          fontSize: (isTablet(context))
                              ? screenWidth * 0.04
                              : screenWidth * 0.041, fontWeight: FontWeight.bold
                      ),),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: screenHeight*0.03,)
          ],
        ),
      ),

      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black87,
          size: (isTablet(context))?screenWidth* 0.046:screenWidth* 0.06,//(isTablet(context))?30:23
        ),
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

              (selectedRange == 'Week')?Padding(
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
              ):SizedBox.shrink(),
              (selectedRange == 'Month')?Padding(
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
              ):SizedBox.shrink(),
              (selectedRange == 'Year')?Padding(
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
              ):SizedBox.shrink(),
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
                "Today's Vitamin D Intake - ${userData.todayIuConsumed} IU",
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


          // Alerts

          Consumer<sessionDetailsNotifier>(builder: (context, value, child) {
            return (!value.sessionPossible) ?
            Container(
              height: double.infinity,
              width: double.infinity,
              color: Colors.transparent, //Colors.white12,
            ) : Container();
          }),
          Padding(
            padding: EdgeInsets.only(
                left: isTablet(context) ? screenWidth * 0.05 : 0,right: isTablet(context) ? screenWidth * 0.05 : 0,bottom: screenHeight*0.06),
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
                      : SizedBox.shrink();
                }),
          ),
        Consumer<sessionDetailsNotifier>(builder: (context, value, child){
        return (!hasConnection||logoutPressed|| vitaminDIntakeComplete || sessionDetails.apiLimitExceeded) ?
          Container(
            height: double.infinity,
            width: double.infinity,
            color: Colors.white24,

          ) : SizedBox.shrink();}),
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
          ) : SizedBox.shrink(),
          Consumer<sessionDetailsNotifier>(builder: (context, value, child){
         return sessionDetails.apiLimitExceeded?
          Padding(
            padding: EdgeInsets.only(bottom: screenHeight * 0.05,
                left: isTablet(context) ? screenWidth * 0.05 : 0,
                right: isTablet(context) ? screenWidth * 0.05 : 0),
            child: Center(
              child: AlertDialog(
                title: Text(
                  "Server Busy",
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
                      'assets/images/server.png', height: screenHeight * 0.2,),
                    Text(
                      "Service is temporarily unavailable. Please try taking your Vitamin D session tomorrow. We appreciate your cooperation."
                      , style: TextStyle(
                      fontFamily: 'Raleway',
                      color: Colors.black,
                      fontSize: (isTablet(context))
                          ? screenWidth * 0.04
                          : screenWidth * 0.04,
                      //fontWeight: FontWeight.bold,
                    ),
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
                        sessionDetails.apiLimitCheck(false);
                    },
                    child: Text(
                      "Ok",
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
          ) : SizedBox.shrink();}),
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
        int weekday = currentWeekDate.weekday;
        rangeStart = currentWeekDate.subtract(Duration(days: weekday - 1)); // Start from Monday
        rangeEnd = rangeStart.add(Duration(days: 6)); // End on Sunday
      } else if (selectedRange == 'Month') {
        rangeStart = DateTime(currentMonthDate.year, currentMonthDate.month, 1);
        rangeEnd = DateTime(currentMonthDate.year, currentMonthDate.month + 1, 0);
      } else if (selectedRange == 'Year') {
        rangeStart = DateTime(currentYearDate.year, 1, 1);
        rangeEnd = DateTime(currentYearDate.year, 12, 31);
      }
    });
  }

  void moveToPreviousRange() {
    setState(() {
      if (selectedRange == 'Week') {
        currentWeekDate = currentWeekDate.subtract(Duration(days: 7));
      } else if (selectedRange == 'Month') {
        currentMonthDate = DateTime(currentMonthDate.year, currentMonthDate.month - 1);
      } else if (selectedRange == 'Year') {
        currentYearDate = DateTime(currentYearDate.year - 1);
      }
      updateDateRange();
    });
  }

  void moveToNextRange() {
    setState(() {
      if (selectedRange == 'Week') {
        currentWeekDate = currentWeekDate.add(Duration(days: 7));
      } else if (selectedRange == 'Month') {
        currentMonthDate = DateTime(currentMonthDate.year, currentMonthDate.month + 1);
      } else if (selectedRange == 'Year') {
        currentYearDate = DateTime(currentYearDate.year + 1);
      }
      updateDateRange();
    });
  }

  bool isForwardButtonEnabled() {
    if (selectedRange == 'Week') {
      return rangeEnd.isBefore(DateTime.now());
    } else if (selectedRange == 'Month') {
      return currentMonthDate.isBefore(DateTime(DateTime.now().year, DateTime.now().month, 1));
    } else if (selectedRange == 'Year') {
      return currentYearDate.year < DateTime.now().year;
    }
    return false;
  }

  String getRangeLabel() {
    print("--------Range start: ${rangeStart} , Range End: ${rangeEnd}---------");
    if (selectedRange == 'Week') {
      return '${DateFormat('MMM dd').format(rangeStart)} - ${DateFormat(
          'MMM dd').format(rangeEnd)}';
    } else if (selectedRange == 'Month') {
      return DateFormat('MMM yyyy').format(currentMonthDate);
    } else if (selectedRange == 'Year') {
      return DateFormat('yyyy').format(currentYearDate);
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
      numberOfBars = DateTime(currentMonthDate.year, currentMonthDate.month + 1, 0).day;
    } else {
      numberOfBars = 12;
    }

    double barWidth = screenWidth / (numberOfBars * 2);

    List<BarChartGroupData> barGroups = [];

    for (int i = 0; i < numberOfBars; i++) {
      DateTime periodStart;

      if (selectedRange == 'Week') {
        periodStart = rangeStart.add(Duration(days: i)); // Start from Monday
      } else if (selectedRange == 'Month') {
        periodStart = DateTime(currentMonthDate.year, currentMonthDate.month, i + 1);
      } else {
        periodStart = DateTime(currentYearDate.year, i + 1, 1);
      }

      double iuSum = 0;

      if (selectedRange == 'Year') {
        // Group and sum `iuConsumed` by month
        userData.userGraphDetails?.forEach((session) {
          DateTime sessionDate = session['date'];
          if (sessionDate.year == currentYearDate.year &&
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

  void clearPreviousHistory(){
    final userData = Provider.of<UserDataNotifier>(context, listen: false);
    final historyProvider = Provider.of<HistoryNotifier>(
        context, listen: false);
    final testResultsProvider = Provider.of<TestResultsNotifier>(
        context, listen: false);
    historyProvider.m1Pressed(false);
    historyProvider.m2Pressed(false);
    historyProvider.m3Pressed(false);
    historyProvider.supplementsController.clear();
    historyProvider.pillRemoved();

    testResultsProvider.dateController.clear();
    testResultsProvider.testValueController.clear();
    testResultsProvider.removeResult();
  }

  void fetchUserHistory() {
    final userData = Provider.of<UserDataNotifier>(context, listen: false);
    final historyProvider = Provider.of<HistoryNotifier>(
        context, listen: false);
    final testResultsProvider = Provider.of<TestResultsNotifier>(
        context, listen: false);

    testResultsProvider.removeSubmissionText();
    historyProvider.removeSubmissionText();
    if(userData.user['pills'].isEmpty && userData.user['test date'].isEmpty){
      historyProvider.noPressed=true;
    }else{
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
}
