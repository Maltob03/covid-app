import 'dart:convert';
import 'package:flutter/material.dart';
import '../panels/Homemosteffectedcountries.dart';
import '../panels/ItalyHomeDataBloc.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map worldData;
  fetchWorldWideData() async {
    http.Response response =
        await http.get('https://corona.lmao.ninja/v2/countries/italy');
    setState(() {
      worldData = json.decode(response.body);
    });
  }

  List countryData;
  fetchCountryData() async {
    http.Response response =
        await http.get('https://corona.lmao.ninja/v2/countries?sort=cases');
    setState(() {
      countryData = json.decode(response.body);
    });
  }

  Future fetchData() async {
    fetchWorldWideData();
    fetchCountryData();
    print('fetchData called');
  }

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  Color primaryBlack = Color(0xff202c3b);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: false,
        title: Text(
          'COVID-19 TRACKER',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: fetchData,
        child: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Italia',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            worldData == null
                ? CircularProgressIndicator()
                : WorldwidePanel(
                    worldData: worldData,
                  ),
            SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10.0,
              ),
              child: Text(
                'I paesi più colpiti',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            countryData == null
                ? Container()
                : MostAffectedPanel(
                    countryData: countryData,
                  ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 50,
            )
          ],
        )),
      ),
    );
  }
}
