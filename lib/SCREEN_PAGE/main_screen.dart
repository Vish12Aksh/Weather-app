import 'package:flutter/material.dart';
import 'package:weather/Service/weather_services.dart';
import 'package:weather/model/weather_model.dart';



class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final WeatherServices _weatherServices = WeatherServices();
  final TextEditingController _controller = TextEditingController();

  bool _isLoading = false;
  Weather? _weather;

  void _getWeather() async {
    FocusScope.of(context).unfocus(); // Hide keyboard
    setState(() {
      _isLoading = true;
    });
    try {
      final weather = await _weatherServices.featchWeather(_controller.text);
      setState(() {
        _weather = weather;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ Failed to fetch weather")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: _weather != null &&
                  _weather!.description.toLowerCase().contains('rain')
              ? const LinearGradient(
                  colors: [Colors.grey, Colors.blueGrey],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter)
              : _weather != null &&
                      _weather!.description.toLowerCase().contains('clear')
                  ? const LinearGradient(
                      colors: [Colors.yellow, Colors.blueAccent],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter)
                  : const LinearGradient(
                      colors: [Colors.grey, Colors.lightBlueAccent],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const SizedBox(height: 50),
                const Text(
                  'Weather App',
                  style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const SizedBox(height: 25),
                TextField(
                  controller: _controller,
                  onSubmitted: (_) => _getWeather(),
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Enter your city name",
                    hintStyle: const TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: Colors.black.withOpacity(0.2),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search, color: Colors.white),
                      onPressed: _getWeather,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                if (_isLoading)
                  const CircularProgressIndicator()
                else if (_weather != null)
                  Column(
                    children: [
                      Text(
                        _weather!.cityName,
                        style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '${_weather!.temperature}°C',
                        style:
                            const TextStyle(fontSize: 40, color: Colors.white),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        _weather!.description,
                        style: const TextStyle(
                            fontSize: 20, color: Colors.white70),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Humidity: ${_weather!.humidity}%',
                        style: const TextStyle(color: Colors.white),
                      ),
                      Text(
                        'Wind: ${_weather!.windSpeed} km/h',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  )
                else
                  const Text(
                    'Enter a city to see the weather.',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
