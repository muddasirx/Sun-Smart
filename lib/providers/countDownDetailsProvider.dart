import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/providers/sessionDetailsProvider.dart';
import 'package:untitled/providers/userDataProvider.dart';

class countDownDetailsNotifier with ChangeNotifier {
  bool isPaused=false;
  int iuConsumed = 0;
  Timer? incrementTimer;
  int incrementMilliSeconds= 0;
  int timeSpentInSeconds = 0;

  void startIncrementTimer(sessionDetailsNotifier sessionDetails) {
    incrementTimer = Timer.periodic(Duration(milliseconds: incrementMilliSeconds), (timer) {
      if (!isPaused) {
          if(iuConsumed<sessionDetails.vitaminDIntake){
            iuConsumed += 1;
          }
          notifyListeners();
      }
    });
  }

  void resetData(){
    print("IU Consumed before reset: ${iuConsumed}");
    isPaused=false;
    iuConsumed=0;
    notifyListeners();
    print("IU Consumed after reset: ${iuConsumed}");
  }
}