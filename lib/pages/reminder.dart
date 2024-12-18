import 'package:bottom_picker/bottom_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../providers/sessionDetailsProvider.dart';
import '../providers/userDataProvider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzd;
import 'package:permission_handler/permission_handler.dart';
import 'dart:io' show Platform;

class Reminder extends StatefulWidget {
  const Reminder({super.key});

  @override
  State<Reminder> createState() => _ReminderState();
}

class _ReminderState extends State<Reminder> {
  bool hasConnection=true;
  bool dailyPressed=true;
  bool mon=true,tue=true,wed=true,thu=true,fri=true,sat=true,sun=true;
  bool notification=false;
  var now ;
  String selectedTime = "${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}";
  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();
  List<int> selectedDays = [1,2,3,4,5,6,7];
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();
    _requestExactAlarmPermission();
    _initializeNotifications();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;
    final userData = Provider.of<UserDataNotifier>(context, listen: false);
    final sessionDetails = Provider.of<sessionDetailsNotifier>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
            iconTheme: IconThemeData(
              color: Colors.black87,
              size: (isTablet(context))?screenWidth* 0.046:screenWidth* 0.06,//(isTablet(context))?30:23
            ),
            centerTitle: true,
            title: Text(
              "Add a reminder",
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
              padding:  EdgeInsets.only(left: screenWidth*0.05,right: screenWidth*0.05),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: screenHeight*0.01,),
                    Text(
                      'How often would you like to take a Vitamin D ${userData.sessionReminderPressed?'session':'pill'}?',
                      style: TextStyle(
                        fontFamily: 'Raleway',
                        color: Colors.black87,
                        fontSize: (isTablet(context))?screenWidth*0.035:screenWidth*0.039,
                        //fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height:screenHeight*0.03),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Notification',
                          style: TextStyle(
                            fontFamily: 'BrunoAceSC',
                            color: Colors.black87,
                            fontSize: (isTablet(context))?screenWidth*0.040:screenWidth*0.044,
                            //fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Transform.scale(
                          scale: (isTablet(context)) ? 1.6 : 1,
                          child: Checkbox(
                            value: notification,
                            checkColor: Colors.white,
                            activeColor: Colors.orange,
                            side: BorderSide(color: Colors.black87, width: 1.6),
                            onChanged: (bool? value) {
                              setState(() {
                                notification = value!;
                                now=DateTime.now();
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    (notification)?Column(
                      children: [

                        InkWell(
                          onTap:(){
                            _showTimePicker();
                           },
                          splashFactory: NoSplash.splashFactory,
                          child: Container(
                            color: Colors.transparent,
                            child: Padding(
                              padding:  EdgeInsets.symmetric(vertical: screenHeight*0.02),
                              child: Padding(
                                padding:  EdgeInsets.only(right: screenWidth*0.02),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      selectedTime,
                                      style: TextStyle(
                                        fontFamily: 'BrunoAceSC',
                                        color: Colors.cyan,
                                        fontSize: (isTablet(context))?screenWidth*0.05:screenWidth*0.055,
                                        //fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    Icon(
                                        Icons.arrow_forward_ios,
                                      color: Colors.grey,
                                      size: isTablet(context)?screenHeight*0.026:screenHeight*0.026,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              splashFactory: NoSplash.splashFactory,
                              onTap: (){
                                if(!dailyPressed) {
                                  setState(() {
                                    dailyPressed = true;
                                  });
                                }
                              },
                              child: Text(
                                'Daily',
                                style: TextStyle(
                                  fontFamily: 'BrunoAceSC',
                                  color: Colors.black87,
                                  fontSize: (isTablet(context))?screenWidth*0.044:screenWidth*0.045,
                                  //fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            IconButton(
                              highlightColor: Colors.transparent,
                              icon:Icon(
                                dailyPressed?Icons.radio_button_checked:Icons.radio_button_off,
                                color: dailyPressed?Colors.orangeAccent:Colors.black54,size: isTablet(context)?screenHeight*0.035:screenHeight*0.035,),
                              onPressed: (){
                                if(!dailyPressed) {
                                  setState(() {
                                    dailyPressed = true;
                                  });
                                }
                              },
                            ),
                
                          ],
                        ),
                        SizedBox(height: screenHeight*0.02,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              splashFactory: NoSplash.splashFactory,
                              onTap: (){
                                if(dailyPressed) {
                                  setState(() {
                                    dailyPressed = false;
                                  });
                                }
                              },
                              child: Text(
                                'Custom',
                                style: TextStyle(
                                  fontFamily: 'BrunoAceSC',
                                  color: Colors.black87,
                                  fontSize: (isTablet(context))?screenWidth*0.044:screenWidth*0.045,
                                  //fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            IconButton(
                              highlightColor: Colors.transparent,
                              icon:Icon(
                                dailyPressed?Icons.radio_button_off:Icons.radio_button_checked,
                                color: dailyPressed?Colors.black54:Colors.orangeAccent,size: isTablet(context)?screenHeight*0.035:screenHeight*0.035,),
                              onPressed: (){
                                if(dailyPressed) {
                                  setState(() {
                                    dailyPressed = false;
                                  });
                                }
                              },
                            ),
                
                          ],
                        ),
                        SizedBox(height: screenHeight*0.05,),

                        (!dailyPressed)?Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Monday',
                                  style: TextStyle(
                                    fontFamily: 'Raleway',
                                    color: Colors.black87,
                                    fontSize: (isTablet(context))?screenWidth*0.043:screenWidth*0.044,
                                    //fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                Transform.scale(
                                  scale: (isTablet(context)) ? 1.6 : 0.9,
                                  child: Checkbox(
                                    value: mon,
                                    checkColor: Colors.white,
                                    activeColor: Colors.orange,
                                    side: BorderSide(color: Colors.black54, width: 2),
                                    onChanged: (bool? value) {
                                      if(value!=null && value == true){
                                        selectedDays.add(1);
                                      }else
                                        selectedDays.remove(1);
                                      setState(() {
                                        mon = value!;
                                      });
                                      print(selectedDays);
                                    },
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Tuesday',
                                  style: TextStyle(
                                    fontFamily: 'Raleway',
                                    color: Colors.black87,
                                    fontSize: (isTablet(context))?screenWidth*0.043:screenWidth*0.044,
                                    //fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                Transform.scale(
                                  scale: (isTablet(context)) ? 1.6 : 0.9,
                                  child: Checkbox(
                                    value: tue,
                                    checkColor: Colors.white,
                                    activeColor: Colors.orange,
                                    side: BorderSide(color: Colors.black54, width: 2),
                                    onChanged: (bool? value) {
                                      if(value!=null && value == true){
                                        selectedDays.add(2);
                                      }else
                                        selectedDays.remove(2);
                                      setState(() {
                                        tue = value!;
                                      });
                                      print(selectedDays);
                                    },
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Wednesday',
                                  style: TextStyle(
                                    fontFamily: 'Raleway',
                                    color: Colors.black87,
                                    fontSize: (isTablet(context))?screenWidth*0.043:screenWidth*0.044,
                                    //fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                Transform.scale(
                                  scale: (isTablet(context)) ? 1.6 : 0.9,
                                  child: Checkbox(
                                    value: wed,
                                    checkColor: Colors.white,
                                    activeColor: Colors.orange,
                                    side: BorderSide(color: Colors.black54, width: 2),
                                    onChanged: (bool? value) {
                                      if(value!=null && value == true){
                                        selectedDays.add(3);
                                      }else
                                        selectedDays.remove(3);
                                      setState(() {
                                        wed = value!;
                                      });
                                      print(selectedDays);
                                    },
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Thursday',
                                  style: TextStyle(
                                    fontFamily: 'Raleway',
                                    color: Colors.black87,
                                    fontSize: (isTablet(context))?screenWidth*0.043:screenWidth*0.044,
                                    //fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                Transform.scale(
                                  scale: (isTablet(context)) ? 1.6 : 0.9,
                                  child: Checkbox(
                                    value: thu,
                                    checkColor: Colors.white,
                                    activeColor: Colors.orange,
                                    side: BorderSide(color: Colors.black54, width: 2),
                                    onChanged: (bool? value) {
                                      if(value!=null && value == true){
                                        selectedDays.add(4);
                                      }else
                                        selectedDays.remove(4);
                                      setState(() {
                                        thu = value!;
                                      });
                                      print(selectedDays);
                                    },
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Friday',
                                  style: TextStyle(
                                    fontFamily: 'Raleway',
                                    color: Colors.black87,
                                    fontSize: (isTablet(context))?screenWidth*0.043:screenWidth*0.044,
                                    //fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                Transform.scale(
                                  scale: (isTablet(context)) ? 1.6 : 0.9,
                                  child: Checkbox(
                                    value: fri,
                                    checkColor: Colors.white,
                                    activeColor: Colors.orange,
                                    side: BorderSide(color: Colors.black54, width: 2),
                                    onChanged: (bool? value) {
                                      if(value!=null && value == true){
                                        selectedDays.add(5);
                                      }else
                                        selectedDays.remove(5);
                                      setState(() {
                                        fri = value!;
                                      });
                                      print(selectedDays);
                                    },
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Saturday',
                                  style: TextStyle(
                                    fontFamily: 'Raleway',
                                    color: Colors.black87,
                                    fontSize: (isTablet(context))?screenWidth*0.043:screenWidth*0.044,
                                    //fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                Transform.scale(
                                  scale: (isTablet(context)) ? 1.6 : 0.9,
                                  child: Checkbox(
                                    value: sat,
                                    checkColor: Colors.white,
                                    activeColor: Colors.orange,
                                    side: BorderSide(color: Colors.black54, width: 2),
                                    onChanged: (bool? value) {
                                      if(value!=null && value == true){
                                        selectedDays.add(6);
                                      }else
                                        selectedDays.remove(6);
                                      setState(() {
                                        sat = value!;
                                      });
                                      print(selectedDays);
                                    },
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Sunday',
                                  style: TextStyle(
                                    fontFamily: 'Raleway',
                                    color: Colors.black87,
                                    fontSize: (isTablet(context))?screenWidth*0.043:screenWidth*0.044,
                                    //fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                Transform.scale(
                                  scale: (isTablet(context)) ? 1.6 : 0.9,
                                  child: Checkbox(
                                    value: sun,
                                    checkColor: Colors.white,
                                    activeColor: Colors.orange,
                                    side: BorderSide(color: Colors.black54, width: 2),
                                    onChanged: (bool? value) {
                                      if(value!=null && value == true){
                                        selectedDays.add(7);
                                      }else
                                        selectedDays.remove(7);
                                      setState(() {
                                        sun = value!;
                                      });
                                      print(selectedDays);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ):SizedBox.shrink()
                
                      ],
                    ):SizedBox.shrink(),

                  ],
                ),
              ),
            ),


          

          (!hasConnection) ?
          Container(
            height: double.infinity,
            width: double.infinity,
            color: Colors.white24,

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
        ],
      ),

      floatingActionButton: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding:  EdgeInsets.only(left: screenWidth*0.06,bottom: screenHeight*0.02),
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [BoxShadow(
                color: Colors.black54,
                blurRadius: 15,
                offset: Offset(0, 8),
              )],
              gradient: LinearGradient(
                colors: [Color(0xFFFCC54E), Color(0xFFFDA34F)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(50.0), // Rounded corners
            ),
            child: TextButton(
              onPressed: () async {
                print("Done pressed");
                if(notification){
                    if (!dailyPressed && selectedDays.isEmpty) {
                      if (Platform.isIOS) {
                        showToast(
                          'Please select any of the given days to proceed',
                          context: context,
                          animation: StyledToastAnimation.slideFromTop,
                          reverseAnimation: StyledToastAnimation.fade,
                          position: StyledToastPosition.top,
                          duration: const Duration(seconds: 3),
                          backgroundColor: Colors.red,
                          textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: (isTablet(context))
                                  ? screenWidth * 0.03
                                  : screenWidth * 0.035),
                          borderRadius: BorderRadius.circular(10.0),
                          toastHorizontalMargin: 20.0,
                          animDuration: const Duration(milliseconds: 500),
                        );
                      } else {
                        Fluttertoast.showToast(
                          fontSize: (isTablet(context))
                              ? screenWidth * 0.03
                              : screenWidth * 0.035,
                          msg: "Please select any of the given days to proceed",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          // Change this to your desired background color
                          textColor: Colors.white,
                        );
                      }
                    }
                    else {

                      print("-----------Running schedule notification method-----------");
                      await _scheduleNotifications();

                      if (Platform.isIOS) {
                        showToast(
                          'Reminder added successfully',
                          context: context,
                          animation: StyledToastAnimation.slideFromTop,
                          reverseAnimation: StyledToastAnimation.fade,
                          position: StyledToastPosition.top,
                          duration: const Duration(seconds: 3),
                          backgroundColor: Colors.grey[300],
                          textStyle: TextStyle(
                              color: Colors.black,
                              fontSize: (isTablet(context))
                                  ? screenWidth * 0.03
                                  : screenWidth * 0.035),
                          borderRadius: BorderRadius.circular(10.0),
                          toastHorizontalMargin: 20.0,
                          animDuration: const Duration(milliseconds: 500),
                        );
                      } else {
                        Fluttertoast.showToast(
                          fontSize: (isTablet(context))
                              ? screenWidth * 0.03
                              : screenWidth * 0.035,
                          msg: "Reminder added successfully",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.grey[300],
                          textColor: Colors.black,
                        );
                      }

                    }
                  }else{
                  if (Platform.isIOS) {
                    showToast(
                      'Please provide info related to reminder by checking notification',
                      context: context,
                      animation: StyledToastAnimation.slideFromTop,
                      reverseAnimation: StyledToastAnimation.fade,
                      position: StyledToastPosition.top,
                      duration: const Duration(seconds: 3),
                      backgroundColor: Colors.red,
                      textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: (isTablet(context))
                              ? screenWidth * 0.03
                              : screenWidth * 0.035),
                      borderRadius: BorderRadius.circular(10.0),
                      toastHorizontalMargin: 20.0,
                      animDuration: const Duration(milliseconds: 500),
                    );
                  } else {
                    Fluttertoast.showToast(
                      fontSize: (isTablet(context))
                          ? screenWidth * 0.03
                          : screenWidth * 0.035,
                      msg: "Please provide info related to reminder by checking notification",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      // Change this to your desired background color
                      textColor: Colors.white,
                    );
                  }
                }
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
              child: Text('Done'),
            ),
          ),
        ),
      )
    );
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
      setState(() {
        hasConnection = result;
      });
    }
  }

  void _showTimePicker() {
    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;

    BottomPicker.time(
      height: screenHeight*0.35,
      pickerTitle: Text("Select Time",style: TextStyle(
          fontSize: (isTablet(context))?screenWidth* 0.04:screenWidth* 0.045,
          fontFamily: 'Raleway',
          color: Colors.black),),
      onSubmit: (time) {
        setState(() {
          selectedTime = "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
          _selectedTime=TimeOfDay(hour: time.hour, minute: time.minute);
          now=time;
        });
        print("on Submit");

      },
      use24hFormat: true, // Use 24-hour format
      initialTime: Time(hours:now.hour,minutes: now.minute),
      backgroundColor: Colors.white,
      pickerTextStyle: TextStyle(
          fontSize: (isTablet(context))?screenWidth* 0.037:screenWidth* 0.05,
          fontFamily: 'Raleway',
          color: Colors.black),
      buttonStyle: BoxDecoration(

        gradient: LinearGradient(
          colors: [Color(0xff00d2ff), Color(0xff3a7bd5)],
          stops: [0, 1],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      borderRadius: BorderRadius.circular(20) , // Rounded corners
      ),
      buttonContent: Text("Select",style: TextStyle(
          fontSize: (isTablet(context))?screenWidth* 0.035:screenWidth* 0.04,
          color: Colors.white),
      textAlign: TextAlign.center,),
      closeIconSize: (isTablet(context))?screenWidth* 0.05:screenWidth* 0.06,
      closeIconColor: Colors.black87,
      buttonWidth: screenWidth*0.2,
      
    ).show(context);
  }

  Future<void> _requestExactAlarmPermission() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      if (await Permission.scheduleExactAlarm.isDenied) {
        await Permission.scheduleExactAlarm.request();
      }
    }
  }

  /*
  Future<void> scheduleNotification(int day, TimeOfDay time) async {
    final userData = Provider.of<UserDataNotifier>(context, listen: false);

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: UniqueKey().hashCode, // Generate a unique ID for each notification
        channelKey: 'scheduled_channel',
        title: 'Daily Reminder',
        body: userData.sessionReminderPressed?'Hi ${userData.user['name'].split(" ")[0]}, It\'s time for your scheduled Vitamin D session.':'Hi ${userData.user['name'].split(" ")[0]}, It\'s time to intake your Vitamin D supplements.',
        notificationLayout: NotificationLayout.Default,
      ),
      schedule: NotificationCalendar(
        weekday: day,
        hour: time.hour,
        minute: time.minute,
        second: 0,
        millisecond: 0,
        repeats: true,
      ),
    );
  }

  void handleScheduleNotifications() {

    for (int day in selectedDays) {
      scheduleNotification(day, selectedTime!);
    }

  } */

  void _initializeNotifications() async {

    tzd.initializeTimeZones();

    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    DarwinInitializationSettings initializationSettingsIOS =
    DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _notificationsPlugin.initialize(initializationSettings);
    await _requestExactAlarmsPermission();
    await requestNotificationPermission();
  }

  Future<void> _scheduleNotifications() async {
    if (_selectedTime == null) return;

    final time = _selectedTime!;
    const androidDetails = AndroidNotificationDetails(
      'daily_notifications',
      'Daily Notifications',
      channelDescription: 'Notifications scheduled for specific days and time',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true
    );

    const iosDetails = DarwinNotificationDetails();

    final notificationDetails = Platform.isAndroid
        ?  NotificationDetails(android: androidDetails)
        : NotificationDetails(iOS: iosDetails);

    final now = tz.TZDateTime.now(tz.local);
    if (mon) await _scheduleDayNotification(2, "Monday", now, time, notificationDetails);
    if (tue) await _scheduleDayNotification(3, "Tuesday", now, time, notificationDetails);
    if (wed) await _scheduleDayNotification(4, "Wednesday", now, time, notificationDetails);
    if (thu) await _scheduleDayNotification(5, "Thursday", now, time, notificationDetails);
    if (fri) await _scheduleDayNotification(6, "Friday", now, time, notificationDetails);
    if (sat) await _scheduleDayNotification(7, "Saturday", now, time, notificationDetails);
    if (sun) await _scheduleDayNotification(1, "Sunday", now, time, notificationDetails);
  }

  Future<void> _scheduleDayNotification(int dayOfWeek, String dayName, tz.TZDateTime now, TimeOfDay time, NotificationDetails details) async {
    print("Current time: $now, Target time: $time for $dayName");

    // Calculate the target time for today
    var scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, time.hour, time.minute);

    if (now.weekday == dayOfWeek) {
      // If today is the target day
      if (now.isAfter(scheduledDate)) {
        // If the time has already passed, schedule for the next occurrence
        scheduledDate = scheduledDate.add(Duration(days: 7));
      } else {
        // Schedule for today as the time is still in the future
        print('Scheduling notification for today: $scheduledDate');
        await _notificationsPlugin.zonedSchedule(
          dayOfWeek * 10, // Unique ID for today's notification
          'Scheduled Notification',
          'This is your notification for $dayName at ${time.format(context)}.',
          scheduledDate,
          details,
          uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
          matchDateTimeComponents: DateTimeComponents.time,
          androidScheduleMode: AndroidScheduleMode.exact,
        );

        // Prepare for the next week's notification
        scheduledDate = scheduledDate.add(Duration(days: 7));
      }
    } else {
      // If today is not the target day, calculate the next occurrence
      int daysToAdd = (dayOfWeek - now.weekday + 7) % 7;
      scheduledDate = scheduledDate.add(Duration(days: daysToAdd));
    }

    // Schedule the recurring notification for the future
    print('Scheduling recurring notifications starting: $scheduledDate for $dayName');
    await _notificationsPlugin.zonedSchedule(
      dayOfWeek, // Unique ID for recurring notifications
      'Scheduled Notification',
      'This is your weekly notification for $dayName at ${time.format(context)}.',
      scheduledDate,
      details,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      androidScheduleMode: AndroidScheduleMode.exact,
    );
  }

  Future<void> _requestExactAlarmsPermission() async {
    if (Platform.isAndroid) {
      // Request exact alarms permission for Android 13+
      final androidFlutterPlugin = _notificationsPlugin
          .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

      final granted = await androidFlutterPlugin?.requestExactAlarmsPermission();

      if (granted != null && granted) {
        print("Exact alarms permission granted.");
      } else {
        print("Exact alarms permission denied.");
      }
    }
  }
  Future<void> requestNotificationPermission() async {
    // Check and request POST_NOTIFICATIONS permission
    if (await Permission.notification.isDenied) {
      PermissionStatus status = await Permission.notification.request();
      if (status.isGranted) {
        print('Notification permission granted');
      } else {
        print('Notification permission denied');
      }
    } else {
      print('Notification permission already granted');
    }
  }

}
