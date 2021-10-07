import 'package:flutter/material.dart';
import 'helpers/utils.dart';
import 'screens/home_page.dart';

void main() {
  runApp(const BluetoothApp());
}

class BluetoothApp extends StatelessWidget {
  const BluetoothApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            backgroundColor: Colors.black,
            title: const Text('Bluetooth Tester'),
            centerTitle: true,
            bottom: TabBar(
              tabs: [
                Tab(text: Strings.scanner.toUpperCase()),
                Tab(text: Strings.connected.toUpperCase()),
                Tab(text: Strings.bonded.toUpperCase()),
              ],
            ),
          ),
          body: const TabBarView(
            children: [
              HomePage(),
              Icon(Icons.directions_bike),
              Icon(Icons.directions_bike),
            ],
          ),
        ),
      ),
    );
  }