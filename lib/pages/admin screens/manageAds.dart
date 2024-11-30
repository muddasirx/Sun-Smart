import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:untitled/pages/admin%20screens/updateAd.dart';
import 'package:untitled/pages/admin%20screens/viewAd.dart';

import '../../providers/adminPanelProvider.dart';
import '../../providers/adsProvider.dart';

class ManageAds extends StatefulWidget {
  const ManageAds({super.key});

  @override
  State<ManageAds> createState() => _ManageAdsState();
}

class _ManageAdsState extends State<ManageAds> {
  bool hasConnection = true;
  bool deletePressed = false;
  int deleteAdIndex=-1;

  @override
  void initState() {
    print('--------------Manage Ad Page--------------');
    super.initState();
    checkConnection();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;
    final adminPanel = Provider.of<AdminPanelNotifier>(context, listen: false);
    final adsDetails = Provider.of<AdsNotifier>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Manage Ads",
          style: TextStyle(
            fontFamily: 'BrunoAceSC',
            color: Colors.black,
            fontSize: (isTablet(context))?screenWidth* 0.038:screenWidth* 0.051,//(isTablet(context))?27:20,
            //fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: IconThemeData(
          color: Colors.black87,
          size: (isTablet(context)) ? screenWidth * 0.046 : screenWidth *
              0.06, //(isTablet(context))?30:23
        ),

      ),

