import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:io' as Platform;

import 'package:cc_appd1/widgets/Weather.dart';
import 'package:cc_appd1/widgets/WeatherItem.dart';
import 'package:cc_appd1/models/WeatherData.dart';
import 'package:cc_appd1/models/ForecastData.dart';

void main () => runApp(new MyApp());

class MyApp extends StatelessWidget {  // stateless widget means that the widget wont change in its lifetime

 /* @override
  State<StatefulWidget> createState() {
    return new _MyHomePageState();
  }*/ //diff from mine, if implemented stops the navigation to next screen

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CC Task1',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'CC TASK 1'),
    );
  }
}

class MyHomePage extends StatefulWidget { // the widget who need to change based on that particular state/condn are stateful
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  bool isLoading = false;
  WeatherData weatherData;
  ForecastData forecastData;
  Location _location = new Location();
  String error;

  @override
  void initState() {
    super.initState();

    loadWeather();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Hello World!',
      theme: ThemeData(
        primarySwatch: Colors.blue, // colour of app bar
      ),
      home: Scaffold(
          backgroundColor: Colors.blueGrey,
          appBar: AppBar(
            title: Text('WEATHER APP !'), // provides heading of the app
          ),
          body: Center(
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  //the height of column will be sum of children, if max, it will be entire scaffold irresp of child sizes sum
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0), child: weatherData != null ? Weather(weather: weatherData) : Container(),
                               ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: isLoading ? CircularProgressIndicator(
                              strokeWidth: 2.0,
                              valueColor: new AlwaysStoppedAnimation(Colors.white),
                            )
                                :IconButton(
                              icon: new Icon(Icons.refresh),
                              tooltip: 'Refresh',
                              onPressed: () => null,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 200.0,
                          child: forecastData != null ? ListView.builder(
                              itemCount: forecastData.list.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) => WeatherItem(weather: forecastData.list.elementAt(index))
                          ) : Container(),
                          ),
                        ),
                      ),

                    RaisedButton(
                      color: Colors.blue,
                      child: Text('Search City',style: new TextStyle(color: Colors.white)),
                      onPressed: (){
                        Navigator.push( context, MaterialPageRoute(builder: (context) => SecondRoute()),);
                        // Navigate to second route when tapped
                      },
                    ),

                  ]
              )
          )
      ),
    );
  }


  loadWeather() async {
    setState(() {
      isLoading = true;
    });


    LocationData location;

    try {
      location = await _location.getLocation();
      error = null;
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        error = 'Permission denied';
      } else if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
        error = 'Permission denied - please ask the user to enable it from the app settings';
      }
      location = null;
    }

    if (location != null) {
      final lat = location.latitude;
      final lon = location.longitude;

      final weatherResponse = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?APPID=0721392c0ba0af8c410aa9394defa29e&lat=${lat
              .toString()}&lon=${lon.toString()}'));
      final forecastResponse = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?APPID=0721392c0ba0af8c410aa9394defa29e&lat=${lat
              .toString()}&lon=${lon.toString()}'));

      if (weatherResponse.statusCode == 200 &&
          forecastResponse.statusCode == 200) {
        return setState(() {
          weatherData =
          new WeatherData.fromJson(jsonDecode(weatherResponse.body));
          forecastData =
          new ForecastData.fromJson(jsonDecode(forecastResponse.body));
          isLoading = false;
        });
      }

      setState(() {
        isLoading = false;
      });
    }
  }
}

/*class SecondRoute extends StatelessWidget  {
  SecondRoute({key}) : super(key: key);

  _MyHomePageState myHomePageState= new _MyHomePageState();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Second Route"),
      ),
      body: Column(
          children:[
            SizedBox(height: 15),
            new Text( 'new screen',//result
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),), // for giving my results out

            RaisedButton(
              color: Colors.yellow,
              child: Text('GO BACK!',
              style: TextStyle(
                color: Colors.white
              ),),
              onPressed: (){
                Navigator.pop(context);
              },
            ),

          ]
      ),
    );
  }
}*/
class SecondRoute extends StatefulWidget {
  SecondRoute({Key key}) : super(key: key);

