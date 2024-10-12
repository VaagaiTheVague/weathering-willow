// ignore_for_file: unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weathering_willow/providers/weather_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    final read = context.read<WeatherProvider>();
    read.classInit();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WeatherProvider>(
        builder: (context, value, child) => MaterialApp(
                home: Scaffold(
              backgroundColor: Colors.cyan,
              body: Padding(
                padding: const EdgeInsets.only(top: 40.0),
                child: Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(15)),
                            child: Text(value.date.toString(),
                                style: const TextStyle(color: Colors.white))),
                        Text(value.key),
                        Text(value.temp,
                            style: const TextStyle(fontSize: 150.0)),
                        const Text('Summary', style: TextStyle(fontSize: 30)),
                        Text(value.weather),
                        Text(
                            'Temperature feels like ${value.apparenttemp}${value.unit}'),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                              width: 350,
                              height: 150,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(15.00),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.water,
                                        color: Colors.cyanAccent,
                                        size: 60.0,
                                      ),
                                      Text(
                                        '${value.wind.toString()} km/h',
                                        style: const TextStyle(
                                          color: Colors.cyanAccent,
                                          fontSize: 15,
                                        ),
                                      ),
                                      const Text(
                                        "Wind",
                                        style: TextStyle(
                                            color: Colors.cyanAccent,
                                            fontSize: 15),
                                      )
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.water_drop_outlined,
                                        color: Colors.cyanAccent,
                                        size: 60.0,
                                      ),
                                      Text(
                                        '${value.humidity} %',
                                        style: const TextStyle(
                                          fontSize: 15,
                                          color: Colors.cyanAccent,
                                        ),
                                      ),
                                      const Text(
                                        "Humidity",
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.cyanAccent,
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              )),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Weekly Forecast",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                              Icon(
                                Icons.arrow_forward_outlined,
                                size: 30,
                                color: Colors.black,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 4, 10, 10),
                          child: SizedBox(
                              height: 150,
                              child: CarouselView(
                                  itemExtent: 100,
                                  children: List.generate(7, (index) {
                                    return Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(25.0),
                                          color: Colors.black,
                                          border: Border.all(
                                            color: Colors.black,
                                            width: 5,
                                          )),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            value.isLoading
                                                ? 'loading'
                                                : '${index + 1}',
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: Color.fromARGB(
                                                    255, 200, 200, 200)),
                                          ),
                                          Text(
                                            value.isLoading
                                                ? 'loading'
                                                : value.dailytemp[index]
                                                    .toString(),
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.cyanAccent,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }))),
                        ),
                        const Text(
                            "1 is today, 7 is next week, shows the day's temperature"),
                      ]),
                ),
              ),
            )));
  }
}