      body: Stack(
        children: [
          Consumer<AdsNotifier>(
            builder: (context, value, child) {
               return (value.adPages.isEmpty)?Padding(
              padding:  EdgeInsets.only(bottom: screenHeight*0.05),
               child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  splashFactory: NoSplash.splashFactory,
                  onTap:(){
                      Navigator.pushNamed(context, "/CreateAd");
                  },
                  child: Container(
                    height: 45,
                    width: 45,
                    child: Icon(Icons.add,size: screenHeight*0.03,color: Colors.grey,),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color: Colors.grey
                        )
                    ),
                  ),
                ),
                SizedBox(height: screenHeight*0.02,),
                Center(
                  child: Text(
                    'No Ads Created yet.',
                    style: TextStyle(
                      fontFamily: 'Raleway',
                      color: Colors.grey,
                      fontSize: (isTablet(context))
                          ? screenWidth * 0.036
                          : screenWidth * 0.046,
                      //fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,),
                ),
              ],
            ),
          ):
             ListView.separated(
                 shrinkWrap: true,
                 physics: NeverScrollableScrollPhysics(),
                 itemBuilder: (context, index) {
                   return Padding(
                     padding: EdgeInsets.only(left: screenWidth * 0.05,right:screenWidth * 0.05,top: screenHeight*0.03 ),
                     child: Column(
                       children: [
                         Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                             Row(
                               children: [
                                 Transform.scale(
                                   scale: (isTablet(context)) ? 1.33 : 0.9,
                                   child: Checkbox(
                                     value: value.displayed[index],
                                     checkColor: Colors.white,
                                     activeColor: Colors.orange,
                                     side: BorderSide(color: Colors.black54, width: 2),
                                     onChanged: (bool? value) {
                                       adsDetails.adDisplay(value!, index);
                                     },
                                   ),
                                 ),
                                 Text(
                                   'Ad ${index+1}',
                                   style: TextStyle(
                                     fontFamily: 'Raleway',
                                     color: Colors.black87,
                                     fontSize: (isTablet(context))
                                         ? screenWidth * 0.04
                                         : screenWidth * 0.05,
                                     //fontWeight: FontWeight.bold,
                                   ),
                                   textAlign: TextAlign.center,),
                               ],
                             ),
                            Row(
                              children: [
                                IconButton(onPressed: (){
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ViewAd(id:index),
                                    ),
                                  );
                                }, icon: Icon(Icons.remove_red_eye_outlined,color: Colors.black54,size: screenHeight*0.032)),

                                IconButton(onPressed: (){
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => UpdateAd(id:index),
                                    ),
                                  );
                                }, icon: Icon(Icons.edit_outlined,color: Colors.black54,size: screenHeight*0.032)),

                                IconButton(onPressed: (){
                                  setState(() {
                                    deleteAdIndex=index;
                                    deletePressed=true;
                                  });
                                }, icon: Icon(Icons.delete_outline_rounded,color: Colors.black54,size: screenHeight*0.032))


                              ],
                            )
                           ],
                         ),
                         (adsDetails.adPages.isNotEmpty && (index==adsDetails.adPages.length-1))?Padding(
                           padding:  EdgeInsets.only(top: screenHeight*0.05),
                           child: InkWell(
                             splashFactory: NoSplash.splashFactory,
                             onTap: (){
                               Navigator.pushNamed(context, "/CreateAd");
                             },
                             child: Container(
                               height: 45,
                               width: 45,
                               child: Icon(Icons.add,size: screenHeight*0.03,color: Colors.grey,),
                               decoration: BoxDecoration(
                                   borderRadius: BorderRadius.circular(5),
                                   border: Border.all(
                                       color: Colors.grey
                                   )
                               ),
                             ),
                           ),
                         ):SizedBox.shrink(),
                       ],
                     ),
                   );
                 },
                 separatorBuilder: (context, index) {
                   return SizedBox(height: screenHeight*0.03,);
                 },
                 itemCount: adsDetails.adPages.length,
               );
            }),

          (deletePressed)?Container(
            height: double.infinity,
            width: double.infinity,
            color: Colors.white38,

          ) : SizedBox.shrink(),

          (deletePressed)?Padding(
            padding:  EdgeInsets.only(bottom: screenHeight*0.05,left: isTablet(context) ? screenWidth * 0.05 : 0,
                right: isTablet(context) ? screenWidth * 0.05 : 0),
            child: Center(
              child: AlertDialog(
                  title: Text(
                    "Delete",
                    style: TextStyle(
                      fontFamily: 'BrunoAceSC',
                      color: Colors.black,
                      fontSize: (isTablet(context))
                          ? screenWidth * 0.042
                          : screenWidth * 0.048,
                      //fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  content: Text(
                        "Are you sure you want to delete this Ad.",
                    style: TextStyle(
                        fontFamily: 'Raleway',
                        color: Colors.black,
                        fontSize: (isTablet(context))
                            ? screenWidth * 0.03
                            : screenWidth * 0.035,
                        //fontWeight: FontWeight.bold,
                      ),
                        textAlign: TextAlign.left,
                      ),

                  backgroundColor: Color(0xFFC8C8C8),
                  actions: [
                    TextButton(
                      onPressed: () {
                          setState(() {
                            deletePressed=false;
                          });
                      },
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                          fontFamily: 'BrunoAceSC',
                          color: Colors.black,
                          fontSize: (isTablet(context)) ? screenWidth *
                              0.038 : screenWidth * 0.04,
                          //fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                          adsDetails.removeAd(deleteAdIndex);
                          setState(() {
                            deletePressed=false;
                          });
                      },
                      child: Text(
                        "Delete",
                        style: TextStyle(
                          fontFamily: 'BrunoAceSC',
                          color: Colors.black,
                          fontSize: (isTablet(context)) ? screenWidth *
                              0.038 : screenWidth * 0.04,
                          //fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],),
            ),
          )
              : SizedBox.shrink(),

          (!hasConnection) ?
          Container(
            height: double.infinity,
            width: double.infinity,
            color: Colors.white38,

          ) : SizedBox.shrink(),

          !hasConnection
              ? Padding(
            padding: EdgeInsets.only(bottom: screenHeight * 0.1,
                left: isTablet(context) ? screenWidth * 0.05 : 0,
                right: isTablet(context) ? screenWidth * 0.05 : 0),
            child: Center(
                child: AlertDialog(
                  title: Text(
                    "No Internet Available",
                    style: TextStyle(
                      fontFamily: 'BrunoAceSC',
                      color: Colors.black,
                      fontSize: (isTablet(context))
                          ? screenWidth * 0.042
                          : screenWidth * 0.048,
                      //fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset('assets/images/noConnection.png',
                        height: screenHeight * 0.2,),
                      Text(
                        'You need an internet connection to proceed. Please check your connection and try again.',
                        style: TextStyle(
                          fontFamily: 'Raleway',
                          color: Colors.black,
                          fontSize: (isTablet(context))
                              ? screenWidth * 0.03
                              : screenWidth * 0.04,
                          //fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,),
                    ],
                  ),
                  backgroundColor: Theme
                      .of(context)
                      .colorScheme
                      .secondary,
                  actions: [
                    TextButton(
                      onPressed: () => SystemNavigator.pop(),
                      child: Text(
                        "Exit",
                        style: TextStyle(
                          fontFamily: 'BrunoAceSC',
                          color: Colors.black,
                          fontSize: (isTablet(context))
                              ? screenWidth * 0.038
                              : screenWidth * 0.04,
                          //fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        await checkConnection();
                        // Navigator.pop() can be used here if desired
                      },
                      child: Text(
                        "Retry",
                        style: TextStyle(
                          fontFamily: 'BrunoAceSC',
                          color: Colors.black,
                          fontSize: (isTablet(context))
                              ? screenWidth * 0.038
                              : screenWidth * 0.04,
                          //fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],)
            ),
          )
              : SizedBox.shrink(),
        ],
      ),
    );
  }

  Future<void> checkConnection() async {
    var result = await InternetConnectionChecker().hasConnection;
    if (mounted) {
      //if(result)
      // updateDateRange();
      setState(() {
        hasConnection = result;
      });
    }
  }

  bool isTablet(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return screenWidth >= 600 && screenWidth <= 1024;
  }
}
