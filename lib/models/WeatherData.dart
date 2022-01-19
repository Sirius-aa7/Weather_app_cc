import 'package:flutter/material.dart';

class WeatherData {
  final DateTime date;
  final String name;
  final double temp;
  final String main;
  final String icon;

  // the call returns lots of data but we are interested in accessing only these 4 data fields

  WeatherData({this.date, this.name, this.temp, this.main, this.icon});

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      date: new DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000, isUtc: false), // utc false - related to local time zone
      name: json['name'],  // json call from OpenWeatherMap API - name field to fetch the name of city , similarly rest
      temp: json['main']['temp'].toDouble(),
      main: json['weather'][0]['main'],
      icon: json['weather'][0]['icon'],
    );
  }
}