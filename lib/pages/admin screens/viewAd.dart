import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';

import '../../providers/adminPanelProvider.dart';
import '../../providers/adsProvider.dart';

class ViewAd extends StatefulWidget {

  int id;
  ViewAd({Key? key, required this.id}) : super(key: key);

  @override
  State<ViewAd> createState() => _ViewAdState();
}

class _ViewAdState extends State<ViewAd> {
  bool hasConnection = true;
  int id=-1;

  @override
  void initState() {
    print('--------------View Ad Page--------------');
    super.initState();
    id=widget.id;
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
          adsDetails.adPages[id][0],  //22
            style: TextStyle(
              fontFamily: 'BrunoAceSC',
              color: Colors.black,
              fontSize: (isTablet(context))?screenWidth* 0.035:screenWidth* 0.048,//(isTablet(context))?27:20,
              //fontWeight: FontWeight.bold,
            ),
            softWrap: true,
          ),

        iconTheme: IconThemeData(
          color: Colors.black87,
          size: (isTablet(context)) ? screenWidth * 0.046 : screenWidth *
              0.06, //(isTablet(context))?30:23
        ),

      ),

      body: Stack(
        children: [
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return (index!=0)?Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: screenWidth * 0.55,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              '${adsDetails.adPages[id][index]['name']}',
                              style: TextStyle(
                                fontFamily: 'BrunoAceSC',
                                color: Colors.black,
                                fontSize: (isTablet(context))
                                    ? screenWidth * 0.038
                                    : screenWidth * 0.048,
                              ),
                              textAlign: TextAlign.left
                          ),
                          Text(
                            '${adsDetails.adPages[id][index]['description']}',
                            style: TextStyle(
                              fontFamily: 'Raleway',
                              color: Colors.black,
                              fontSize: (isTablet(context))
                                  ? screenWidth * 0.026
                                  : screenWidth * 0.036,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: screenWidth * 0.3,
                      child: AspectRatio(
                        aspectRatio: 1, // Force a 1:1 aspect ratio
                        child: Image.file(
                          adsDetails.adPages[id][index]['image'],
                          fit: BoxFit.cover, // Make sure the image fills the square box
                        ),
                      ),
                    ),
                  ],
                ),

              ):SizedBox.shrink();
            },
            separatorBuilder: (context, index) {
              return SizedBox(height: screenHeight*0.043,);
            },
            itemCount: adsDetails.adPages[id].length,
          ),




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
