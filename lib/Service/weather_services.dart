import 'dart:convert';
import 'dart:html';
import 'package:http/http.dart' as http;
import 'package:weather/model/weather_model.dart';

class WeatherServices {
  final String apikey = 'bd18fff4dec6c644d2fbba7819fd071f';

  Future<Weather> featchWeather(String cityName) async {
    final Url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apikey');

    final response = await http.get(Url);

    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('fail to load weatger data');
    }
  }
}
