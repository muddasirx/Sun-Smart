import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:untitled/SplashScreen.dart';
import 'package:untitled/pages/LoginScreen.dart';
import 'package:untitled/pages/SignupScreen.dart';
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
import 'package:untitled/pages/disclaimer.dart';
import 'package:untitled/pages/upcomingSession.dart';
import 'package:untitled/pages/update/updateProfile.dart';
import 'package:untitled/pages/userHistory.dart';
import 'package:untitled/pages/userPrescription.dart';
import 'package:untitled/providers/countDownDetailsProvider.dart';
import 'package:untitled/providers/historyProvider.dart';
import 'package:untitled/providers/sessionDetailsProvider.dart';
import 'package:untitled/providers/testResultsProvider.dart';
import 'package:untitled/providers/userDataProvider.dart';
import 'package:untitled/theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
      title: 'Flutter Demo',
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
          "/Disclaimer" : (context) => Disclaimer(),
          "/UpcomingSession" : (context) => UpcomingSession(),
          "/countDownScreen" : (context) => countDownScreen(),
          "/SessionFinished" : (context) => SessionFinished(),
          "/GraphScreen" : (context) => GraphScreen(),
          "/UpdateProfile" : (context) =>UpdateProfile()
    },
    );
  }
}
