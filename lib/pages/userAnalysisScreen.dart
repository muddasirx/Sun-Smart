import 'package:flutter/cupertino.dart';
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
class UserAnalysis extends StatefulWidget {
  const UserAnalysis({super.key});

  @override
  State<UserAnalysis> createState() => _UserAnalysisState();
}

class _UserAnalysisState extends State<UserAnalysis> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;

    return Scaffold(

    );
  }

  bool isTablet(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return screenWidth >= 600 && screenWidth <= 1024;
  }
}
