import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EstimatedBloodLevel extends StatefulWidget {
  const EstimatedBloodLevel({super.key});

  @override
  State<EstimatedBloodLevel> createState() => _EstimatedBloodLevelState();
}

class _EstimatedBloodLevelState extends State<EstimatedBloodLevel> {
  bool hrsPressed=true,minsPressed=false;
  bool t1=false,t2=true,t3=false,t4=false;
  TextEditingController _timeSpentController=TextEditingController();
  String dropDownValue="1";
  bool x1=false, x2=false,x3=false,x4=false,x5=false;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;

    return Scaffold(
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
                  SizedBox(height: (isTablet(context))?screenHeight*0.17:screenHeight*0.08,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      t1?choiceSelected("8-10 am"):choice("8-10 am"),
                      t2?choiceSelected("10-12 pm"):choice("10-12 pm"),
                      t3?choiceSelected("12-2 pm"):choice("12-2 pm"),
                      t4?choiceSelected("2-4 pm"):choice("2-4 pm"),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: screenWidth*0.04),
                    child:Column(
                        children: [
                          SizedBox(height:screenHeight*0.04,),
                          Padding(
                            padding:  EdgeInsets.symmetric(horizontal: screenWidth*0.1),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          controller: _timeSpentController,
                                          cursorColor: Colors.black54,
                                          cursorWidth: 1.5,
                                          //inputFormatters: [LengthLimitingTextInputFormatter(3),],
                                          style: TextStyle(color: Colors.black87, fontSize: (isTablet(context))?screenWidth* 0.037:screenWidth* 0.047,),//(isTablet(context))?23:15),
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            errorStyle: TextStyle(color: Colors.red),
                                            contentPadding: EdgeInsets.only(left: screenWidth*0.04,right: screenWidth*0.00,top: (isTablet(context))?screenHeight*0.003:screenHeight*0.013),
                                            hintText: "Time Spent",
                                            hintStyle: TextStyle(
                                              fontFamily: 'Lato',
                                                  color: Colors.black54,
                                                  fontSize: (isTablet(context))?screenWidth* 0.036:screenWidth* 0.044,//(isTablet(context))?23:16,
                                                  // fontWeight: themeNotifier.isDarkTheme? FontWeight.normal:FontWeight.bold
                                                ),
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
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: screenWidth*0.01,),
                                      hrsPressed?choiceSelected("hours"):timeChoice("hours"),
                                      minsPressed?choiceSelected("mins"):timeChoice("mins"),
                                    ],
                                  ),
                                SizedBox(height: screenHeight*0.03,),
                                Row(
                                  children: [
                                    Text(
                                      "Times per week:",
                                      style: TextStyle(
                                        fontFamily: 'Raleway',
                                          color: Colors.black,
                                          fontSize: (isTablet(context))?screenWidth*0.036:screenWidth*0.044,
                                          //fontWeight: FontWeight.bold,
                                        ),
                                    ),
                                    SizedBox(width: screenWidth*0.03),
                                    DropdownButton<String>(
                                        value: dropDownValue,
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            dropDownValue = newValue!;
                                          });
                                        },
                                        dropdownColor: Colors.grey[300],
                                        style: TextStyle(
                                          color:  Colors.black87,
                                          fontSize: (isTablet(context))?screenWidth* 0.034:screenWidth* 0.042,//(isTablet(context))?23:15,
                                        ),
                                        underline: Container(
                                          height: 2,
                                          color:Colors.grey,
                                        ),
                                        icon: Icon(
                                          Icons.arrow_drop_down,
                                          color: Colors.black54,
                                        ),
                                        items: <String>['1','2','3','4','5']
                                            .map<DropdownMenuItem<String>>(
                                              (String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            );
                                          },
                                        ).toList()
                                    ),
                                  ],
                                ),
                                SizedBox(height: screenHeight*0.05,),
                                Text(
                                  "Skin Exposed",
                                  style: TextStyle(
                                    fontFamily: 'BrunoAceSC',
                                      color: Colors.black,
                                      fontSize: (isTablet(context))?screenWidth*0.038:screenWidth*0.044,
                                      //fontWeight: FontWeight.bold,
                                    ),
                                ),
                                SizedBox(height: screenHeight*0.03,),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Wearing",
                                    style: TextStyle(
                                      fontFamily: 'Raleway',
                                        color: Colors.black,
                                        fontSize: (isTablet(context))?screenWidth*0.036:screenWidth*0.044,
                                       // fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "Exposed",
                                    style: TextStyle(
                                      fontFamily: 'Raleway',
                                        color: Colors.black,
                                        fontSize: (isTablet(context))?screenWidth*0.036:screenWidth*0.044,
                                        //fontWeight: FontWeight.bold,
                                      ),
                                  ),
                                ],
                              ),
                              SizedBox(height: screenHeight*0.005,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Transform.scale(
                                    scale: (isTablet(context)) ? 1.4 : 0.9,
                                    child: Checkbox(
                                      value: x1,
                                      checkColor: Colors.white,
                                      activeColor: Colors.orange,
                                      side: BorderSide(color: Colors.black54, width: 2),
                                      onChanged: (bool? value) {
                                        setState(() {
                                          x1 = value!;
                                          x2=false;
                                          x3=false;
                                          x4=false;
                                          x5=false;
                                        });
                                      },
                                    ),
                                  ),
                                  Text(
                                    "Long pants, sleeved shirts",
                                    style: TextStyle(
                                      fontFamily: 'Raleway',
                                        color: Colors.black54,
                                        fontSize: (isTablet(context))?screenWidth*0.034:screenWidth*0.044,
                                        //fontWeight: FontWeight.bold,
                                      ),
                                  ),
                                  Text(
                                    "10",
                                    style: TextStyle(
                                      fontFamily: 'Raleway',
                                        color: Colors.black54,
                                        fontSize: (isTablet(context))?screenWidth*0.034:screenWidth*0.044,
                                        //fontWeight: FontWeight.bold,
                                      ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Transform.scale(
                                    scale: (isTablet(context)) ? 1.4 : 0.9,
                                    child: Checkbox(
                                      value: x2,
                                      checkColor: Colors.white,
                                      activeColor: Colors.orange,
                                      side: BorderSide(color: Colors.black54, width: 2),
                                      onChanged: (bool? value) {
                                        setState(() {
                                          x2 = value!;
                                          x1=false;
                                          x3=false;
                                          x4=false;
                                          x5=false;
                                        });
                                      },
                                    ),
                                  ),
                                  Text(
                                    "Short sleeves, pants",
                                    style: TextStyle(
                                      fontFamily: 'Raleway',
                                        color: Colors.black54,
                                        fontSize: (isTablet(context))?screenWidth*0.034:screenWidth*0.044,
                                        //fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "30",
                                    style: TextStyle(
                                      fontFamily: 'Raleway',
                                        color: Colors.black54,
                                        fontSize: (isTablet(context))?screenWidth*0.034:screenWidth*0.044,
                                        //fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Transform.scale(
                                    scale: (isTablet(context)) ? 1.4 : 0.9,
                                    child: Checkbox(
                                      value: x3,
                                      checkColor: Colors.white,
                                      activeColor: Colors.orange,
                                      side: BorderSide(color: Colors.black54, width: 2),
                                      onChanged: (bool? value) {
                                        setState(() {
                                          x3 = value!;
                                          x2=false;
                                          x1=false;
                                          x4=false;
                                          x5=false;
                                        });
                                      },
                                    ),
                                  ),
                                  Text(
                                    "Short sleeves, shorts",
                                    style: TextStyle(
                                      fontFamily: 'Raleway',
                                        color: Colors.black54,
                                        fontSize: (isTablet(context))?screenWidth*0.034:screenWidth*0.044,
                                        //fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "50",
                                    style: TextStyle(
                                      fontFamily: 'Raleway',
                                        color: Colors.black54,
                                        fontSize: (isTablet(context))?screenWidth*0.034:screenWidth*0.044,
                                        //fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Transform.scale(
                                    scale: (isTablet(context)) ? 1.4 : 0.9,
                                    child: Checkbox(
                                      value: x4,
                                      checkColor: Colors.white,
                                      activeColor: Colors.orange,
                                      side: BorderSide(color: Colors.black54, width: 2),
                                      onChanged: (bool? value) {
                                        setState(() {
                                          x4 = value!;
                                          x2=false;
                                          x3=false;
                                          x1=false;
                                          x5=false;
                                        });
                                      },
                                    ),
                                  ),
                                  Text(
                                    "Shorts, no shirt",
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontFamily: 'Raleway',
                                        fontSize: (isTablet(context))?screenWidth*0.034:screenWidth*0.044,
                                        //fontWeight: FontWeight.bold,

                                    ),
                                  ),
                                  Text(
                                    "70",
                                    style: TextStyle(
                                        fontFamily: 'Raleway',
                                        color: Colors.black54,
                                        fontSize: (isTablet(context))?screenWidth*0.034:screenWidth*0.044,
                                        //fontWeight: FontWeight.bold,
                                      ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Transform.scale(
                                    scale: (isTablet(context)) ? 1.4 : 0.9,
                                    child: Checkbox(
                                      value: x5,
                                      checkColor: Colors.white,
                                      activeColor: Colors.orange,
                                      side: BorderSide(color: Colors.black54, width: 2),
                                      onChanged: (bool? value) {
                                        setState(() {
                                          x5 = value!;
                                          x2=false;
                                          x3=false;
                                          x4=false;
                                          x1=false;
                                        });
                                      },
                                    ),
                                  ),
                                  Text(
                                    "Swimwear",
                                    style: TextStyle(
                                      fontFamily: 'Raleway',
                                        color: Colors.black54,
                                        fontSize: (isTablet(context))?screenWidth*0.034:screenWidth*0.044,
                                        //fontWeight: FontWeight.bold,
                                      ),
                                  ),
                                  Text(
                                    "80",
                                    style: TextStyle(
                                      fontFamily: 'Raleway',
                                        color: Colors.black54,
                                        fontSize: (isTablet(context))?screenWidth*0.034:screenWidth*0.044,
                                        //fontWeight: FontWeight.bold,
                                      ),
                                  ),
                                ],
                              ),
                              SizedBox(height: screenHeight*0.04,),
                              GestureDetector(
                                onTap: (){
                                  Navigator.pushNamed(context, "/Spf");
                                },
                                child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.cyan,
                                        borderRadius: BorderRadius.circular(20)
                                    ),
                                    child:Padding(
                                      padding: EdgeInsets.symmetric(horizontal: screenWidth*0.04,vertical: screenHeight*0.015),
                                      child: Text(
                                        "Save",
                                        style: TextStyle(
                                          fontFamily: 'BrunoAceSC',
                                            color: Colors.white,
                                            fontSize: (isTablet(context))?screenWidth*0.032:screenWidth*0.038,
                                            //fontWeight: FontWeight.bold,
                                          ),
                                      ),
                                    )
                                ),
                              ),
                            ],
                          )
              
              
              
              
              
                        ],
                      ),
              
              
                  )
              
                ],
              ),
            ),
          )
        ],
      )
    );
  }

  bool isTablet(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return screenWidth >= 600 && screenWidth <= 1024;
  }
  Widget timeChoice(String ch){
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
        onTap: (){
          if(ch=="hours"){
            setState(() {
              minsPressed=false;
              hrsPressed=true;
            });
          }
          else if(ch=="mins"){
            setState(() {
              hrsPressed=false;
              minsPressed=true;
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
                style: TextStyle(
                  fontFamily: 'BrunoAceSC',
                    color: Colors.black,
                    fontSize: (isTablet(context))?screenWidth*0.032:screenWidth*0.038,
                    //fontWeight: FontWeight.bold,
                  ),
              ),
            )
        )
    );
  }

  Widget choiceSelected(String ch){
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(
        decoration: BoxDecoration(
            color: Colors.cyan,
            borderRadius: BorderRadius.circular(80)
        ),
        child:Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth*0.03,vertical: screenHeight*0.013),
          child: Text(
            ch,
            style:  TextStyle(
              fontFamily: 'BrunoAceSC',
                color: Colors.white,
                fontSize: (isTablet(context))?screenWidth*0.032:screenWidth*0.032,
                //fontWeight: FontWeight.bold,
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
          if(ch=="8-10 am"){
            setState(() {
              t1=true;
              t2=false;
              t3=false;
              t4=false;
            });
          }
          else if(ch=="10-12 pm"){
            setState(() {
              t1=false;
              t2=true;
              t3=false;
              t4=false;
            });
          }else if(ch=="12-2 pm"){
            setState(() {
              t1=false;
              t2=false;
              t3=true;
              t4=false;
            });
          }else if(ch=="2-4 pm"){
            setState(() {
              t1=false;
              t2=false;
              t3=false;
              t4=true;
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
                style: TextStyle(
                  fontFamily: 'BrunoAceSC',
                    color: Colors.black,
                    fontSize: (isTablet(context))?screenWidth*0.032:screenWidth*0.032,
                    //fontWeight: FontWeight.bold,
                  ),
              ),
            )
        )
    );
  }

}