  @override
  _SecondRoute createState() => _SecondRoute();
  //_MyHomePageState createState() => _MyHomePageState();
  /*
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CC Task1',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'CC TASK 1'),
    );
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    //throw UnimplementedError();
  }*/
}

class _SecondRoute extends State<SecondRoute>{

  //SecondRoute({key}) : super(key: key);

  _MyHomePageState myHomePageState= new _MyHomePageState();

  int temperature;
  String location = "San Francisco";
  int woeid = 2487956;
  String weather = 'clear';
  String abbreviation= '';
  String errorMessage = '';

  String searchApiUrl = "https://www.metaweather.com/api/location/search/?query=";
  String locationApiUrl = 'https://www.metaweather.com/api/location/';

  @override
  void initState() {
    super.initState();
    fetchLocation();
  }

  void fetchSearch(String input) async{
    try {
      var searchResult = await http.get(Uri.parse(searchApiUrl + input));
      var result = json.decode(searchResult.body)[0];

      setState(() {
        location = result["title"];
        woeid = result["woeid"];
        errorMessage='';
      });
    }
    catch(error){
      setState(() {
        errorMessage = "Sorry, we don't have data about this city.";
      });
    }
  }

  void fetchLocation() async{  // some error here
    var locationResult = await http.get(Uri.parse(locationApiUrl+woeid.toString()));
    var result = json.decode(locationResult.body);
    var consolidated_weather = result["consolidated_weather"];
    var data = consolidated_weather[0];

    setState(() {
      temperature = data ["the_temp"].round();
      weather = data["weather_state_name"].replaceAll(' ','').toLowerCase(); // imp step as state received was Heavy Rain and we need heavyrain
      abbreviation = data["weather_state_abbr"];
    });
  }

  void onTextFieldSubmitted(String input) async{
    await fetchSearch(input);
    await fetchLocation();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/$weather.png'),
                fit: BoxFit.cover,
              )
          ),
          child: temperature == null? Center(child: CircularProgressIndicator()): Scaffold(
            backgroundColor: Colors.transparent,
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Column(
                    children: <Widget>[
                      Center(
                        child: Image.network(
                          'https://www.metaweather.com/static/img/weather/png/'+abbreviation+'.png',
                          width: 100,
                        ),
                      ),
                      Center(
                        child: Text(
                          temperature.toString()+'°C',
                          style: TextStyle(color: Colors.white, fontSize: 60.0),
                        ),
                      ),
                      Center(
                        child: Text(
                          location,
                          style: TextStyle(color: Colors.white, fontSize: 40.0),
                        ),
                      )
                    ]
                ),
                Column(
                  children:<Widget>[
                    Container(
                      width: 300,
                      child: TextField(
                        onSubmitted: (String input){ // used for calling the 2 fn when input of city is received
                          onTextFieldSubmitted(input); // function defn after fetch location
                        },
                        style: TextStyle(color: Colors.white, fontSize: 25.0),
                        decoration: InputDecoration(
                          hintText: 'Search another city...',
                          hintStyle: TextStyle(color: Colors.white, fontSize: 18.0),
                          prefixIcon: Icon(Icons.search, color: Colors.white),
                        ),
                      ),
                    ),
                    Text(
                      errorMessage,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.redAccent, //fontSize: Platform.isAndroid? 15.0:20.0
                      ),
                    ),
                    RaisedButton(
                      color: Colors.blueGrey,
                      child: Text('GO BACK!',
                        style: TextStyle(
                            color: Colors.white
                        ),),
                      onPressed: (){
                        Navigator.pop(context);
                      },
                    ),
                  ],
                )

              ],
            ),
          )
      ),
    );
  }
}

