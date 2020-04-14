import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:flutter_sparkline/flutter_sparkline.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Covid-19',
      theme: ThemeData(
        primaryColor: Color(0xffff6101),
      ),
      home: MyHomePage(title: 'Covid-19'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Map dataarr;
  Map datacont;
  List userdata;
  List usercont;
  int TotalCases;
  int deaths;
  int recovered;
  String lastupdated;
  List test;
  String mainnum;
  String mainemail;
  Future getData() async {
     http.Response response = await http.get("https://api.rootnet.in/covid19-in/stats/latest");
     http.Response response2 = await http.get("http://pranjal-ag.herokuapp.com/apipast.php");
     http.Response responsenum = await http.get("https://api.rootnet.in/covid19-in/contacts");

     test = json.decode(response2.body);
//     var sList = List<double>.from(test);

     dataarr = json.decode(response.body);
     datacont = json.decode(responsenum.body);
     setState(() {
       userdata = dataarr["data"]["regional"];
       usercont = datacont["data"]["contacts"]["regional"];
       lastupdated = dataarr["lastRefreshed"];
       TotalCases = dataarr["data"]["summary"]["total"];
       deaths = dataarr["data"]["summary"]["deaths"];
       recovered = dataarr["data"]["summary"]["discharged"];
       mainnum = datacont["data"]["contacts"]["primary"]["number-tollfree"];
       mainemail = datacont["data"]["contacts"]["primary"]["email"];
     });
     debugPrint(usercont.toString());
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }
//  var sList = sList;
  var data = [4789.00,5274.00,5865.00,6761.00,7529.00,8447.00,9352.00];

  Material mychart1Items(String title, String priceVal,String subtitle) {
    return Material(
      color: Colors.white,
      elevation: 14.0,
      borderRadius: BorderRadius.circular(24.0),
      shadowColor: Color(0x802196F3),
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[

                  Padding(
                    padding: EdgeInsets.all(1.0),
                    child: Text(title, style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.blueAccent,
                    ),),
                  ),

                  Padding(
                    padding: EdgeInsets.all(1.0),
                    child: Text(priceVal, style: TextStyle(
                      fontSize: 30.0,
                    ),),
                  ),
                  Padding(
                    padding: EdgeInsets.all(1.0),
                    child: Text(subtitle, style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.blueGrey,
                    ),),
                  ),

                  Padding(
                    padding: EdgeInsets.all(1.0),
                    child: new Sparkline(
                      data: data,
                      fillMode: FillMode.below,
                      fillGradient: new LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.amber[800], Colors.amber[200]]
                      ),
                      lineColor: Colors.red,
//                      lineWidth: 6.0,
                      pointsMode: PointsMode.all,
                      pointSize: 8.0,
                      pointColor: Colors.red,
                    ),
                  ),

                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Material listitems() {
    return Material(
      color: Colors.white,
      elevation: 14.0,
      borderRadius: BorderRadius.circular(24.0),
      shadowColor: Color(0x802196F3),
      child: Container(
        margin: EdgeInsets.fromLTRB(4.0, 16.0, 4.0, 16.0),
        child: ListView.builder(
            itemCount: userdata == null ? 0 : userdata.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
//              margin: EdgeInsets.all(6.0),
                padding: EdgeInsets.fromLTRB(0.0,10.0,0.0,10.0),
                child: Row(
//                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.all(6.0),
                            child: Text("${userdata[index]["loc"]}",
                              style: TextStyle(
                                fontSize: 16.0,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.all(6.0),
                            child: Text("${userdata[index]["totalConfirmed"]}",
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.all(6.0),
                            child: Text("${userdata[index]["deaths"]}",
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.redAccent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.all(6.0),
                            child: Text("${userdata[index]["discharged"]}",
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.greenAccent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
        ),
      ),
    );
  }

  Material textStats() {
    return Material(
      color: Colors.white,
      elevation: 14.0,
      borderRadius: BorderRadius.circular(24.0),
      shadowColor: Color(0x802196F3),
      child: Container(
        padding: EdgeInsets.fromLTRB(0.0,10.0,0.0,10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(1.0),
                  child: Text('Total', style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.blueAccent,
                  ),),
                ),

                Padding(
                  padding: EdgeInsets.all(1.0),
                  child: Text('$TotalCases', style: TextStyle(
                    fontSize: 30.0,
                  ),),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(1.0),
                  child: Text('Deaths', style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.redAccent,
                  ),),
                ),

                Padding(
                  padding: EdgeInsets.all(1.0),
                  child: Text('$deaths', style: TextStyle(
                    fontSize: 30.0,
                  ),),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(1.0),
                  child: Text('Recovered', style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.greenAccent,
                  ),),
                ),

                Padding(
                  padding: EdgeInsets.all(1.0),
                  child: Text('$recovered', style: TextStyle(
                    fontSize: 30.0,
                  ),),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Material dosdonts() {
    return Material(
      color: Colors.white,
      elevation: 14.0,
      borderRadius: BorderRadius.circular(24.0),
      shadowColor: Color(0x802196F3),
      child: Container(
        margin: EdgeInsets.fromLTRB(4.0, 16.0, 4.0, 16.0),
        child: Text(
          'DOs & DONTs',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Material statewisehelp() {
    return Material(
      color: Colors.white,
      elevation: 14.0,
      borderRadius: BorderRadius.circular(24.0),
      shadowColor: Color(0x802196F3),
      child: Container(
        margin: EdgeInsets.fromLTRB(4.0, 16.0, 4.0, 16.0),
        child: ListView.builder(
          itemCount: usercont == null ? 0 : usercont.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
//              margin: EdgeInsets.all(6.0),
              padding: EdgeInsets.fromLTRB(0.0,10.0,0.0,10.0),
              child: Row(
//                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.all(6.0),
                          child: Text("${usercont[index]["loc"]}",
                            style: TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.all(6.0),
                          child: Text("${usercont[index]["number"]}",
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Material nationalCont() {
    return Material(
      color: Colors.white,
      elevation: 14.0,
      borderRadius: BorderRadius.circular(24.0),
      shadowColor: Color(0x802196F3),
      child: Container(
        padding: EdgeInsets.fromLTRB(0.0,10.0,0.0,10.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'National Helpline',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: Icon(
                        Icons.mail,
                        size: 40,
                      ),
                    ),
                    Expanded(
                        flex: 4,
                        child: Text(
                            '$mainemail',
                            style: TextStyle(
                            fontSize: 16.0,
                          ),
                        )
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: Icon(
                        Icons.phone,
                        size: 40,
                      ),
                    ),
                    Expanded(
                        flex: 4,
                        child: Text(
                            '$mainnum   (Toll-free)',
                            style: TextStyle(
                              fontSize: 16.0,
                            ),
                        )
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body:Container(
        color:Color(0xffE5E5E5),
        child:StaggeredGridView.count(
          crossAxisCount: 4,
          crossAxisSpacing: 6.0,
          mainAxisSpacing: 4.0,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: mychart1Items("Past Week Stats","04/04 - 11/04",""),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: textStats(),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: listitems(),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: dosdonts(),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: statewisehelp(),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: nationalCont(),
            ),
          ],
          staggeredTiles: [
            StaggeredTile.extent(4, 250.0),
            StaggeredTile.extent(4, 125.0),
            StaggeredTile.extent(4, 375.0),
            StaggeredTile.extent(4, 500.0),
            StaggeredTile.extent(4, 375.0),
            StaggeredTile.extent(4, 200.0),
          ],
        ),
      ),
    );
  }
}