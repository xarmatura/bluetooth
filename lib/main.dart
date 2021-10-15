import 'package:flutter/material.dart';
import 'helpers/strings.dart';
import 'screens/scanned_page.dart';

void main() {
  runApp(const BluetoothApp());
}

class BluetoothApp extends StatelessWidget {

  const BluetoothApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MaterialApp(
      theme: ThemeData(scaffoldBackgroundColor: const Color.fromRGBO(221, 230, 232, 1)),
      home: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[
                  Colors.cyan,
                  Colors.indigo
              ]),
            ),
          ),
          title: const Padding(
            padding: EdgeInsets.only(left: 15.0),
            child: Text(Strings.appTitle),
          ),
        ),
        body: const HomePage(),
      ),
  );
}