import 'package:flutter/cupertino.dart';

class HistoryNotifier with ChangeNotifier {
  bool m1=false,m2=false,m3=false;
  bool pillAdded=false;
  TextEditingController supplementsController=TextEditingController();

  void pillSelected(){
    pillAdded=true;
    notifyListeners();
  }
  void pillRemoved(){
    pillAdded=false;
    notifyListeners();
  }
  void m1Pressed(bool x){
    m1=x;
    notifyListeners();
  }
  void m2Pressed(bool x){
    m2=x;
    notifyListeners();
  }
  void m3Pressed(bool x){
    m3=x;
    notifyListeners();
  }
}