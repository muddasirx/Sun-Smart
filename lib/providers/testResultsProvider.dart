import 'package:flutter/cupertino.dart';

class TestResultsNotifier with ChangeNotifier {
  TextEditingController dateController = TextEditingController();
  TextEditingController testValueController = TextEditingController();
  bool resultsAdded=false;
  bool resultSubmitText=false;

  void displaySubmissionText(){
    resultSubmitText=true;
    notifyListeners();
  }
  void removeSubmissionText(){
    resultSubmitText=false;
    notifyListeners();
  }
  void addResult(){
    resultsAdded=true;
    notifyListeners();
  }
  void removeResult(){
    resultsAdded=false;
    notifyListeners();
  }

}