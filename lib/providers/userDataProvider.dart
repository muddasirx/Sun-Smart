import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/providers/sessionDetailsProvider.dart';

class UserDataNotifier with ChangeNotifier {
  String email = 'none';
  String uid = 'none';
  bool appSettingsApplied=false;
  var user;
  List<dynamic> userSessions = [
    {
      "date": Timestamp.now(),
      "iuConsumed": 0,
    }
  ];
  int todayIuConsumed=0;
  List<dynamic>? userGraphDetails;
  bool updateHistoryPressed=false;
  bool locationProvided=false;
  bool updateProfile=false;
  int skinType=0;
  bool sessionReminderPressed=false;

  void changeSkinType(int x){
      skinType=x;
      print("skin Type changed to $x");
      notifyListeners();
  }

  Future<void> updateSkinType(int skinTypeNumber) async{

    CollectionReference userCollection = FirebaseFirestore.instance.collection('UserInfo');

    try {
      print(uid);
      QuerySnapshot querySnapshot = await userCollection.where('uid', isEqualTo: uid).get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentReference userDoc = querySnapshot.docs.first.reference;

        await userDoc.update({
          'skinType':skinTypeNumber
        });

        fetchUserData(uid);

        print('User info updated successfully');
      } else {
        print('No user found with the provided userID');
      }
    } catch (e) {
      print('Error updating user info: $e');
    }
  }

  Future<void> fetchUserSessions(String sessionID)async{
    DocumentSnapshot docSnapshot = await FirebaseFirestore.instance.collection("Sessions").doc(sessionID).get();

    userSessions = await docSnapshot.get('sessionData');
    print('user session fetched');
    userSessions.sort((b,a) {
      return (a['date'] as Timestamp).compareTo(b['date'] as Timestamp);
    });
    print('user session sorted');
    userGraphDetails=userSessions;
    print('updating graph data');
    for (int i=0;i<userSessions.length;i++) {
      if (userSessions[i]['date'] is Timestamp) {
        userGraphDetails?[i]['date'] = (userSessions[i]['date'] as Timestamp).toDate();
      }
    }
    print('graph data updated');


  }

  Future<void> fetchUserData(String userId) async {
    try {
      CollectionReference userInfoCollection = FirebaseFirestore.instance.collection('UserInfo');

      QuerySnapshot querySnapshot = await userInfoCollection.where('uid', isEqualTo: userId).get();

      if (querySnapshot.docs.isNotEmpty) {
        user=querySnapshot.docs.first;
        skinType=user['skinType'];
      } else {
        print('No user found with uid: $userId');
      }
    } catch (e) {
      // Handle any errors
      print('Error fetching user data: $e');
      return null;
    }
  }

  void iuConsumedToday(sessionDetailsNotifier sessionDetails) {
    DateTime currentDate = DateTime.now();
    DateTime currentDateWithoutTime = DateTime(currentDate.year, currentDate.month, currentDate.day);

    print("Inside IU consumed method");

    for (var entry in userSessions!) {
      DateTime entryDate = entry['date']; // `date` is now a `DateTime` object.
      DateTime entryDateWithoutTime = DateTime(entryDate.year, entryDate.month, entryDate.day);

      // Compare the date (ignoring the time)
      if (entryDateWithoutTime.isAtSameMomentAs(currentDateWithoutTime)) {
        todayIuConsumed = entry['iuConsumed'].toInt();
        sessionDetails.vitaminDIntake = (1000 - todayIuConsumed);
        break; // Exit the loop after finding today's entry.
      }
    }
  }

  void setGraphSession(){
    userGraphDetails=userSessions;
    print('updating graph data');
    for (int i=0;i<userSessions.length;i++) {
      if (userSessions[i]['date'] is Timestamp) {
        userGraphDetails?[i]['date'] = (userSessions[i]['date'] as Timestamp).toDate();
      }
    }
    notifyListeners();
  }





}