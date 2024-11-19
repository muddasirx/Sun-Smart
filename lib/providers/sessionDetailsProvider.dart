import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/providers/userDataProvider.dart';

class sessionDetailsNotifier with ChangeNotifier {
    int clothingTypeNumber=0;
    int sessionDurationMinutes=0;
    int timeTillSunsetMinutes=0;
    int sessionTakenTime=0;
    double uvIndex=0.0;
    int vitaminDIntake=1000;
    int spf=0;
    bool sessionPossible=true;
    bool nightTime=false;
    bool sessionUpdated=false;


    void nightArrived(){
      nightTime=true;
      notifyListeners();
    }
    void sessionSuspended(){
      sessionPossible=false;
      notifyListeners();
    }
    void sessionWillProceed(){
      sessionPossible=true;
      notifyListeners();
    }
    void addSessionTakenTime(int minutes){
      sessionTakenTime=minutes;
      notifyListeners();
    }
    void addSessionDuration(int minutes){
      sessionDurationMinutes=minutes;
      notifyListeners();
    }
    void addSunsetDuration(int minutes){
      timeTillSunsetMinutes=minutes;
      notifyListeners();
    }
    void addUvIndex(double uv){
      uvIndex=uv;
      notifyListeners();
    }
    void addVitaminDIntake(int iu){
      vitaminDIntake=iu;
      notifyListeners();
    }
    void addClothingTypeNumber(int num){
      clothingTypeNumber=num;
      notifyListeners();
    }
    void addSPF(int x){
      spf=x;
      notifyListeners();
    }


}