class Weather {
  const Weather({required this.dailyForecasts, required this.currentWeather});

  final List<DailyForecast> dailyForecasts;
  final CurrentWeather currentWeather;

  DailyForecast get currentDailyForecast => dailyForecasts[0];

  // @override
  // List<Object> get props => [dailyForecasts, hourlyForecasts];
}

class DailyForecast {
  const DailyForecast(
      {required this.date,
      required this.minTemperature,
      required this.maxTemperature,
      required this.weatherCode});

  final DateTime date;

  final double? minTemperature;
  final double? maxTemperature;
  final int? weatherCode;
}

class CurrentWeather {
  const CurrentWeather({
    required this.date,
    required this.temperature,
    required this.tempFeels,
    required this.windSpeed,
    required this.weatherCode,
    // probability of precipitation
    required this.pop,
  });

  final DateTime date;
  final double? temperature;
  final double? windSpeed;
  final double? tempFeels;
  final int? weatherCode;
  final double? pop;
}

class HourlyForecast {
  const HourlyForecast({
    required this.date,
    required this.pop,
  });

  final DateTime date;

  // Probability of precipitation.
  final double? pop;
}
