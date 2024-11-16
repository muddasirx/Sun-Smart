import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../providers/testResultsProvider.dart';

class BloodLevel extends StatefulWidget {
  const BloodLevel({super.key});

  @override
  State<BloodLevel> createState() => _BloodLevelState();
}

class _BloodLevelState extends State<BloodLevel> {
  TextEditingController _dateController = TextEditingController();
  TextEditingController _testValueController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final testResultsProvider= Provider.of<TestResultsNotifier>(context,listen: false);
    setState(() {
      _dateController.text=testResultsProvider.dateController.text;
      _testValueController.text= testResultsProvider.testValueController.text ;
    });
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;

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
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(onPressed: (){
                    Navigator.pop(context);
                  },
                      icon: Icon(Icons.arrow_back,size: (isTablet(context))?screenWidth* 0.05:screenWidth* 0.065,color: Colors.black87,)),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: screenWidth*0.05),
                    child: Center(
                      child: Column(
                        children: [
                          SizedBox(height: (isTablet(context))?screenHeight*0.11:screenHeight*0.07,),
                          Text(
                              "Vitamin D Blood Level",
                              style: GoogleFonts.brunoAceSc(
                                textStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: (isTablet(context))?screenWidth*0.041:screenWidth*0.048,
                                  //fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          SizedBox(height: screenHeight*0.03,),
                          Text(
                              "Enter the results of your most recent serum vitamin D level (if it was less then 90 days ago):",
                              style: GoogleFonts.raleway(
                                textStyle: TextStyle(
                                  color: Colors.black87,
                                  fontSize: (isTablet(context))?screenWidth*0.035:screenWidth*0.042,
                                  //fontWeight: FontWeight.bold,
                                ),
                              ),
                              softWrap: true,
                              textAlign: TextAlign.center,
                            ),
                          SizedBox(height: screenHeight*0.09,),
                          Padding(
                            padding:  EdgeInsets.symmetric(horizontal: screenWidth*0.2),
                            child: TextFormField(
                              controller: _testValueController,
                              cursorColor: Colors.black54,
                              cursorWidth: 1.5,
                              //inputFormatters: [LengthLimitingTextInputFormatter(3),],
                              style: TextStyle(color: Colors.black87, fontSize: (isTablet(context))?screenWidth* 0.036:screenWidth* 0.045,),//(isTablet(context))?23:15),
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                errorStyle: TextStyle(color: Colors.red),
                                contentPadding: EdgeInsets.only(left: screenWidth*0.04,right: screenWidth*0.04,top: (isTablet(context))?screenHeight*0.003:screenHeight*0.013),
                                hintText: "Test value",
                                hintStyle: GoogleFonts.lato(
                                    textStyle:TextStyle(
                                      color: Colors.black54,
                                      fontSize: (isTablet(context))?screenWidth* 0.036:screenWidth* 0.044,//(isTablet(context))?23:16,
                                      // fontWeight: themeNotifier.isDarkTheme? FontWeight.normal:FontWeight.bold
                                    )),
                                enabledBorder: UnderlineInputBorder(
                                  //borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    width: 1.5,
                                    color: Colors.black54,
                                  ),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  //borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    width: 1.5,
                                    color: Colors.black54,
                                  ),
                                ),
                                suffixText: "ng/ml",
                                suffixStyle: TextStyle(
                                  color: Colors.orange,
                                  fontSize: (isTablet(context))?screenWidth* 0.038:screenWidth* 0.047,//18,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: screenHeight*0.04,),
                          Padding(
                            padding:  EdgeInsets.symmetric(horizontal: screenWidth*0.2),
                            child: TextFormField(
                              controller: _dateController,
                              readOnly: true,
                              style: TextStyle(color: Colors.black87, fontSize: (isTablet(context))?screenWidth* 0.036:screenWidth* 0.043,//(isTablet(context))?23:15
                              ),
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(left: screenWidth*0.03,right: screenWidth*0.03,top: (isTablet(context))?screenHeight*0.003:screenHeight*0.016),
                                  hintText: 'Taken on',
                                  hintStyle: GoogleFonts.lato(
                                      textStyle:TextStyle(
                                        color: Colors.black54,
                                        fontSize: (isTablet(context))?screenWidth* 0.036:screenWidth* 0.044,//(isTablet(context))?23:16,
                                        // fontWeight: themeNotifier.isDarkTheme? FontWeight.normal:FontWeight.bold
                                      )),
                                  focusedErrorBorder: UnderlineInputBorder(
                                    // borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      width: 1.5,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    //borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      width: 1.5,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  suffixIcon: (_dateController.text.isNotEmpty)?IconButton(
                                    onPressed: (){
                                        setState(() {
                                          _dateController.clear();
                                        });
                                    },
                                    icon: Icon(Icons.delete_outline_rounded,color: Colors.grey,size: (isTablet(context))?screenWidth* 0.048:screenWidth* 0.06,),
                                  ):null,
                                  prefixIcon: Padding(
                                    padding:  EdgeInsets.only(right: (isTablet(context))?screenWidth* 0.015:0),
                                    child: Icon(Icons.calendar_month,color: Colors.grey,size: (isTablet(context))?screenWidth* 0.048:screenWidth* 0.06,),
                                  ) //(isTablet(context))?34:24,)
                              ),
              
                              onTap: () => _selectDate(context),
                            ),
                          ),
                          //SizedBox(height: screenHeight*0.06,),
                          SizedBox(height: screenHeight*0.08,),
                          Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Color(0xFFFCC54E), Color(0xFFFDA34F)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(50.0), // Rounded corners
                              ),
                              child: TextButton(
                                onPressed: () {
                                  final testResultsProvider= Provider.of<TestResultsNotifier>(context,listen: false);

                                  if(_testValueController.text.isNotEmpty && _dateController.text.isNotEmpty){
                                    testResultsProvider.dateController.text=_dateController.text.trim();
                                    testResultsProvider.testValueController.text=_testValueController.text.trim() ;
                                    testResultsProvider.addResult();
                                    Navigator.pop(context);
                                  }else if(_testValueController.text.isEmpty && _dateController.text.isEmpty){
                                    testResultsProvider.testValueController.clear();
                                    testResultsProvider.dateController.clear();
                                    testResultsProvider.removeResult();
                                    Navigator.pop(context);
                                  }else{
                                    Fluttertoast.showToast(
                                      fontSize: (isTablet(context))?22:13,
                                      msg: "Please fill in  both the fields to proceed",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                    );
                                  }

                                },
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.white, padding: EdgeInsets.symmetric(horizontal: (isTablet(context))?screenWidth*0.12:screenWidth*0.15, vertical: (isTablet(context))?screenHeight*0.014:screenHeight*0.01), // Text color
                                  textStyle: TextStyle(fontSize: (isTablet(context))?screenWidth*0.04:screenWidth*0.047, fontWeight: FontWeight.bold),
                                ),
                                child: Text('Confirm'),
                              ),
                            ),

                          /*
                          GestureDetector(
                            onTap: (){
                              Navigator.pop(context);
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.cyan,
                                    borderRadius: BorderRadius.circular(50)
                                ),
                                child:Padding(
                                  padding: EdgeInsets.symmetric(horizontal: screenWidth*0.06,vertical: screenHeight*0.015),
                                  child: Text(
                                    "Save",
                                    style: GoogleFonts.brunoAceSc(
                                      textStyle: TextStyle(
                                        color: Colors.white,
                                        fontSize: (isTablet(context))?screenWidth*0.032:screenWidth*0.038,
                                        //fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                )
                            ),
                          ),
                          SizedBox(height: screenHeight*0.06,),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: screenWidth*0.09),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Divider(
                                    //thickness: 2,
                                    color: Colors.black54
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  child: Text(
                                    "OR",
                                    style: GoogleFonts.raleway(
                                      textStyle: TextStyle(
                                        color: Colors.black54,
                                        fontSize: (isTablet(context))?screenWidth*0.0355:screenWidth*0.043,
                                        //fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Divider(
                                    // thickness: 2,
                                    color: Colors.black54
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: screenHeight*0.06,),
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xFFFCC54E), Color(0xFFFDA34F)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(30.0), // Rounded corners
                            ),
                            child: TextButton(
                              onPressed: () {
                                    Navigator.pushNamed(context, "/EstimatedVitaminDBloodLevel");
                              },
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.white, padding: EdgeInsets.symmetric(horizontal: (isTablet(context))?screenWidth*0.06:screenWidth*0.1, vertical: (isTablet(context))?screenHeight*0.014:screenHeight*0.01), // Text color
                                textStyle: TextStyle(fontSize: (isTablet(context))?screenWidth*0.04:screenWidth*0.042, fontWeight: FontWeight.bold),
                              ),
                              child: Text('My Estimated Vitamin D Level'),
                            ),
                          )
                          */
              
              
              
                        ],
                      ),
                    ),
              
                  )
              
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  bool isTablet(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return screenWidth >= 600 && screenWidth <= 1024;
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(Duration(days: 90)),
      lastDate: DateTime.now(),
    );

    if (selectedDate != null) {
      setState(() {
        _dateController.text = "${selectedDate.toLocal()}".split(' ')[0];
      });
      FocusScope.of(context).unfocus();
    }
  }

}
