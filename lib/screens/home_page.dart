import 'package:bluetooth/helpers/utils.dart';
import 'package:bluetooth/managers/snack_bar_manager.dart';
import 'package:bluetooth/tiles/device_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:bluetooth/blue_screen.dart';

class HomePage extends StatefulWidget {

  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final FlutterBlue bluetooth = FlutterBlue.instance;
  final Duration timeout = const Duration(seconds: 4);
  final GlobalKey<ScaffoldMessengerState> key = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      body: StreamBuilder<BluetoothState>(
        stream: bluetooth.state,
        initialData: BluetoothState.unknown,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data == BluetoothState.off) {
            return Container(); // Need relative snack bar
          }
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  connectedDevices(),
                  scannedDevices(),
                ],
              ),
            ),
          );
        }),
      floatingActionButton: scanDevices(),
    );
  }

  StreamBuilder<bool> scanDevices() {
    return StreamBuilder<bool>(
      stream: bluetooth.isScanning,
      initialData: false,
      builder: (c, snapshot) {
        if (snapshot.data!) {
          return FloatingActionButton(
            elevation: 0,
            child: const Icon(Icons.stop),
            onPressed: () => bluetooth.stopScan(),
            backgroundColor: Colors.red,
          );
        } else {
          return FloatingActionButton(
              backgroundColor: Colors.black,
              child: const Icon(Icons.search), // need handle
              onPressed: () => bluetooth.startScan(timeout: timeout).whenComplete(() =>
                  SnackBarManager.showErrorSnackBar(context)).onError((error, stackTrace) => SnackBarManager.showErrorSnackBar(context)));
        }
      },
    );
  }

  StreamBuilder<List<ScanResult>> scannedDevices() {
    return StreamBuilder<List<ScanResult>>(
      stream: bluetooth.scanResults,
      initialData: const [],
      builder: (c, snapshot) => Column(
          children: snapshot.hasData ? snapshot.data!
              .map((result) => ItemDevice(
            result: result,
            onTap: () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) {
              result.device.connect().whenComplete(() => {

              });
              return DeviceScreen(device: result.device);
            })),
          ),
          ).toList() : []
      ),
    );
  }

  StreamBuilder<List<BluetoothDevice>> connectedDevices () {
    return StreamBuilder<List<BluetoothDevice>>(
      stream: Stream.periodic(const Duration(seconds: 2))
          .asyncMap((_) => bluetooth.connectedDevices),
      initialData: const [],
      builder: (c, snapshot) => Column(
        children: snapshot.data!.map((d) => ListTile(
          title: Text(d.name),
          subtitle: Text(d.id.toString()),
          trailing: StreamBuilder<BluetoothDeviceState>(
            stream: d.state,
            initialData: BluetoothDeviceState.disconnected,
            builder: (c, snapshot) {
              if (snapshot.data == BluetoothDeviceState.connected) {
                return ElevatedButton(
                  child: Text(Strings.open.toUpperCase()),
                  onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) =>
                              DeviceScreen(device: d))),
                );
              }
              return Text(snapshot.data.toString());
            },
          ),
        )).toList(),
      ),
    );
  }
}
