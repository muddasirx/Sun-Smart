import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class SessionAnalysis extends StatefulWidget {
  @override
  _SessionAnalysisState createState() => _SessionAnalysisState();
}

class _SessionAnalysisState extends State<SessionAnalysis> {
  String selectedRange = 'Week';
  DateTime currentDate = DateTime.now();
  DateTime rangeStart = DateTime.now();
  DateTime rangeEnd = DateTime.now();
  Map<String, int> sessionDataByDate = {};
  bool weekPressed = true;
  bool monthPressed = false;
  bool yearPressed = false;
  bool dataFetched = false;

  @override
  void initState() {
    super.initState();
    fetchDataOnce();
    updateDateRange();
  }

  Future<void> fetchDataOnce() async {
    setState(() {
      dataFetched = false;
    });

    final firestore = FirebaseFirestore.instance;

    // Fetch session data for all users
    final snapshot = await firestore.collection('Sessions').get();

    Map<String, int> tempSessionDataByDate = {};
    snapshot.docs.forEach((doc) {
      final sessionData = doc['sessionData'] as List<dynamic>;
      for (var session in sessionData) {
        final dateKey = DateFormat('yyyy-MM-dd')
            .format((session['date'] as Timestamp).toDate());
        tempSessionDataByDate[dateKey] = (tempSessionDataByDate[dateKey] ?? 0) + 1;
      }
    });

    setState(() {
      sessionDataByDate = tempSessionDataByDate;
      dataFetched = true;
    });
  }

  void updateDateRange() {
    setState(() {
      if (selectedRange == 'Today') {
        rangeStart = currentDate;
        rangeEnd = currentDate;
      } else if (selectedRange == 'Week') {
        int weekday = currentDate.weekday;
        rangeStart = currentDate.subtract(Duration(days: weekday - 1)); // Start of the week
        rangeEnd = rangeStart.add(Duration(days: 6)); // End of the week
      } else if (selectedRange == 'Month') {
        rangeStart = DateTime(currentDate.year, currentDate.month, 1); // Start of the month
        rangeEnd = DateTime(currentDate.year, currentDate.month + 1, 0); // End of the month
      } else if (selectedRange == 'Year') {
        rangeStart = DateTime(currentDate.year, 1, 1); // Start of the year
        rangeEnd = DateTime(currentDate.year, 12, 31); // End of the year
      }
    });
  }

  List<BarChartGroupData> getBarGroups() {
    List<BarChartGroupData> barGroups = [];
    List<int> counts = [];

    if (selectedRange == 'Today') {
      String dateKey = DateFormat('yyyy-MM-dd').format(currentDate);
      counts.add(sessionDataByDate[dateKey] ?? 0);
    } else {
      DateTime iterator = rangeStart;
      while (iterator.isBefore(rangeEnd.add(Duration(days: 1)))) {
        String dateKey = DateFormat('yyyy-MM-dd').format(iterator);
        counts.add(sessionDataByDate[dateKey] ?? 0);
        iterator = iterator.add(Duration(days: 1));
      }
    }

    for (int i = 0; i < counts.length; i++) {
      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: counts[i].toDouble(),
              color: counts[i] > 0 ? Colors.orangeAccent : Color(0xFFE7E7E7),
              width: 12,
              borderRadius: BorderRadius.circular(8),
            ),
          ],
        ),
      );
    }

    return barGroups;
  }

  String getRangeLabel() {
    if (selectedRange == 'Today') {
      return DateFormat('dd MMM').format(currentDate);
    } else if (selectedRange == 'Week') {
      return '${DateFormat('dd MMM').format(rangeStart)} - ${DateFormat('dd MMM').format(rangeEnd)}';
    } else if (selectedRange == 'Month') {
      return DateFormat('MMM yyyy').format(currentDate);
    } else if (selectedRange == 'Year') {
      return DateFormat('yyyy').format(currentDate);
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text("Session Analysis"),
      ),
      body: dataFetched
          ? Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios_new,
                    size: screenWidth * 0.055,
                    color: Colors.black87,
                  ),
                  onPressed: () {
                    setState(() {
                      currentDate = currentDate.subtract(Duration(days: 1));
                      updateDateRange();
                    });
                  },
                ),
                Text(
                  getRangeLabel(),
                  style: TextStyle(
                    fontFamily: 'BrunoAceSC',
                    color: Colors.black,
                    fontSize: screenWidth * 0.039,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.arrow_forward_ios,
                    size: screenWidth * 0.055,
                    color: Colors.black87,
                  ),
                  onPressed: () {
                    setState(() {
                      currentDate = currentDate.add(Duration(days: 1));
                      updateDateRange();
                    });
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: screenHeight * 0.01),
          SizedBox(
            height: screenHeight * 0.38,
            child: Padding(
              padding: EdgeInsets.only(
                  left: screenWidth * 0.03, right: screenWidth * 0.01),
              child: BarChart(
                BarChartData(
                  maxY: selectedRange == 'Year' ? 30000 : 1000,
                  barGroups: getBarGroups(),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (selectedRange == 'Week') {
                            return Text(['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][value.toInt()]);
                          }
                          return Text('');
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildRangeButton('Week', weekPressed),
              buildRangeButton('Month', monthPressed),
              buildRangeButton('Year', yearPressed),
            ],
          ),
        ],
      )
          : Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget buildRangeButton(String label, bool isActive) {
    return InkWell(
      onTap: () {
        setState(() {
          weekPressed = label == 'Week';
          monthPressed = label == 'Month';
          yearPressed = label == 'Year';
          selectedRange = label;
          updateDateRange();
        });
      },
      child: Container(
        height: 50,
        width: 80,
        decoration: BoxDecoration(
          color: isActive ? Colors.cyan : Color(0xFFDEDEDE),
          borderRadius: label == 'Week'
              ? BorderRadius.only(topLeft: Radius.circular(20), bottomLeft: Radius.circular(20))
              : label == 'Year'
              ? BorderRadius.only(topRight: Radius.circular(20), bottomRight: Radius.circular(20))
              : null,
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isActive ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
