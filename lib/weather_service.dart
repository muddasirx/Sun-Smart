import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:untitled/providers/sessionDetailsProvider.dart';

class WeatherService {
  //static final String apiKey = '653a6225e629445477d9d634e85d2671';   // openWeatherMap

  static final String apiKey = 'openuv-l673rm4pe5qnp-io';     // openUV

  static Future<double?> fetchUVIndex(double latitude, double longitude,sessionDetailsNotifier sessionDetails) async {
    print("Inside data fetching Api method");
    //final url = Uri.parse('https://api.openweathermap.org/data/2.5/uvi?lat=$latitude&lon=$longitude&appid=$apiKey');    // openWeatherMap


    try {
      //final response = await http.get(url);     // openWeatherMap

      final response = await http.get(                  // openUV
        Uri.parse(
          'https://api.openuv.io/api/v1/uv?lat=$latitude&lng=$longitude',
        ),
        headers: {
          'x-access-token': apiKey,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        //return data['value']?.toDouble();    // openWeatherMap

        print("---------------UV index from Api: ${data['result']['uv']}-------------------");

        String truncatedValue = data['result']['uv'].toStringAsFixed(1);
        double result = double.parse(truncatedValue);

        DateTime sunsetTime = DateTime.parse(data['result']["sun_info"]['sun_times']['sunset']);

        DateTime sunriseTime = DateTime.parse(data['result']["sun_info"]['sun_times']['sunrise']);

        final currentTime = DateTime.now();

        if (currentTime.isBefore(sunriseTime) || currentTime.isAtSameMomentAs(sunsetTime) || currentTime.isAfter(sunsetTime)) {
          sessionDetails.sessionSuspended();
          sessionDetails.nightArrived();
          print("inside night case");
        } else {
          print("inside no sunset case");
          Duration timeUntilSunset = sunsetTime.difference(currentTime);
          sessionDetails.addSunsetDuration(timeUntilSunset.inMinutes);
        } 

        /*print("Calculating Time till Sunset");
        final currentTime = DateTime.now();
        if (currentTime.isBefore(sunsetTime)) {
          Duration timeUntilSunset = sunsetTime.difference(currentTime);
          sessionDetails.addSunsetDuration(timeUntilSunset.inMinutes);
          print("-------Time till sunset in duration: ${timeUntilSunset}----------");
        }else{
          sessionDetails.sessionSuspended();
          sessionDetails.nightArrived();
        }*/
        return result;       // openUV

      }else if(response.statusCode==403){
        return 100.0;
      }
      else {
        print('Error: ${response.statusCode} - ${response.reasonPhrase}');
        return null;
      }
    } catch (e) {
      print('Error fetching UV index: $e');
      return null;
    }
  }
}
