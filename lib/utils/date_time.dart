import 'package:timezone/timezone.dart';

TZDateTime fromUtcUnixTime(Location location, int seconds) =>
    TZDateTime.fromMillisecondsSinceEpoch(location, seconds * 1000);
