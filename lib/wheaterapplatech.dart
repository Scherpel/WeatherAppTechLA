import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'util/utils.dart' as util;
import 'dart:async';

class WheaterAppLaTech extends StatefulWidget {
  @override
  _WheaterAppLaTechState createState() => _WheaterAppLaTechState();
}

class _WheaterAppLaTechState extends State<WheaterAppLaTech> {
  String cityEntered;

  Future pageSwitch(BuildContext context) async{
    Map results = await Navigator.of(context).push(
      new MaterialPageRoute(builder: (BuildContext context){
        return new ChangeCity();
      })
    );

    if(results != null && results.containsKey('enter')){
        cityEntered = results['enter'];
    }
  }


  void showStuff() async {
   Map data = await getWheater(util.appId, util.defaultCity);
   print(data.toString());
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('WheaterAppLaTech'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.search),
            onPressed: (){pageSwitch(context);},
          ),
        ],
      ),
      body: new Stack(
        children: <Widget>[
          new Center(
            child: new Image.asset('images/background.png', width: 490.0, height: 1200, fit: BoxFit.fill,),
          ),

          new Container(
          alignment: Alignment.topCenter,
            margin: EdgeInsets.fromLTRB(0, 170, 0, 0),
            child: new Text('${cityEntered == null ? util.defaultCity : cityEntered}', style: cityStyle(),),
          ),

          new Container(
            alignment: Alignment.bottomCenter,
            margin: EdgeInsets.fromLTRB(40, 270, 0, 0),
            child: updateTempWidget(cityEntered),
          ),

          new Container(
            alignment: Alignment.bottomCenter,

            child: new Text('Developed by Lucas Scherpel', style: wStyle(),),
          ),
        ],
      )
    );

  }
  Future<Map> getWheater(String appId, String city) async{
    String apiUrl = 'http://api.openweathermap.org/data/2.5/weather?q=$city&APPID=${util.appId}&units=imperial';
    http.Response response = await http.get(apiUrl);
    return json.decode(response.body);
  }

  Widget updateTempWidget(String city){
    return new FutureBuilder(
      future: getWheater(util.appId, city == null ? util.defaultCity : city),
        builder: (BuildContext context, AsyncSnapshot<Map> snapshot,){
          if(snapshot.hasData){
            Map content = snapshot.data;
              return new Container(
                child: new Column(
                  children: <Widget>[
                    new ListTile(
                      title: new Text(content['main']['temp'].toString() +" F",
                      style: new TextStyle(
                        fontSize: 75,
                        color: Colors.white70,
                      ),

                      ),
                      subtitle: new ListTile(
                        title: new Text(
                            "Humidity: ${content['main']['humidity'].toString()}%\n"
                            "Min: ${content['main']['temp_min'].toString()} F\n"
                            "Max: ${content['main']['temp_max'].toString()} F\n",
                          style: extraTemp(),

                        ),
                      ),
                    )

                  ]
                 )
              );
        }else{
            return new Container();
          }
        });
  }
}





TextStyle cityStyle() {
  return new TextStyle(
    color: Colors.white70, fontSize: 60
  );
}

TextStyle wStyle() {
  return new TextStyle(
      color: Colors.black54, fontSize: 20
  );
}

TextStyle extraTemp(){
  return new TextStyle(
      color: Colors.white70, fontSize: 20,

  );
}

class ChangeCity extends StatelessWidget {
  @override
  var cityFieldController = new TextEditingController();
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.blueAccent,
        title: new Text('Choose a city:'),
        centerTitle: true,
      ),
      body: new ListView(
        children: <Widget>[
          new ListTile(
            title: new TextField(
              decoration: new InputDecoration(hintText: 'Enter city: ',),
              controller: cityFieldController,
              keyboardType: TextInputType.text,
            ),
          ),
          new ListTile(
            title: new FlatButton(
              onPressed: (){
                Navigator.pop(context, {
                  'enter': cityFieldController.text

                });
              },
              textColor: Colors.white,
              color: Colors.blueAccent,
              child: new Text('Get Wheater'),

            ),
          )
        ],
      ),
    );
  }
}
