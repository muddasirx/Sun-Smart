import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:provider/provider.dart';

import '../providers/historyProvider.dart';
import '../providers/testResultsProvider.dart';
import '../providers/userDataProvider.dart';
import 'graphScreen.dart';

class UserPrescription extends StatefulWidget {
  const UserPrescription({super.key});

  @override
  State<UserPrescription> createState() => _UserPrescriptionState();
}

class _UserPrescriptionState extends State<UserPrescription> {
  bool yesPressed=true;
  bool noPressed=false;
  bool submitPressed=false;


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;
    final historyProvider= Provider.of<HistoryNotifier>(context,listen: false);
    final testResultsProvider= Provider.of<TestResultsNotifier>(context,listen: false);
    final userData = Provider.of<UserDataNotifier>(context, listen: false);

    return Scaffold(
      resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Column(
              children: [
               Image.asset('assets/images/backgrounds/bg6.jpg',width: screenWidth*1.7,),
                Expanded(
                  child: Container(
                    color: Colors.white,
                  ),
                )
              ],
            ),
            SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(onPressed: (){
                      Navigator.pop(context);
                    },
                        icon: Icon(Icons.arrow_back,size: (isTablet(context))?screenWidth* 0.05:screenWidth* 0.065,color: Colors.black87,)),
                    SizedBox(height: (isTablet(context))?screenHeight*0.03:screenHeight*0.00,),
                    Padding(
                      padding:  EdgeInsets.only(left: screenWidth*0.07,right:screenWidth*0.04 ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                                alignment: Alignment.topLeft,
                            child: Padding(
                              padding:  EdgeInsets.only(left: screenWidth*0.12),
                              child: Image.asset('assets/images/supplements/m1.png',height: screenHeight*0.13,),
                            )),
                            SizedBox(height: screenHeight*0.015,),
                            Text(
                              "Are you taking any supplements?",
                              style: GoogleFonts.brunoAceSc(
                                textStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: (isTablet(context))?screenWidth*0.035:screenWidth*0.0405,
                                  //fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(height: screenHeight*0.018,),
                            Row(
                                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(width: screenWidth*0.15,),
                                  yesPressed?choiceSelected("Yes"):choice("Yes"),
                                  SizedBox(width: screenWidth*0.2,),
                                  noPressed?choiceSelected("No"):choice("No"),
                                ],
                              ),


                            (yesPressed)?Center(
                              child: Column(
                                children: [
                                  SizedBox(height: screenHeight*0.06,),
                                  Text(
                                    "Add your pill",
                                    style: GoogleFonts.brunoAceSc(
                                      textStyle: TextStyle(
                                        color: Colors.black,
                                        fontSize: (isTablet(context))?screenWidth*0.035:screenWidth*0.0405,
                                        //fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: screenHeight*0.015,),
                                  Text(
                                    "Add your Vitamin D pill IU and get more precise results",
                                    softWrap: true,
                                    style: GoogleFonts.lato(
                                      textStyle: TextStyle(
                                        color: Colors.black54,
                                        fontSize: (isTablet(context))?screenWidth*0.028:screenWidth*0.035,

                                        //fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),

                                  SizedBox(height: screenHeight*0.025,),
                                  GestureDetector(
                                        onTap: (){
                                          Navigator.pushNamed(context, "/UserHistory");
                                        },
                                          child: Consumer<HistoryNotifier>(builder: (context,value,child){
                                                    return (value.pillAdded)?choiceSelected("Update"):choiceSelected("Add");}),
                                      ),

                                  Consumer<HistoryNotifier>(builder: (context,value,child){
                                    return (value.pillAdded)?
                                    Column(
                                    children: [
                                      SizedBox(height: screenHeight*0.01,),
                                      Text(
                                        "Pills added successfully.",
                                        softWrap: true,
                                        style: GoogleFonts.raleway(
                                          textStyle: TextStyle(
                                            color: Colors.green,
                                            fontSize: (isTablet(context))?screenWidth*0.025:screenWidth*0.032,

                                            //fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ):SizedBox();
                                  }),
                                  SizedBox(height: screenHeight*0.05,),
                                  Text(
                                    "Add your test results",
                                    style: GoogleFonts.brunoAceSc(
                                      textStyle: TextStyle(
                                        color: Colors.black,
                                        fontSize: (isTablet(context))?screenWidth*0.035:screenWidth*0.0405,
                                        //fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: screenHeight*0.015,),
                                  Text(
                                    "Add your recent Serum vitamin D level",
                                    softWrap: true,
                                    style: GoogleFonts.lato(
                                      textStyle: TextStyle(
                                        color: Colors.black54,
                                        fontSize: (isTablet(context))?screenWidth*0.028:screenWidth*0.035,

                                        //fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: screenHeight*0.025,),
                                  GestureDetector(
                                        onTap: (){
                                          Navigator.pushNamed(context, "/BloodLevel");
                                        },
                                          child: Consumer<TestResultsNotifier>(builder: (context,value,child){
                                            return (value.resultsAdded)?choiceSelected("Update"):choiceSelected("Add");}),
                                      ),
                                  Consumer<TestResultsNotifier>(builder: (context,value,child){
                                    return (value.resultsAdded)?
                                      Column(
                                    children: [
                                      SizedBox(height: screenHeight*0.01,),
                                      Text(
                                        "Results added successfully.",
                                        softWrap: true,
                                        style: GoogleFonts.raleway(
                                          textStyle: TextStyle(
                                            color: Colors.green,
                                            fontSize: (isTablet(context))?screenWidth*0.025:screenWidth*0.032,


                                            //fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                      ):SizedBox();
                                  }),

                                ],
                              ),
                            ):SizedBox(),
                            SizedBox(height: screenHeight*0.055,),
                            Center(
                              child: InkWell(
                                splashFactory: NoSplash.splashFactory,
                                onTap: (){

                                  if(yesPressed && (historyProvider.pillAdded || testResultsProvider.resultsAdded) ) {
                                    print("inside yes pressed");
                                     updateUserData();
                                     if(userData.updateHistoryPressed){
                                       Navigator.pop(context);
                                       Navigator.pop(context);
                                       Fluttertoast.showToast(
                                         fontSize: (isTablet(context))?screenWidth*0.03:screenWidth*0.035,
                                         msg: "User History updated successfully.",
                                         toastLength: Toast.LENGTH_SHORT,
                                         gravity: ToastGravity.BOTTOM,
                                         timeInSecForIosWeb: 1,
                                         backgroundColor: Colors.grey[300],
                                         textColor: Colors.black,
                                       );
                                       userData.updateHistoryPressed=false;
                                     }else
                                    Navigator.pushNamed(context, "/SourcesOfVitaminD");
                                  }
                                  else if(noPressed) {
                                    print("Inside no pressed");
                                    removeUserHistory();
                                    if(userData.updateHistoryPressed){
                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(builder: (context) => GraphScreen()),
                                            (route) => false,
                                      );
                                      Fluttertoast.showToast(
                                        fontSize: (isTablet(context))?screenWidth*0.03:screenWidth*0.035,
                                        msg: "User History updated successfully.",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.grey[300],
                                        textColor: Colors.black,
                                      );
                                      userData.updateHistoryPressed=false;
                                    }else
                                    Navigator.pushNamed(context, "/SourcesOfVitaminD");
                                  }
                                  else{
                                    Fluttertoast.showToast(
                                      fontSize: (isTablet(context))?22:13,
                                      msg: "Please add the pill and results to proceed",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                    );
                                  }

                                },
                                child: Container(
                                  height: screenHeight*0.06,
                                  width: screenWidth*0.48,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [Color(0xFFFCC54E), Color(0xFFFDA34F)],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(50.0), // Rounded corners
                                  ),
                                  child: Center(
                                    child: submitPressed?Padding(
                                      padding:  EdgeInsets.symmetric(vertical:  screenHeight*0.019),
                                      child: LoadingIndicator(
                                        indicatorType: Indicator. lineScaleParty, /// Required, The loading type of the widget
                                        colors: const [Colors.white],       /// Optional, The color collections
                                        strokeWidth: 1,              /// Optional, the stroke backgroundColor
                                      ),
                                    ):Text((userData.updateHistoryPressed)?'Update':'Continue',style: TextStyle(fontSize: (isTablet(context))?screenWidth* 0.041:screenWidth* 0.047,//(isTablet(context))?26:18
                                        color: Colors.white,fontWeight: FontWeight.bold),),
                                  ),

                                ),
                              ),
                            )

                          ],
                        ),
                    ),
                  ],
                ),
            )
          ],
        ),
    );
  }

  Future<void> updateUserData() async {
    final loginData = Provider.of<UserDataNotifier>(context, listen: false);
    final historyProvider= Provider.of<HistoryNotifier>(context,listen: false);
    final testResultsProvider= Provider.of<TestResultsNotifier>(context,listen: false);

    CollectionReference userCollection = FirebaseFirestore.instance.collection('UserInfo');

    try {
      print(loginData.uid);
      QuerySnapshot querySnapshot = await userCollection.where('uid', isEqualTo: loginData.uid).get();

      if (querySnapshot.docs.isNotEmpty) {
        if(historyProvider.pillAdded && testResultsProvider.resultsAdded) {
          DocumentReference userDoc = querySnapshot.docs.first.reference;
          String pills =
              "${(historyProvider.m1) ? 'Daily Cal' : ''}${(historyProvider.m2) ? ',Insta CAL-D' : ''}${(historyProvider.m3) ? ',WIL-D' : ''}${(historyProvider.supplementsController.text.isNotEmpty) ? ',${historyProvider.supplementsController.text.trim()}' : ''}";
          await userDoc.update({
            'pills': pills,
            'test value':
                int.parse(testResultsProvider.testValueController.text.trim()),
            'test date': testResultsProvider.dateController.text.trim()
          });

          print('Pills and test results updated successfully');
        }
        else if(historyProvider.pillAdded && !testResultsProvider.resultsAdded){
          DocumentReference userDoc = querySnapshot.docs.first.reference;
          String pills =
              "${(historyProvider.m1) ? 'Daily Cal' : ''}${(historyProvider.m2) ? ',Insta CAL-D' : ''}${(historyProvider.m3) ? ',WIL-D' : ''}${(historyProvider.supplementsController.text.isNotEmpty) ? ',${historyProvider.supplementsController.text.trim()}' : ''}";
          await userDoc.update({
            'pills': pills,
            'test value':0,
            'test date':''
          });

          print('Pills updated successfully');
        }
        else if(!historyProvider.pillAdded && testResultsProvider.resultsAdded){
          DocumentReference userDoc = querySnapshot.docs.first.reference;

          await userDoc.update({
            'pills':'',
            'test value': int.parse(testResultsProvider.testValueController.text.trim()),
            'test date': testResultsProvider.dateController.text.trim()
          });

          print('Test Results updated successfully');
        }
        loginData.fetchUserData(loginData.uid);
      } else {
        print('No user found with the provided userID');
      }
    } catch (e) {
      print('Error updating user info: $e');
    }
  }

  Future<void> removeUserHistory()async {
    print("Inside remove history method");
    final loginData = Provider.of<UserDataNotifier>(context, listen: false);
    final historyProvider= Provider.of<HistoryNotifier>(context,listen: false);
    final testResultsProvider= Provider.of<TestResultsNotifier>(context,listen: false);

    CollectionReference userCollection = FirebaseFirestore.instance.collection('UserInfo');

    try {
      print(loginData.uid);
      QuerySnapshot querySnapshot = await userCollection.where('uid', isEqualTo: loginData.uid).get();

      if (querySnapshot.docs.isNotEmpty) {
          DocumentReference userDoc = querySnapshot.docs.first.reference;

          await userDoc.update({
            'pills': '',
            'test value': 0,
            'test date': ''
          });
          loginData.fetchUserData(loginData.uid);
          print('Pills and test results removed successfully');

        }

      else {
        print('No user found with the provided userID');
      }
    } catch (e) {
      print('Error updating user info: $e');
    }
  }

  bool isTablet(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return screenWidth >= 600 && screenWidth <= 1024;
  }

  Widget choiceSelected(String ch){
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      decoration: BoxDecoration(
        color: Colors.cyan,
        borderRadius: BorderRadius.circular(30)
      ),
      child:Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth*0.04,vertical: screenHeight*0.015),
        child: Text(
          ch,
          style: GoogleFonts.brunoAceSc(
            textStyle: TextStyle(
              color: Colors.white,
              fontSize: (isTablet(context))?screenWidth*0.032:screenWidth*0.038,
              //fontWeight: FontWeight.bold,
            ),
          ),
        ),
      )
    );
  }
  Widget choice(String ch){
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: (){
        if(ch=="Yes" && !yesPressed){
          setState(() {
            noPressed=false;
            yesPressed=true;
          });
        }
        else if(ch=="No" && !noPressed){
          setState(() {
            yesPressed=false;
            noPressed=true;
          });
        }
      },
      child: Container(
          decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(20)
          ),
          child:Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth*0.04,vertical: screenHeight*0.015),
            child: Text(
              ch,
              style: GoogleFonts.brunoAceSc(
                textStyle: TextStyle(
                  color: Colors.black,
                  fontSize: (isTablet(context))?screenWidth*0.032:screenWidth*0.038,
                  //fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )
      )
    );
  }



}