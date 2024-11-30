import 'dart:convert';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

import '../../providers/adminPanelProvider.dart';
import '../../providers/adsProvider.dart';

class UpdateAd extends StatefulWidget {

  int id;
  UpdateAd({Key? key, required this.id}) : super(key: key);

  @override
  State<UpdateAd> createState() => _UpdateAdState();
}

class _UpdateAdState extends State<UpdateAd> {
  bool hasConnection = true;
  List<dynamic> ads=[];
  List<dynamic>adPage=[];
  bool descriptionLimitExceeded=false;
  bool nameLimitExceeded=false;
  bool titleLimitExceeded=false;
  TextEditingController titleController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  File? image;
  final picker = ImagePicker();
  bool addMed=false;
  int editIndex=-1;
  bool optionPressed=false;
  bool update=false;
  int i=0;
  bool dataUploaded=true;
  int id=-1;

  @override
  void initState() {
    super.initState();
    checkConnection();
    id=widget.id;
    fetchData(id);
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
          "Update Ad",
          style: TextStyle(
            fontFamily: 'BrunoAceSC',
            color: Colors.black,
            fontSize: (isTablet(context)) ? screenWidth * 0.038 : screenWidth * 0.051,
          ),
        ),
        iconTheme: IconThemeData(
          color: Colors.black87,
          size: (isTablet(context)) ? screenWidth * 0.046 : screenWidth * 0.06,
        ),
      ),

      body: Stack(
        children: [

          Padding(
              padding:  EdgeInsets.only(top: screenHeight*0.02),
              child: Column(
                children: [
                  Padding(
                    padding:  EdgeInsets.symmetric(horizontal: screenWidth*0.08),
                    child: Column(
                      children: [
                        TextFormField(
                          inputFormatters: [LengthLimitingTextInputFormatter(24)],
                          controller: titleController,
                          cursorColor: Colors.black54,
                          cursorWidth: 1.5,
                          style: TextStyle(color: Colors.black, fontSize: (isTablet(context)) ? screenWidth * 0.034 : screenWidth * 0.039),
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            errorStyle: TextStyle(color: Colors.red),
                            contentPadding: EdgeInsets.only(left: screenWidth * 0.04, right: screenWidth * 0.01, top: screenHeight * 0.025, bottom: screenHeight * 0.025),
                            labelText: "Title",
                            hintText: 'title for the branding page',
                            hintStyle: TextStyle(
                              fontFamily: 'Lato',
                              color: Colors.grey,
                              fontSize: (isTablet(context)) ? screenWidth * 0.038 : screenWidth * 0.045,
                            ),
                            labelStyle: TextStyle(
                              fontFamily: 'Lato',
                              color: Colors.black54,
                              fontSize: (isTablet(context)) ? screenWidth * 0.038 : screenWidth * 0.045,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 1, color: Colors.black54),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 1, color: Colors.black54),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Email cannot be Empty";
                            }
                            return null;
                          },
                          onChanged: (value) {
                            if (titleController.text.length == 24 && !titleLimitExceeded) {
                              setState(() {
                                titleLimitExceeded = true;
                              });
                            } else if (titleLimitExceeded) {
                              setState(() {
                                titleLimitExceeded = false;
                              });
                            }
                          },
                        ),
                        titleLimitExceeded
                            ? Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: screenWidth * 0.02),
                            child: Text(
                              'Title cannot exceed 24 characters.',
                              style: TextStyle(
                                fontFamily: 'Raleway',
                                color: Colors.red,
                                fontSize: (isTablet(context)) ? screenWidth * 0.022 : screenWidth * 0.032,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        )
                            : SizedBox.shrink(),
                      ],
                    ),
                  ),
                  SizedBox(height: screenHeight*0.04,),

                  (ads.isNotEmpty)
                      ? Expanded(
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                          child: Column(
                            children: [
                              InkWell(
                                onLongPress:(){
                                  editIndex=index;
                                  setState(() {
                                    optionPressed=true;
                                  });
                                },
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
                                              '${ads[index]['name']}',
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
                                            '${ads[index]['description']}',
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
                                          ads[index]['image'],
                                          fit: BoxFit.cover, // Make sure the image fills the square box
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              (ads.length<4 && index==ads.length-1)?Padding(
                                padding:  EdgeInsets.only(top: screenHeight*0.05),
                                child: InkWell(
                                  splashFactory: NoSplash.splashFactory,
                                  onTap: (){
                                    setState(() {
                                      addMed=true;
                                    });
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
                              ):SizedBox.shrink()
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return SizedBox(height: screenHeight*0.03,);
                      },
                      itemCount: ads.length,
                    ),
                  ):SizedBox.shrink(),

                  (ads.isEmpty)?Column(
                    children: [
                      Padding(
                        padding:  EdgeInsets.only(top: screenHeight*0.05),
                        child: InkWell(
                          splashFactory: NoSplash.splashFactory,
                          onTap: (){
                            setState(() {
                              addMed=true;
                            });
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
                      ),
                      SizedBox(height: screenHeight*0.01,),
                      Text(
                        "Add Supplement",
                        style: TextStyle(
                          fontFamily: 'Raleway',
                          color: Colors.grey,
                          fontSize: (isTablet(context)) ? screenWidth * 0.028 : screenWidth * 0.04,
                          //fontWeight: FontWeight.bold
                        ),
                      ),
                    ],
                  ):SizedBox.shrink()


                ],
              )
          ),

          (addMed || optionPressed)?InkWell(
            splashFactory: NoSplash.splashFactory,
            onTap:(){
              setState(() {
                optionPressed=false;
              });
            },
            child: Container(
              height: double.infinity,
              width: double.infinity,
              color: Colors.black26,
            ),
          )
              : SizedBox.shrink(),

          optionPressed?Center(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [BoxShadow(
                  color: Colors.black54,
                  blurRadius: 20,
                  offset: Offset(0, 8),
                )],
              ),
              height: screenHeight*0.2,
              width: screenWidth*0.7,
              child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        onTap: (){
                          setState(() {
                            nameController.text=ads[editIndex]['name'];
                            descriptionController.text=ads[editIndex]['description'];
                            image=ads[editIndex]['image'];
                            optionPressed=false;
                            addMed=true;
                            update=true;
                          });
                        },
                        child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.edit_outlined,color: Colors.black87,size: screenHeight*0.032,),
                              SizedBox(height: screenHeight*0.01,),
                              Text(
                                  'Edit',
                                  style: TextStyle(
                                    fontFamily: 'BrunoAceSC',
                                    color: Colors.black,
                                    fontSize: (isTablet(context))
                                        ? screenWidth * 0.035
                                        : screenWidth * 0.045,
                                  ),
                                  textAlign: TextAlign.left
                              ),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: (){
                          setState(() {
                            ads.removeAt(editIndex);
                            editIndex=-1;
                            optionPressed=false;
                          });
                        },
                        child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.delete_outline_rounded,color: Colors.black87,size: screenHeight*0.032,),
                              SizedBox(height: screenHeight*0.01,),
                              Text(
                                  'Delete',
                                  style: TextStyle(
                                    fontFamily: 'BrunoAceSC',
                                    color: Colors.black87,
                                    fontSize: (isTablet(context))
                                        ? screenWidth * 0.035
                                        : screenWidth * 0.045,
                                  ),
                                  textAlign: TextAlign.left
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
              ),
            ),
          ):SizedBox.shrink(),

          (addMed)?Center(
            child: SingleChildScrollView(
              child:Container(
                width: screenWidth * 0.85,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [BoxShadow(
                    color: Colors.black54,
                    blurRadius: 20,
                    offset: Offset(0, 8),
                  )],
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                  child: Column(
                    children: [
                      SizedBox(height: screenHeight * 0.04),
                      TextFormField(
                        inputFormatters: [LengthLimitingTextInputFormatter(30)],
                        controller: nameController,
                        cursorColor: Colors.black54,
                        cursorWidth: 1.5,
                        style: TextStyle(color: Colors.black, fontSize: (isTablet(context)) ? screenWidth * 0.034 : screenWidth * 0.039),
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          errorStyle: TextStyle(color: Colors.red),
                          contentPadding: EdgeInsets.only(left: screenWidth * 0.04, right: screenWidth * 0.01, top: screenHeight * 0.025, bottom: screenHeight * 0.025),
                          labelText: "Name",
                          labelStyle: TextStyle(
                            fontFamily: 'Lato',
                            color: Colors.black54,
                            fontSize: (isTablet(context)) ? screenWidth * 0.038 : screenWidth * 0.045,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 1, color: Colors.black54),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 1, color: Colors.black54),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Email cannot be Empty";
                          }
                          return null;
                        },
                        onChanged: (value) {
                          if (nameController.text.length == 30 && !nameLimitExceeded) {
                            setState(() {
                              nameLimitExceeded = true;
                            });
                          } else if (nameLimitExceeded) {
                            setState(() {
                              nameLimitExceeded = false;
                            });
                          }
                        },
                      ),
                      nameLimitExceeded
                          ? Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: screenWidth * 0.02),
                          child: Text(
                            'Name cannot exceed 30 characters.',
                            style: TextStyle(
                              fontFamily: 'Raleway',
                              color: Colors.red,
                              fontSize: (isTablet(context)) ? screenWidth * 0.025 : screenWidth * 0.035,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      )
                          : SizedBox.shrink(),
                      SizedBox(height: screenHeight * 0.03),
                      TextFormField    (
                        inputFormatters: [LengthLimitingTextInputFormatter(120)],
                        maxLines: 5,
                        minLines: 1,
                        controller: descriptionController,
                        cursorColor: Colors.black54,
                        cursorWidth: 1.5,
                        style: TextStyle(color: Colors.black, fontSize: (isTablet(context)) ? screenWidth * 0.034 : screenWidth * 0.039),
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          errorStyle: TextStyle(color: Colors.red),
                          contentPadding: EdgeInsets.only(left: screenWidth * 0.04, right: screenWidth * 0.01, top: screenHeight * 0.025, bottom: screenHeight * 0.025),
                          labelText: "Description",
                          labelStyle: TextStyle(
                            fontFamily: 'Lato',
                            color: Colors.black54,
                            fontSize: (isTablet(context)) ? screenWidth * 0.038 : screenWidth * 0.045,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 1, color: Colors.black54),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 1, color: Colors.black54),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Email cannot be Empty";
                          }
                          return null;
                        },
                        onChanged: (value) {
                          if (descriptionController.text.length == 120 && !descriptionLimitExceeded) {
                            setState(() {
                              descriptionLimitExceeded = true;
                            });
                          } else if (descriptionLimitExceeded) {
                            setState(() {
                              descriptionLimitExceeded = false;
                            });
                          }
                        },
                      ),
                      descriptionLimitExceeded
                          ? Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: screenWidth * 0.02),
                          child: Text(
                            'Description cannot exceed 120 characters.',
                            style: TextStyle(
                              fontFamily: 'Raleway',
                              color: Colors.red,
                              fontSize: (isTablet(context)) ? screenWidth * 0.025 : screenWidth * 0.035,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      )
                          : SizedBox.shrink(),
                      SizedBox(height: (image==null)?screenHeight * 0.03:screenHeight * 0.01),
                      (image==null)?InkWell(
                        onTap: (){
                          _pickImage();
                        },
                        child: Container(
                          height: screenHeight*0.1,
                          width: screenWidth*0.5,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: Colors.black54
                              )
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.upload,color: Colors.grey,size: screenHeight*0.03,),
                              Text(
                                'Upload Image',
                                style: TextStyle(
                                    fontFamily: 'Raleway',
                                    color: Colors.grey,
                                    fontSize: (isTablet(context)) ? screenWidth * 0.027 : screenWidth * 0.037,
                                    fontWeight: FontWeight.bold

                                ),
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                        ),
                      ):
                      Container(
                        width: screenWidth*0.665,
                        child: Stack(
                          children: [
                            Container(
                              child: Padding(
                                padding:  EdgeInsets.all(screenHeight*0.04),
                                child: Container(
                                  width: screenWidth*0.5,
                                  child: AspectRatio(
                                    aspectRatio: 1,  // Force a 1:1 aspect ratio
                                    child: Image.file(
                                      image!,
                                      fit: BoxFit.cover,  // Make sure the image fills the square box
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.topRight,
                              child: IconButton(
                                icon: Icon(Icons.highlight_remove, color:Colors.grey,
                                    size: screenHeight*0.042), // Adjust the size as needed
                                onPressed: () {
                                  setState(() {
                                    image=null;
                                  });
                                },
                              ),
                            ),

                          ],
                        ),
                      ),

                      SizedBox(height: (image==null)?screenHeight * 0.03:screenHeight * 0.01),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.cyan,
                          borderRadius: BorderRadius.circular(50.0), // Rounded corners
                        ),
                        child: TextButton(
                          onPressed: () async{
                            print('---------------------Inside add pressed method------------------------');
                            if(validateFields()){
                              checkConnection();

                              if(hasConnection){
                                if(update){
                                  Map<String,dynamic> ad={
                                    'name':nameController.text.trim(),
                                    'description': descriptionController.text.trim(),
                                    'image': image
                                  };
                                  setState(() {
                                    ads[editIndex]=ad;
                                    nameController.clear();
                                    descriptionController.clear();
                                    image=null;
                                    nameLimitExceeded=false;
                                    descriptionLimitExceeded=false;
                                    addMed=false;
                                    update=false;
                                    editIndex=-1;
                                  });
                                }
                                else{
                                  Map<String,dynamic> ad={
                                    'name':nameController.text.trim(),
                                    'description': descriptionController.text.trim(),
                                    'image': image
                                  };
                                  setState(() {
                                    ads.add(ad);
                                    nameController.clear();
                                    descriptionController.clear();
                                    image=null;
                                    nameLimitExceeded=false;
                                    descriptionLimitExceeded=false;
                                    addMed=false;
                                  });
                                  i++;
                                  print('---------------------printing details------------------------');
                                  print(ads.toString());
                                }
                              }
                            }
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                                horizontal: (isTablet(context))
                                    ? screenWidth * 0.038
                                    : screenWidth * 0.08,
                                vertical: (isTablet(context))
                                    ? screenHeight * 0.014
                                    : screenHeight * 0.01),
                            // Text color
                            textStyle: TextStyle(fontSize: (isTablet(context))
                                ? screenWidth * 0.04
                                : screenWidth * 0.043,fontFamily: 'BrunoAceSC', ),
                          ),
                          child: Text(update?'Update':'Add'),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50.0), // Rounded corners
                        ),
                        child: TextButton(
                          onPressed: () async{

                            setState(() {
                              nameController.clear();
                              descriptionController.clear();
                              image=null;
                              nameLimitExceeded=false;
                              descriptionLimitExceeded=false;
                              addMed=false;
                              update=false;
                            });

                          },
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.grey,
                            padding: EdgeInsets.symmetric(
                                horizontal: (isTablet(context))
                                    ? screenWidth * 0.038
                                    : screenWidth * 0.08,
                                vertical: (isTablet(context))
                                    ? screenHeight * 0.014
                                    : screenHeight * 0.01),
                            // Text color
                            textStyle: TextStyle(fontSize: (isTablet(context))
                                ? screenWidth * 0.04
                                : screenWidth * 0.043,fontFamily: 'BrunoAceSC', ),
                          ),
                          child: Text('Back'),
                        ),
                      ),
                      SizedBox(height:screenHeight * 0.015),
                    ],
                  ),
                ),
              ),

            ),
          ):Container(),

          dataUploaded?SizedBox.shrink():Container(
            height: double.infinity,
            width: double.infinity,
            color: Colors.white54,
          ),
          dataUploaded?SizedBox.shrink():Center(
              child: Container(
                height: screenHeight*0.15,
                width: screenWidth*0.45,
                decoration: BoxDecoration(
                    color: Colors.orangeAccent,
                    borderRadius: BorderRadius.circular(20)
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                        height:isTablet(context)?60:35,
                        width: isTablet(context)?60:35,
                        child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white),strokeWidth: isTablet(context)?3.5:3,)),
                    SizedBox(height: screenHeight*0.01,),
                    Text(
                      "Please Wait",
                      style: TextStyle(
                        fontFamily: 'BrunoAceSC',
                        color: Colors.white,
                        fontSize: (isTablet(context))?screenWidth*0.038:screenWidth*0.043,
                        //fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
          ),

          (!hasConnection)
              ? Container(
            height: double.infinity,
            width: double.infinity,
            color: Colors.white38,
          )
              : SizedBox.shrink(),
          !hasConnection
              ? Padding(
            padding: EdgeInsets.only(bottom: screenHeight * 0.1, left: isTablet(context) ? screenWidth * 0.05 : 0, right: isTablet(context) ? screenWidth * 0.05 : 0),
            child: Center(
              child: AlertDialog(
                title: Text(
                  "No Internet Available",
                  style: TextStyle(
                    fontFamily: 'BrunoAceSC',
                    color: Colors.black,
                    fontSize: (isTablet(context)) ? screenWidth * 0.042 : screenWidth * 0.048,
                  ),
                  textAlign: TextAlign.center,
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('assets/images/noConnection.png', height: screenHeight * 0.2),
                    Text(
                      'You need an internet connection to proceed. Please check your connection and try again.',
                      style: TextStyle(
                        fontFamily: 'Raleway',
                        color: Colors.black,
                        fontSize: (isTablet(context)) ? screenWidth * 0.03 : screenWidth * 0.04,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                backgroundColor: Theme.of(context).colorScheme.secondary,
                actions: [
                  TextButton(
                    onPressed: () => SystemNavigator.pop(),
                    child: Text(
                      "Exit",
                      style: TextStyle(
                        fontFamily: 'BrunoAceSC',
                        color: Colors.black,
                        fontSize: (isTablet(context)) ? screenWidth * 0.038 : screenWidth * 0.04,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        checkConnection();
                      });
                    },
                    child: Text(
                      "Retry",
                      style: TextStyle(
                        fontFamily: 'BrunoAceSC',
                        color: Colors.black,
                        fontSize: (isTablet(context)) ? screenWidth * 0.038 : screenWidth * 0.04,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          )
              : SizedBox.shrink(),
        ],
      ),

      floatingActionButton: (!addMed)?Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding:  EdgeInsets.only(left: screenWidth*0.06),
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [BoxShadow(
                color: Colors.black54,
                blurRadius: 15,
                offset: Offset(0, 8),
              )],
              gradient: LinearGradient(
                colors: [dataUploaded?Color(0xFFFCC54E):Colors.white, dataUploaded?Color(0xFFFDA34F):Colors.grey],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(50.0), // Rounded corners
            ),
            child: TextButton(
              onPressed: () async{
                checkConnection();
                if(dataUploaded){
                  if(validateAds()) {
                    if (hasConnection) {

                      print('---------Navigating now-----------');
                      Navigator.pop(context);
                      print('---------Navigated-----------');

                      print('-------Adding title now---------');
                      adPage.add(titleController.text.trim());
                      adPage.addAll(ads);
                      print('------------Adding ad list to adpages--------------');
                      adsDetails.replaceAd(adPage, id);

                      Fluttertoast.showToast(
                        fontSize: (isTablet(context))?screenWidth*0.03:screenWidth*0.035,
                        msg: "Ad updated successfully",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.grey[300],
                        textColor: Colors.black,
                      );
                    }
                  }
                }
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                    horizontal: (isTablet(context))
                        ? screenWidth * 0.09
                        : screenWidth * 0.15,
                    vertical: (isTablet(context))
                        ? screenHeight * 0.014
                        : screenHeight * 0.01),
                // Text color
                textStyle: TextStyle(fontSize: (isTablet(context))
                    ? screenWidth * 0.04
                    : screenWidth * 0.043, fontWeight: FontWeight.bold),
              ),
              child: Text('Update'),
            ),
          ),
        ),
      ):SizedBox.shrink(),

    );
  }

  bool validateFields(){
    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;

    if(nameController.text.trim().isNotEmpty && descriptionController.text.trim().isNotEmpty){
      if(image!=null){
        return true;
      }else{
        Fluttertoast.showToast(
          fontSize: (isTablet(context))?screenWidth*0.03:screenWidth*0.035,
          msg: "Please upload the image to proceed.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red, // Change this to your desired background color
          textColor: Colors.white,
        );

        return false;
      }
    }else{
      Fluttertoast.showToast(
        fontSize: (isTablet(context))?screenWidth*0.03:screenWidth*0.035,
        msg: "Please fill in all required fields to continue.",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red, // Change this to your desired background color
        textColor: Colors.white,
      );

      return false;
    }
  }

  bool validateAds(){
    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;

    if(titleController.text.trim().isNotEmpty){
      if(ads.length>=3){
        print("----------Ads List Length: ${ads.length}----------");
        return true;
      }else{
        Fluttertoast.showToast(
          fontSize: (isTablet(context))?screenWidth*0.03:screenWidth*0.035,
          msg: "Please add at least 3 supplements to proceed",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red, // Change this to your desired background color
          textColor: Colors.white,
        );

        return false;
      }
    }else{
      Fluttertoast.showToast(
        fontSize: (isTablet(context))?screenWidth*0.03:screenWidth*0.035,
        msg: "Title cannot be left empty",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red, // Change this to your desired background color
        textColor: Colors.white,
      );

      return false;
    }
  }

  void fetchData(int index){
    final adsDetails = Provider.of<AdsNotifier>(context, listen: false);
    print('-------------Inside fetchData method of updateAd---------------');
    ads=List.from(adsDetails.adPages[index]);
    print('-------------Ad Page: ${adsDetails.adPages[index]}---------------');
    print('-------------Title of Ad: ${ads[0]}---------------');
    titleController.text=ads[0];
    setState(() {
      ads.removeAt(0);
    });
    print('-------------After removing title from ads - Ad Page: ${adsDetails.adPages[index]}---------------');
  }

  void checkConnection() async {
    bool result = await InternetConnectionChecker().hasConnection;
    setState(() {
      hasConnection = result;
    });
  }

  bool isTablet(BuildContext context) {
    return MediaQuery.of(context).size.shortestSide >= 600;
  }

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);  // Pick image from gallery
    if (pickedFile != null) {
      setState(() {
        image = File(pickedFile.path);  // Update the state with the picked image
      });
    } else {
      print('No image selected.');
    }
  }
}
