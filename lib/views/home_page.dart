import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const TopWidget(),
                const DailySummary(),
                WeeklySummary(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class WeeklySummary extends StatelessWidget {
  final List<String> data = ['1', '2', '3', '4', '5', '6', '7'];

  WeeklySummary({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: data.map((item) => _WeekDaySummary(text: item)).toList(),
    );
  }
}

class _WeekDaySummary extends StatelessWidget {
  final String text;
  const _WeekDaySummary({required this.text});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.black, width: 2),
        ),
        child: Text(text));
  }
}

class DailySummary extends StatelessWidget {
  const DailySummary({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const Text('Feels like 34°C'),
      Container(
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(15),
        ),
        width: 200,
        height: 200,
      )
    ]);
  }
}

class TopWidget extends StatelessWidget {
  const TopWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        // Date
        Text(
          'Friday, 11 October',
          style: TextStyle(fontSize: 20.0),
        ),
        // Weather Code
        Text(
          'Cloudy',
          style: TextStyle(fontSize: 20.0),
        ),
        // Temperature
        Text(
          '28°', //placeholder
          style: TextStyle(fontSize: 150.0),
        ),
      ],
    );
  }
}

// boy, does this thing look horrible