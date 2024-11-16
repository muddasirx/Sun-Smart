import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:untitled/providers/userDataProvider.dart';

class GraphTesting extends StatefulWidget {
  @override
  _GraphTestingState createState() => _GraphTestingState();
}

class _GraphTestingState extends State<GraphTesting> {
  String selectedRange = 'Week';
  DateTime currentDate = DateTime.now();
  DateTime rangeStart = DateTime.now();
  DateTime rangeEnd = DateTime.now();
  bool yearPressed=false,monthPressed=false,weekPressed=true;

  @override
  void initState() {
    super.initState();
    updateDateRange();
  }

  void updateDateRange() {
    setState(() {
      if (selectedRange == 'Week') {
        int weekday = currentDate.weekday;
        rangeStart = currentDate.subtract(Duration(days: weekday - 1));
        rangeEnd = rangeStart.add(Duration(days: 6));
      } else if (selectedRange == 'Month') {
        rangeStart = DateTime(currentDate.year, currentDate.month, 1);
        rangeEnd = DateTime(currentDate.year, currentDate.month + 1, 0);
      } else if (selectedRange == 'Year') {
        rangeStart = DateTime(currentDate.year, 1, 1);
        rangeEnd = DateTime(currentDate.year, 12, 31);
      }
    });
  }

  void moveToPreviousRange() {
    setState(() {
      if (selectedRange == 'Week') {
        currentDate = currentDate.subtract(Duration(days: 7));
      } else if (selectedRange == 'Month') {
        currentDate = DateTime(currentDate.year, currentDate.month - 1);
      } else if (selectedRange == 'Year') {
        currentDate = DateTime(currentDate.year - 1);
      }
      updateDateRange();
    });
  }

  void moveToNextRange() {
    setState(() {
      if (selectedRange == 'Week') {
        currentDate = currentDate.add(Duration(days: 7));
      } else if (selectedRange == 'Month') {
        currentDate = DateTime(currentDate.year, currentDate.month + 1);
      } else if (selectedRange == 'Year') {
        currentDate = DateTime(currentDate.year + 1);
      }
      updateDateRange();
    });
  }

