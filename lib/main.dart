import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:dynamic_theme/dynamic_theme.dart';

Future<LangClass> fetchLangClass() async {
  final response = await http.get('http://165.22.19.126/');

  if (response.statusCode == 200) {
    return LangClass.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load LangClass');
  }
}

class LangClass {
  final List<String> langs;

  LangClass({this.langs});

  factory LangClass.fromJson(Map<String, dynamic> json) {
    // print(json["languages"]);
    return LangClass(
      langs: List.from(json["languages"]),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return DynamicTheme(
      defaultBrightness: Brightness.dark,
      data: (brightness) => ThemeData(
        brightness: brightness,
      ),
      themedWidgetBuilder: (context, theme) {
        return MaterialApp(
          title: 'Flutter Demo',
          theme: theme,
          home: MyHomePage(
            title: 'Flutter Simple App',
          ),
        );
      },
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
  Future<LangClass> langList;
  bool themeSwitched = true;
  String langChecked = 'English';
  Map<String, dynamic> result;

  Brightness brightness;

  void getData() async {
    //use a Async-await function to get the data
    final data = await FirebaseFirestore.instance
        .collection("statues")
        .doc('data')
        .get(); //get the data
    result = data.data();
    langChecked = result['lang'];
    themeSwitched = (result['mode'] == 'true');
  }

  void setData() async {
    await FirebaseFirestore.instance
        .collection("statues")
        .doc('data')
        .update(result);
  }

  @override
  void initState() {
    super.initState();
    langList = fetchLangClass();
    getData();
    changeBrightness();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Hello World',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: null,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
      endDrawer: buildDrawer(context),
    );
  }

  Widget buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.symmetric(vertical: 70.0, horizontal: 30.0),
        children: <Widget>[
          SwitchListTile(
            title: const Text('Darkmode'),
            value: themeSwitched,
            onChanged: (value) {
              setState(() {
                themeSwitched = value;
                result['mode'] = value;
              });
              setData();
              changeBrightness();
            },
            activeTrackColor: Colors.lightBlueAccent,
            activeColor: Colors.blue,
          ),
          ExpansionTile(
            title: Text("Languages"),
            children: <Widget>[
              FutureBuilder<LangClass>(
                future: langList,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListBody(
                      children: snapshot.data.langs
                          .map((lang) => buildLang(context, lang))
                          .toList(),
                    );
                    // );
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }

                  // By default, show a loading spinner.
                  return CircularProgressIndicator();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildLang(BuildContext context, String lang) {
    return CheckboxListTile(
      title: new Text(lang),
      value: langChecked == lang,
      onChanged: (bool value) {
        setState(() {
          if (value) {
            langChecked = lang;
            result['lang'] = lang;
          }
        });
        setData();
      },
    );
  }

  void changeBrightness() {
    DynamicTheme.of(context)
        .setBrightness(themeSwitched ? Brightness.dark : Brightness.light);
  }
}
