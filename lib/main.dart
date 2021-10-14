import 'package:bluetooth/screens/bonded_page.dart';
import 'package:bluetooth/screens/connected_page.dart';
import 'package:flutter/material.dart';
import 'helpers/strings.dart';
import 'screens/scanned_page.dart';

void main() {
  runApp(const BluetoothApp());
}

class BluetoothApp extends StatelessWidget {

  const BluetoothApp({Key? key}) : super(key: key);
  static const int tabLength = 3;

  @override
  Widget build(BuildContext context) => MaterialApp(
      theme: ThemeData(scaffoldBackgroundColor: const Color.fromRGBO(221, 230, 232, 1)),
      home: DefaultTabController(
        length: tabLength,
        child: Scaffold(
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
            bottom: TabBar(
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorColor: Colors.white,
              labelStyle: const TextStyle(fontWeight: FontWeight.bold),
              tabs: [
                Tab(text: Strings.scanned.toUpperCase()),
                Tab(text: Strings.connected.toUpperCase()),
                Tab(text: Strings.bonded.toUpperCase()),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              const HomePage(),
              ConnectedPage(),
              BondedPage(),
            ],
          ),
        ),
      ),
    );
  }