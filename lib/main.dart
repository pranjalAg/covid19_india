import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:flutter_sparkline/flutter_sparkline.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_echarts/flutter_echarts.dart';

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
  Map pastdata;
  int _state = 0;
  List pastlist;
  List newpastList;
  List sList;
  String pastdaterange;
  Future getData() async {
     http.Response response = await http.get("https://api.rootnet.in/covid19-in/stats/latest");
     http.Response response2 = await http.get("http://pranjal-ag.herokuapp.com/apipast.php");
     http.Response responsenum = await http.get("https://api.rootnet.in/covid19-in/contacts");

     pastdata = json.decode(response2.body);
     pastlist = pastdata['list'];
     newpastList = List<double>.from(pastlist);

     dataarr = json.decode(response.body);
     datacont = json.decode(responsenum.body);
     setState(() {
       sList = newpastList;
       pastdaterange = pastdata['dates'];
       userdata = dataarr["data"]["regional"];
       usercont = datacont["data"]["contacts"]["regional"];
       lastupdated = dataarr["lastRefreshed"];
       TotalCases = dataarr["data"]["summary"]["total"];
       deaths = dataarr["data"]["summary"]["deaths"];
       recovered = dataarr["data"]["summary"]["discharged"];
       _state = 1;
     });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }
  Color gradientStart = Colors.greenAccent; //Change start gradient color here
  Color gradientEnd = Colors.redAccent; //Change end gradient color here

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
                      data: sList,
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
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(16.0),
                  padding: EdgeInsets.all(4.0),
                  child: Text(
                    'Dos & Donts',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image(
                        image: AssetImage('images/dos1.png'),
                        width: 100,
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(0.0, 2.0, 0.0, 6.0),
                        margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 6.0),
                        child: Text(
                          'Keep hands clean',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Image(
                        image: AssetImage('images/dos2.png'),
                        width: 100,
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(0.0, 2.0, 0.0, 6.0),
                        margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
                        child: Text(
                          'Cover while sneezing',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image(
                        image: AssetImage('images/dos3.png'),
                        width: 100,
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 6.0),
                        padding: EdgeInsets.fromLTRB(0.0, 2.0, 0.0, 6.0),
                        child: Text(
                          'Cook your food',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Image(
                        image: AssetImage('images/dos4.png'),
                        width: 100,
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
                        padding: EdgeInsets.fromLTRB(0.0, 2.0, 0.0, 6.0),
                        child: Text(
                          'Use Face Mask',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image(
                        image: AssetImage('images/dont1.png'),
                        width: 100,
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 6.0),
                        padding: EdgeInsets.fromLTRB(0.0, 2.0, 0.0, 6.0),
                        child: Text(
                          'Avoid Touching\nyour Face',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Image(
                        image: AssetImage('images/dont2.png'),
                        width: 100,
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
                        padding: EdgeInsets.fromLTRB(0.0, 2.0, 0.0, 6.0),
                        child: Text(
                          'Avoid contact \nwith sick people',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image(
                        image: AssetImage('images/dont3.png'),
                        width: 100,
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 6.0),
                        padding: EdgeInsets.fromLTRB(0.0, 2.0, 0.0, 6.0),
                        child: Text(
                          'Avoid Travelling\n',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Image(
                        image: AssetImage('images/dont4.png'),
                        width: 100,
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
                        padding: EdgeInsets.fromLTRB(0.0, 2.0, 0.0, 6.0),
                        child: Text(
                          'Avoid Crowds\n',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
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
                            'ncov2019@gov.in',
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
                            '1075  (Toll-free)',
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

  Material majorsymp() {
    return Material(
      color: Colors.redAccent,
      elevation: 14.0,
      borderRadius: BorderRadius.circular(24.0),
      shadowColor: Color(0x802196F3),
      child: Container(
        padding: EdgeInsets.fromLTRB(0.0,10.0,0.0,10.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    'Major Symptoms',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image(
                      image: AssetImage('images/sym1.png'),
                      width: 96,
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(0.0, 2.0, 0.0, 6.0),
                      child: Text(
                          'Fever',
                          style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Image(
                      image: AssetImage('images/sym2.png'),
                      width: 96,
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(0.0, 2.0, 0.0, 6.0),
                      child: Text(
                        'Runny Nose',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image(
                      image: AssetImage('images/sym3.png'),
                      width: 96,
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(0.0, 2.0, 0.0, 6.0),
                      child: Text(
                        'Cough',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Image(
                      image: AssetImage('images/sym4.png'),
                      width: 96,
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(0.0, 2.0, 0.0, 6.0),
                      child: Text(
                        'Shortness of Breath',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
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
      body: Center(
        child: _state == 0 ? SpinKitFadingCube(color: Colors.redAccent,
          size: 80.0,) : Container(
          color:Color(0xffE5E5E5),
          child:StaggeredGridView.count(
            crossAxisCount: 4,
            crossAxisSpacing: 6.0,
            mainAxisSpacing: 4.0,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: mychart1Items("Past Week Stats","$pastdaterange",""),
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
                child: majorsymp(),
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
              StaggeredTile.extent(4, 775.0),
              StaggeredTile.extent(4, 350.0),
              StaggeredTile.extent(4, 375.0),
              StaggeredTile.extent(4, 200.0),
            ],
          ),
        ),
      ),
    );
  }
}