import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:untitled/SplashScreen.dart';
import 'package:untitled/pages/LoginScreen.dart';
import 'package:untitled/pages/SignupScreen.dart';
import 'package:untitled/pages/admin%20screens/manageAds.dart';
import 'package:untitled/pages/admin%20screens/createAd.dart';
import 'package:untitled/pages/reminder.dart';
import 'package:untitled/pages/testResults.dart';
import 'package:untitled/pages/clothingType.dart';
import 'package:untitled/pages/countDownScreen.dart';
import 'package:untitled/pages/estimatedBloodLevel.dart';
import 'package:untitled/pages/estimatedVitaminDLevel.dart';
import 'package:untitled/pages/forgotPassword.dart';
import 'package:untitled/pages/graphScreen.dart';
import 'package:untitled/pages/locationAccess.dart';
import 'package:untitled/pages/sessionFinished.dart';
import 'package:untitled/pages/skinTypeSelection.dart';
import 'package:untitled/pages/sourcesOfVitaminD.dart';
import 'package:untitled/pages/spf.dart';
import 'package:untitled/pages/upcomingSession.dart';
import 'package:untitled/pages/update/updatePassword.dart';
import 'package:untitled/pages/update/updateProfile.dart';
import 'package:untitled/pages/userHistory.dart';
import 'package:untitled/pages/userPrescription.dart';
import 'package:untitled/providers/adminPanelProvider.dart';
import 'package:untitled/providers/adsProvider.dart';
import 'package:untitled/providers/countDownDetailsProvider.dart';
import 'package:untitled/providers/historyProvider.dart';
import 'package:untitled/providers/sessionDetailsProvider.dart';
import 'package:untitled/providers/testResultsProvider.dart';
import 'package:untitled/providers/userDataProvider.dart';
import 'package:untitled/theme.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  /*AwesomeNotifications().initialize(
      'assets/images/icon.png',
      [
        NotificationChannel(
            channelKey: 'alerts',
            channelName: 'Alerts',
            channelDescription: 'Notification tests as alerts',
            playSound: true,
            onlyAlertOnce: true,
            groupAlertBehavior: GroupAlertBehavior.Children,
            importance: NotificationImportance.High,
            defaultPrivacy: NotificationPrivacy.Private,
            defaultColor: Colors.deepPurple,
            ledColor: Colors.deepPurple)
      ],
      debug: true) ;*/

  tz.initializeTimeZones();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => UserDataNotifier()),
      ChangeNotifierProvider(create: (_) => HistoryNotifier()),
      ChangeNotifierProvider(create: (_) => TestResultsNotifier()),
      ChangeNotifierProvider(create: (_) => sessionDetailsNotifier()),
      ChangeNotifierProvider(create: (_) =>countDownDetailsNotifier()),
      ChangeNotifierProvider(create: (_) =>AdminPanelNotifier()),
      ChangeNotifierProvider(create: (_) =>AdsNotifier()),
    ],
    child: MyApp(),
  ),);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      title: 'Wilson\'s Healthcare',
        routes:  {
          "/": (context) => SplashScreen(),
          "/LoginPage": (context) => LoginScreen(),
          "/Register": (context) => SignupScreen(),
          "/forgotPassword": (context) => ForgotPassword(),
          "/SkinType" : (context) => SkinType(),
          "/UserPrescription" : (context) => UserPrescription(),
          "/UserHistory" : (context) =>  UserHistory(),
          "/SourcesOfVitaminD" : (context) =>  SourcesOfVitaminD(),
          "/BloodLevel" : (context) =>  BloodLevel(),
          "/EstimatedBloodLevel" : (context) =>  EstimatedBloodLevel(),
          "/EstimatedVitaminDBloodLevel" : (context) => EstimatedVitaminDlevel(),
          "/Spf" : (context) => Spf(),
          "/ClothingType" : (context) => ClothingType(),
          "/LocationAccess" : (context) => LocationAccess(),
          "/UpcomingSession" : (context) => UpcomingSession(),
          "/countDownScreen" : (context) => countDownScreen(),
          "/SessionFinished" : (context) => SessionFinished(),
          "/GraphScreen" : (context) => GraphScreen(),
          "/UpdateProfile" : (context) =>UpdateProfile(),
          "/UpdatePassword" : (context) =>UpdatePassword(),
          "/ManageAds"  : (context) => ManageAds(),
          "/CreateAd" : (context) => CreateAd(),
          "/Reminder" : (context) =>Reminder(),
    },
    );
  }
}
