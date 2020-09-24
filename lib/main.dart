import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Simple App'),
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
  bool themeSwitched = false;
  String langChecked = 'en';

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
      ), // This trailing comma makes auto-formatting nicer for build methods.

      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 70.0, horizontal: 30.0),
          children: <Widget>[
            SwitchListTile(
              title: const Text('Darkmode'),
              value: themeSwitched,
              onChanged: (value) {
                setState(() {
                  themeSwitched = value;
                  print(themeSwitched);
                });
              },
              activeTrackColor: Colors.lightBlueAccent,
              activeColor: Colors.blue,
            ),
            ExpansionTile(
              title: Text("Languages"),
              children: <Widget>[
                CheckboxListTile(
                  title: const Text('English'),
                  value: langChecked == 'en',
                  onChanged: (bool value) {
                    setState(() {
                      langChecked = value ? 'en' : 'de';
                    });
                  },
                ),
                CheckboxListTile(
                  title: const Text('German'),
                  value: langChecked == 'de',
                  onChanged: (bool value) {
                    setState(() {
                      langChecked = value ? 'de' : 'en';
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
