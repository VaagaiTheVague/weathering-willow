import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class WeatherProvider with ChangeNotifier {
  bool _isLoading = true;
  bool get isLoading => _isLoading;
  String _temperature = " ";
  String get temp => _temperature;
  String _humidity = " ";
  String get humidity => _humidity;
  String _apparenttemp = " ";
  String get apparenttemp => _apparenttemp;
  String _location = " ";
  String get loc => _location;
  String _unit = " ";
  String get unit => _unit;
  String _time = " ";
  String get time => _time;
  String _wind = " ";
  String get wind => _wind;
  String _code = " ";
  String get code => _code;
  String _weather = " ";
  String get weather => _weather;
  String _date = " ";
  String get date => _date;
  String _ele = " ";
  String get ele => _ele;
  String _key = " ";
  String get key => _key;
  List<double> _dailytemp = [];
  List<String> _dailydate = [];
  List<double> get dailytemp => _dailytemp;
  List<String> get dailydate => _dailydate;

  Future<Position> _getPosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error("Location services are disabled");
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error("Location services are denied");
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error("Location permissions are denied forever");
    }
    return await Geolocator.getCurrentPosition();
  }

  Future<void> _getLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition();
      await getWeather(position);
    } catch (e) {
      await Geolocator.requestPermission();
      notifyListeners();
    }
  }

  Future<void> getWeather(Position position) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.https(
          'api.open-meteo.com',
          'v1/forecast',
          {
            'longitude': '${position.longitude}',
            'latitude': '${position.latitude}',
            'current':
                'temperature_2m,apparent_temperature,precipitation,weather_code,wind_speed_10m,relative_humidity_2m',
            'timezone': 'auto',
            'timeformat': 'unixtime',
            'daily': 'weather_code,temperature_2m_max,temperature_2m_min',
          },
        ),
      );

      if (response.statusCode == 200) {
        print('Response body: ${response.body}'); // Log the raw JSON response

        final body = jsonDecode(response.body);

        _location = body["timezone"].toString();
        _temperature = body['current']['temperature_2m'].toString();
        _humidity = body['current']['relative_humidity_2m'].toString();
        _apparenttemp = body['current']['apparent_temperature'].toString();
        _unit = body['daily_units']['temperature_2m_max'].toString();
        _time = body['current']['time'].toString();
        _wind = body['current']['wind_speed_10m'].toString();
        _code = body['current']['weather_code'].toString();
        DateTime now = DateTime.parse(_time);
        _date = DateFormat('yMd').format(now);
        _ele = body['elevation'].toString();
        _dailytemp = List<double>.from(body['daily']['temperature_2m_max']);
        _dailydate = List<String>.from(body['daily']['time'])
            .map((time) => time.toString())
            .toList();
        if (_code == '0') {
          _weather = 'Clear sky';
          _key = "Sunny";
        } else if (_code == '1' || _code == '2' || _code == '3') {
          _weather = 'Mainly clear, partly cloudy, and overcast';
          _key = "Cloudy";
        } else if (_code == "45" || _code == "48") {
          _weather = "Fog and depositing rime fog";
          _code = "Fog";
        } else if (_code == '51' || _code == '53' || _code == '55') {
          _weather = 'Drizzle: Light, moderate, and dense intensity';
          _key = "Drizzle";
        } else if (_code == "56" || _code == "57") {
          _weather = "Freezing Drizzle: Light and dense intensity";
          _key = "Cold";
        } else if (_code == '61' || _code == '63' || _code == '65') {
          _weather = 'Rain: Slight, moderate and heavy intensity';
          _key = "Moderate Rain";
        } else if (_code == "66" || _code == "67") {
          _weather = "Freezing Rain: Light and heavy intensity";
          _key = "Rain";
        } else if (_code == '80' || _code == '81' || _code == '82') {
          _weather = 'Rain showers: Slight, moderate, and violent';
          _key = "Rain";
        } else if (_code == "71" || _code == "73" || _code == "75") {
          _weather = "Snow fall: Slight, moderate, and heavy intensity";
        } else if (_code == "77") {
          _weather = "Snow grains";
          _code = "Snow";
        } else if (_code == "85" || _code == "86") {
          _weather = "Snow showers: Slight and heavy";
          _code = "Snow";
        } else if (_code == "96" || _code == "99") {
          _weather = "Thunderstorm with slight and heavy hail";
          _key = "Thunderstorm";
        } else if (_code == '95') {
          _weather = 'Thunderstorm: Slight or moderate';
          _key = "Thunderstorm";
        } else {
          _weather = 'Normal weather';
          _code = "Sunny";
        }

        if (body['error'] == true) {
          throw ServerError(reason: body['reason'] as String?);
        }
      } else {
        throw Exception('Failed to load weather data');
      }
    } on SocketException {
      throw const FailedToConnect();
    } on FormatException {
      throw const FailedToParseResponse();
    } catch (e, stacktrace) {
      print('Error: $e');
      print('Stacktrace: $stacktrace');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> classInit() async {
    await _getPosition();
    await _getLocation();
    notifyListeners();
  }
}

class FailedToConnect implements Exception {
  const FailedToConnect();
}

class FailedToParseResponse implements Exception {
  const FailedToParseResponse();
}

class ServerError implements Exception {
  final String? reason;
  const ServerError({this.reason});
}
