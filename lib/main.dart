import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';

Future<Map<String, double>> fetchLocation() async {
  var location = new Location();
  try {
    return await location.getLocation();
  } catch (error) {
    throw Exception(error.toString());
  }
}

Future<String> fetchResponse(double lat, double lng) async {
  final response = await http.get('https://aiib.vapor.cloud/' + lat.toString() + '/' + lng.toString());
  if (response.statusCode == 200) {
    return response.body;
  } else {
    throw Exception('Failed to fetch response');
  }
}

Future<String> fetchInBerlin() async {
  return fetchLocation().then((location) => fetchResponse(location["latitude"], location["longitude"]));
}

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'AmIInBerlin',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'AmIInBerlin'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FutureBuilder<String>(
              future: fetchInBerlin(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data == 'true') {
                    return Text('You\'re in Berlin');
                  } else {
                    return Text('You\'re not in Berlin');
                  }
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
                return CircularProgressIndicator();
              },
            ),
          ],
        ),
      ),
    );
  }
}