  bool isForwardButtonEnabled() {
    if (selectedRange == 'Week') {
      return currentDate.isBefore(DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1)));
    } else if (selectedRange == 'Month') {
      return currentDate.isBefore(DateTime(DateTime.now().year, DateTime.now().month, 1));
    } else if (selectedRange == 'Year') {
      return currentDate.year < DateTime.now().year;
    }
    return false;
  }

  String getRangeLabel() {
    if (selectedRange == 'Week') {
      return '${DateFormat('MMM dd').format(rangeStart)} - ${DateFormat('MMM dd').format(rangeEnd)}';
    } else if (selectedRange == 'Month') {
      return DateFormat('MMM yyyy').format(currentDate);
    } else if (selectedRange == 'Year') {
      return DateFormat('yyyy').format(currentDate);
    }
    return '';
  }

  List<BarChartGroupData> getBarGroups() {
    final userData = Provider.of<UserDataNotifier>(context, listen: false);

    double screenWidth = MediaQuery.sizeOf(context).width;

    int numberOfBars;
    if (selectedRange == 'Week') {
      numberOfBars = 7;
    } else if (selectedRange == 'Month') {
      numberOfBars = DateTime(currentDate.year, currentDate.month + 1, 0).day;
    } else {
      numberOfBars = 12;
    }

    double barWidth = screenWidth / (numberOfBars * 2);

    List<BarChartGroupData> barGroups = [];

    for (int i = 0; i < numberOfBars; i++) {
      DateTime periodStart;

      if (selectedRange == 'Week') {
        periodStart = rangeStart.add(Duration(days: i));
      } else if (selectedRange == 'Month') {
        periodStart = DateTime(currentDate.year, currentDate.month, i + 1);
      } else {
        periodStart = DateTime(currentDate.year, i + 1, 1);
      }

      double iuSum = 0;

      if (selectedRange == 'Year') {
        // Group and sum `iuConsumed` by month
        userData.userGraphDetails?.forEach((session) {
          DateTime sessionDate = session['date'];
          if (sessionDate.year == currentDate.year && sessionDate.month == i + 1) {
            iuSum += session['iuConsumed']?.toDouble() ?? 0;
          }
        });
      } else {
        // Fetch `iuConsumed` for a specific day (Week/Month case)
        var session = userData.userGraphDetails?.firstWhere(
              (session) => DateFormat('yyyy-MM-dd').format(session['date']) ==
              DateFormat('yyyy-MM-dd').format(periodStart),
          orElse: () => {'iuConsumed': 0},
        );
        iuSum = session['iuConsumed']?.toDouble() ?? 0;
      }

      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: iuSum,
              color: iuSum > 0 ? Colors.cyan : Color(0xFFE7E7E7), // Fix applied here
              width: barWidth,
              borderRadius: BorderRadius.circular(8),
            ),
          ],
        ),
      );
    }

    return barGroups;
  }



  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios_new,size: screenWidth*0.055,color: Colors.black87,),
                    onPressed: moveToPreviousRange,
                  ),
                  Text(
                    getRangeLabel(),
                    style: GoogleFonts.brunoAceSc(
                      textStyle: TextStyle(
                        color:  Colors.black,
                        fontSize: (isTablet(context)) ? screenWidth * 0.03 : screenWidth * 0.039,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_forward_ios,size: screenWidth*0.055),
                    color: isForwardButtonEnabled() ? Colors.black87 : Colors.grey,
                    onPressed: isForwardButtonEnabled() ? moveToNextRange : null,
                  ),
                ],
              ),
            ),
            SizedBox(height: screenHeight*0.02,),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.4,
              child: Padding(
                padding: EdgeInsets.only(left: screenWidth * 0.03,right: screenWidth*0.01),
                child: BarChart(
                  BarChartData(
                    maxY: selectedRange == 'Year' ? 30000 : 1000,
                    barGroups: getBarGroups(),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            if (selectedRange == 'Week') {
                              List<String> weekDays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
                              return Text(
                                weekDays[value.toInt()],
                                style: GoogleFonts.raleway(
                                  textStyle: TextStyle(
                                    color:  Colors.black,
                                    fontSize: (isTablet(context)) ? screenWidth * 0.026 : screenWidth * 0.035,
                                  ),
                                ),
                              );
                            } else if (selectedRange == 'Month') {
                              int day = value.toInt() + 1;
                              if ([1, 5, 10, 15, 20, 25, 30].contains(day)) {
                                return Text(
                                  day.toString(),
                                  style: GoogleFonts.raleway(
                                    textStyle: TextStyle(
                                      color:  Colors.black,
                                      fontSize: (isTablet(context)) ? screenWidth * 0.026 : screenWidth * 0.035,
                                    ),
                                  ),
                                );
                              }
                            } else if (selectedRange == 'Year') {
                              List<String> months = ['J', 'F', 'M', 'A', 'M', 'J', 'J', 'A', 'S', 'O', 'N', 'D'];
                              return Text(
                                months[value.toInt()],
                                style: GoogleFonts.raleway(
                                  textStyle: TextStyle(
                                    color:  Colors.black,
                                    fontSize: (isTablet(context)) ? screenWidth * 0.026 : screenWidth * 0.035,
                                  ),
                                ),
                              );
                            }
                            return Text('');
                          },
                        ),
                      ),
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: screenWidth*0.115,
                          getTitlesWidget: (value, meta) {
                            String formattedValue;
                            if (value >= 1000) {
                              formattedValue = '${(value ~/ 1000)}k'; // Convert to "k" format
                            } else {
                              formattedValue = value.toInt().toString(); // Display the number as is
                            }
                            return Padding(
                              padding:  EdgeInsets.only(left:screenWidth*0.03),
                              child: Text(
                                '${formattedValue}',
                                style: GoogleFonts.raleway(
                                  textStyle: TextStyle(
                                    color:  Colors.black,
                                    fontSize: (isTablet(context)) ? screenWidth * 0.026 : screenWidth * 0.035,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    gridData: FlGridData(show: false),
                  ),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.05,),
            Center(
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center, // Center the containers within the row
                  children: [
                    InkWell(
                      onTap: () {
                        if (!weekPressed) {
                          setState(() {
                            weekPressed = true;
                            monthPressed = false;
                            yearPressed = false;
                            selectedRange = 'Week';
                            updateDateRange();
                          });
                        }
                      },
                      child: Container(
                        height: screenHeight * 0.055,
                        width: screenWidth * 0.2,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20.0),
                            bottomLeft: Radius.circular(20.0),
                          ),
                          color: weekPressed ? Colors.cyan : Color(0xFFDEDEDE),
                        ),
                        child: Center(
                          child: Text(
                            "Week",
                            style: GoogleFonts.brunoAceSc(
                              textStyle: TextStyle(
                                color: weekPressed ? Colors.white : Colors.black,
                                fontSize: (isTablet(context)) ? screenWidth * 0.029 : screenWidth * 0.038,
                              ),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        if (!monthPressed) {
                          setState(() {
                            weekPressed = false;
                            monthPressed = true;
                            yearPressed = false;
                            selectedRange = 'Month';
                            updateDateRange();
                          });
                        }
                      },
                      child: Container(
                        height: screenHeight * 0.055,
                        width: screenWidth * 0.2,
                        color: monthPressed ? Colors.cyan : Color(0xFFDEDEDE),
                        child: Center(
                          child: Text(
                            "Month",
                            style: GoogleFonts.brunoAceSc(
                              textStyle: TextStyle(
                                color: monthPressed ? Colors.white : Colors.black,
                                fontSize: (isTablet(context)) ? screenWidth * 0.029 : screenWidth * 0.038,
                              ),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        if (!yearPressed) {
                          setState(() {
                            weekPressed = false;
                            monthPressed = false;
                            yearPressed = true;
                            selectedRange = 'Year';
                            updateDateRange();
                          });
                        }
                      },
                      child: Container(
                        height: screenHeight * 0.055,
                        width: screenWidth * 0.2,
                        decoration: BoxDecoration(
                          color: yearPressed ? Colors.cyan : Color(0xFFDEDEDE),
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20.0),
                            bottomRight: Radius.circular(20.0),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "Year",
                            style: GoogleFonts.brunoAceSc(
                              textStyle: TextStyle(
                                color: yearPressed ? Colors.white : Colors.black,
                                fontSize: (isTablet(context)) ? screenWidth * 0.029 : screenWidth * 0.038,
                              ),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }

  bool isTablet(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return screenWidth >= 600 && screenWidth <= 1024;
  }
}



