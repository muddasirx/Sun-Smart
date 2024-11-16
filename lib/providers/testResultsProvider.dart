import 'package:flutter/cupertino.dart';

class TestResultsNotifier with ChangeNotifier {
  TextEditingController dateController = TextEditingController();
  TextEditingController testValueController = TextEditingController();
  bool resultsAdded=false;

  void addResult(){
    resultsAdded=true;
    notifyListeners();
  }
  void removeResult(){
    resultsAdded=false;
    notifyListeners();
  }

}