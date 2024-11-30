import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class AdminPanelNotifier with ChangeNotifier {
  int activeUsersToday=0;
  bool dataFetched=false;
  int totalUsers=0;



  Future<void> countUsersWithSessionsToday() async {
    // Get today's date at midnight in UTC
    DateTime now = DateTime.now().toUtc();
    DateTime startOfToday = DateTime(now.year, now.month, now.day);
    DateTime endOfToday = startOfToday.add(Duration(days: 1));

    Timestamp startTimestamp = Timestamp.fromDate(startOfToday);
    Timestamp endTimestamp = Timestamp.fromDate(endOfToday);

    try {
      // Fetch all documents from the "Sessions" collection
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Sessions')
          .get();

      int count = 0;

      // Process each document to check if any sessionData has today's date
      for (var doc in querySnapshot.docs) {
        List<dynamic> sessionData = doc['sessionData'] ?? [];
        bool hasSessionToday = sessionData.any((session) {
          Timestamp sessionDate = session['date'];
          return sessionDate.toDate().isAfter(startOfToday) &&
              sessionDate.toDate().isBefore(endOfToday);
        });

        if (hasSessionToday) {
          count++;
        }
      }

      activeUsersToday=count;
    } catch (e) {
      print("Error fetching sessions to calculate active users: $e");
    }
  }

  Future<void> fetchTotalUsers() async {
    try {
      // Reference to the users collection
      final usersCollection = FirebaseFirestore.instance.collection('UserInfo');

      // Fetch all documents in the collection and count them
      final snapshot = await usersCollection.get();
      totalUsers= snapshot.docs.length; // Returns the total count
    } catch (e) {
      print("----- Error fetching total users: $e");
    }
  }

  void fetchData() async{
    await countUsersWithSessionsToday();
    await fetchTotalUsers();
    dataFetched=true;
    notifyListeners();
  }

}