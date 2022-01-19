import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import 'package:cc_appd1/models/WeatherData.dart';

class Weather extends StatelessWidget {

  final WeatherData weather;

  Weather({Key key, @required this.weather}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(weather.name, style: new TextStyle(color: Colors.white, fontSize: 38.0 )),
        Text(weather.main, style: new TextStyle(color: Colors.white, fontSize: 32.0)),
        Text('${(weather.temp-273.15).toStringAsFixed(2)}°C',  style: new TextStyle(color: Colors.white)), //toStringAsFixed to fix the problem of many decimal places
        Image.network('https://openweathermap.org/img/w/${weather.icon}.png'),
        Text(new DateFormat.yMMMd().format(weather.date), style: new TextStyle(color: Colors.white)),
        Text(new DateFormat.Hm().format(weather.date), style: new TextStyle(color: Colors.white)),
      ],
    );
  }
}