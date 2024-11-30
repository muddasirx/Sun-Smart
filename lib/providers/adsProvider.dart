import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class AdsNotifier with ChangeNotifier {
  int adDisplayed=-1;
  List<List<dynamic>>adPages=[];

  List<bool> displayed=[];

  void pushAd(List<dynamic> ad){
    print('------------Pushing Ad------------');
    adPages.add(ad);
    print('------------Ad Pushed------------');
    displayed.add(false);
    notifyListeners();
  }

  void adDisplay(bool value,int index){
    displayed[index]=value;
    notifyListeners();
  }
  void removeAd(int index){
    adPages.removeAt(index);
    notifyListeners();
  }
  void replaceAd(List<dynamic> ad,int index){
    adPages[index]=ad;
    notifyListeners();
  }
}
