import 'package:collection/collection.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:weathering_willow/models/weather.dart';
import 'package:weathering_willow/utils/date_time.dart' as time;

Weather mapRemoteJsontoWeather(Map<String, dynamic> json) {
  final currentWeatherJson = json['current'];
  final tzlocation = tz.getLocation(json['timezone'] as String);
  final currentDateTime =
      time.fromUtcUnixTime(tzlocation, currentWeatherJson['current_weather']);
  final dailyJson = json['daily'];
  final dailyForecasts = List.generate(
      (dailyJson['time'] as List).length,
      (index) => DailyForecast(
          date: time.fromUtcUnixTime(
            tzlocation,
            dailyJson['time'][index] as int,
          ),
          minTemperature:
              (dailyJson['temperature_2m_min'][index] as num?)?.toDouble(),
          maxTemperature:
              (dailyJson['temperature_2m_max'][index] as num?)?.toDouble(),
          weatherCode: dailyJson['weathercode'][index] as int?));
  final hourlyJson = json['hourly'];
  final hourlyForecasts = List.generate(
    (hourlyJson['time'] as List).length - 1,
    (index) => HourlyForecast(
      date: time.fromUtcUnixTime(
        tzlocation,
        hourlyJson['time'][index] as int,
      ),
      // The probability of precipitation returned by Open-Meteo is for the
      // hour _before_ the forecast's indicated time. This is not how users
      // generally interpret probability of precipitation though, so here we
      // shift the index by 1 to make it so that the probability is for the
      // hour _after_ the current forecast's time.
      pop: (hourlyJson['precipitation_probability'][index + 1] as double?)! *
          100,
    ),
  );

  final closestHourlyForecastIndex =
      minBy<MapEntry<int, HourlyForecast>, Duration>(
    hourlyForecasts
        .asMap()
        .entries
        .where((entry) => entry.value.date.hour == currentDateTime.hour),
    (entry) => entry.value.date.difference(currentDateTime).abs(),
  )!
          .key;

  return Weather(
    currentWeather: CurrentWeather(
      date: time.fromUtcUnixTime(tzlocation, currentWeatherJson['time'] as int),
      temperature: (currentWeatherJson['temperature'] as num?)?.toDouble(),
      tempFeels:
          (currentWeatherJson['apparent_temperature'] as num?)?.toDouble(),
      windSpeed: (currentWeatherJson['windspeed'] as num?)?.toDouble(),
      weatherCode: currentWeatherJson['weathercode'] as int?,
      pop: hourlyForecasts[closestHourlyForecastIndex].pop,
    ),
    dailyForecasts: dailyForecasts,
  );
}
