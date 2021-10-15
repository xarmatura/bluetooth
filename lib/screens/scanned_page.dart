import 'package:bluetooth/helpers/constants.dart';
import 'package:bluetooth/widgets/gradient_icon.dart';
import 'package:bluetooth/helpers/strings.dart';
import 'package:bluetooth/items/device_item.dart';
import 'package:collection/src/iterable_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:bluetooth/screens/details_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FlutterBlue bluetooth = FlutterBlue.instance;
  final Duration timeout = const Duration(seconds: Constants.timeout);
  final GlobalKey<ScaffoldMessengerState> key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      body: StreamBuilder<BluetoothState>(
          stream: bluetooth.state,
          initialData: BluetoothState.unknown, // TODO save state to pref
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data == BluetoothState.off) {
              return Center(child: themedIcon()); // TODO Need relative snack bar
            }
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: RefreshIndicator(
                onRefresh: () => bluetooth.startScan(
                    timeout: const Duration(seconds: Constants.timeout)) ,
                child: fetchDevice(),
              ),
            );
          }),
      floatingActionButton: scanDevices(),
    );
  }

  Widget themedIcon() => GradientIcon(Icons.bluetooth_disabled_outlined, 72, themedGradient());

  LinearGradient themedGradient() => const LinearGradient(
      tileMode: TileMode.decal,
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: <Color>[Colors.cyan, Colors.indigo]);

  FloatingActionButton fab(
          {IconData? icon,
          required Color background,
          required Function() function}) =>
      FloatingActionButton(
        child: icon == null ? Text(Strings.scan.toUpperCase()) : Icon(icon),
        backgroundColor: background,
        onPressed: () => function,
      );

  StreamBuilder<bool> scanDevices() {
    return StreamBuilder<bool>(
      stream: bluetooth.isScanning,
      initialData: false,
      builder: (context, snapshot) {
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
              child: Text(Strings.scan.toUpperCase()), // need handle
              onPressed: () => bluetooth.startScan(
                  timeout: const Duration(seconds: Constants.timeout))
          );
        }
      },
    );
  }

  StreamBuilder<List<ScanResult>> fetchDevice() {
    return StreamBuilder<List<ScanResult>>(
      stream: bluetooth.scanResults,
      initialData: const [],
      builder: (c, snapshot) {
        List<ScanResult> list = snapshot.data ?? [];
        ScanResult? device = list.firstWhereOrNull((element) =>
        element.device.name == 'Doppel');
        if (device != null) {
          return Column(
            children: <Widget>[
              DeviceItem(
                result: device,
                onTap: () =>
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return DetailsPage(device: device.device);
                        },
                      ),
                    ),
              ),
            ],
          );
        }
        return const Align(
          alignment: Alignment.center,
          child: Text('Device not found',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 42),
            textAlign: TextAlign.center,
          ),
        );
      }
    );
  }
}
