import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:untitled/providers/sessionDetailsProvider.dart';

class WeatherService {
  //static final String apiKey = '653a6225e629445477d9d634e85d2671';   // openWeatherMap

  static final String apiKey = 'openuv-1fqpnrm33tvt9h-io';     // openUV

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

        DateTime thirtyMinutesBeforeSunset = sunsetTime.subtract(Duration(minutes: 30));

        // Add 30 minutes to the current time
        DateTime currentTimePlusThirty = DateTime.now().add(Duration(minutes: 30));
        final currentTime = DateTime.now();
        // Check if the current time plus 30 minutes has reached or passed 30 minutes before sunset
        if (currentTimePlusThirty.isAfter(thirtyMinutesBeforeSunset) || currentTimePlusThirty.isAtSameMomentAs(thirtyMinutesBeforeSunset)) {
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

      } else {
        print('Error: ${response.statusCode} - ${response.reasonPhrase}');
        return null;
      }
    } catch (e) {
      print('Error fetching UV index: $e');
      return null;
    }
  }
}
