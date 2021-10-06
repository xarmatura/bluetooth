import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'managers/snack_bar_manager.dart';
import 'screens/list_screen.dart';

void main() {
  runApp(Engine());
}

class Engine extends StatelessWidget {
  Engine({Key? key}) : super(key: key);
  final _messangerKey = GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: _messangerKey,
      home: Scaffold(
        appBar: AppBar(
          title: Text(
              'Bluetooth Tester'), // TODO(xarmat) implement states which based on scaffold
          centerTitle: true,
          actions: <Widget>[
            StreamBuilder<bool>(
              stream: FlutterBlue.instance.isScanning,
              initialData: false,
              builder: (context, snapshot) {
                if (snapshot.data!) {
                  return IconButton(
                    icon: Container(child: Icon(Icons.stop)),
                      onPressed: () => FlutterBlue.instance.stopScan()
                  );
                } else {
                  return IconButton(
                      icon: Container(child: Icon(Icons.search)),
                      onPressed: () => FlutterBlue.instance
                          .startScan(timeout: const Duration(seconds: 4))
                          .onError((error, stackTrace) => SnackBarManager.showSnackBar(stackTrace.toString(), _messangerKey, Colors.red))
                  );
                }
              },
            ),
          ],
        ),
        body: ItemList(),
      ),
    );
  }
}
