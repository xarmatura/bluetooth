import 'dart:math';
import 'dart:typed_data';

import 'package:bluetooth/helpers/strings.dart';
import 'package:bluetooth/items/char_item.dart';
import 'package:bluetooth/items/desc_item.dart';
import 'package:bluetooth/items/service_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:synchronized/synchronized.dart';

class DetailsPage extends StatelessWidget {
  DetailsPage({Key? key, required this.device}) : super(key: key);

  final BluetoothDevice device;

  List<int> _getRandomBytes() {
    final math = Random();
    return [
      math.nextInt(255),
      math.nextInt(255),
      math.nextInt(255),
      math.nextInt(255)
    ];
  }

  final byteList = Uint8List(18);
  final List<int> readList = [37, 70, 0, 8, 170, 128, 0, 158, 0, 33, 70, 0, 8, 192, 128, 0, 6, 2];

  List<Widget> services(BuildContext context, List<BluetoothService> services) {
    return services.map(
      (s) => Card(
          child: ServiceItem(
            service: s,
            characteristicTiles: s.characteristics.map(
                  (c) => CharItem(
                    characteristic: c,
                    onReadPressed: () => c.read(),
                    onWritePressed: () async {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              actions: <Widget>[
                                TextButton(
                                    onPressed: () async {
                                      await c.write(byteList, withoutResponse: true);
                                    },
                                    child: const Text(Strings.switchOff)),
                                TextButton(
                                  onPressed: () async {
                                    await c.write(readList, withoutResponse: true);
                                  },
                                  child: const Text(Strings.switchOn),
                                )
                              ],
                            );
                          });
                    },
                    onNotificationPressed: () async {
                      var lock = Lock();
                      await lock.synchronized(() async {
                        await c.setNotifyValue(!c.isNotifying);
                        await c.read();
                        },
                      );
                    },
                    descriptorTiles: c.descriptors.map(
                          (d) => DescItem(
                            descriptor: d,
                            onReadPressed: () => d.read(),
                            onWritePressed: () => d.write(_getRandomBytes()),
                          ),
                    ).toList(),
                  ),
            ).toList(),
          ),
      ),
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(device.id.id),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[Colors.cyan, Colors.indigo]),
          ),
        ),
        actions: <Widget>[
          StreamBuilder<BluetoothDeviceState>(
            stream: device.state,
            initialData: BluetoothDeviceState.connecting,
            builder: (c, snapshot) {
              VoidCallback? onPressed;
              String text;
              switch (snapshot.data) {
                case BluetoothDeviceState.connected:
                  onPressed = () => device.disconnect();
                  text = 'DISCONNECT';
                  break;
                case BluetoothDeviceState.disconnected:
                  onPressed = () => device.connect();
                  text = 'CONNECT';
                  break;
                default:
                  onPressed = null;
                  text = snapshot.data.toString().substring(21).toUpperCase();
                  break;
              }
              return TextButton(
                onPressed: onPressed,
                child: Text(text, style: Theme.of(context).primaryTextTheme
                      .button?.copyWith(color: Colors.white)
                ),
              );
            },
          )
        ],
      ),
      body: StreamBuilder<List<BluetoothService>>(
        stream: device.services,
        initialData: const [],
        builder: (c, snapshot) {
          return Column(
            children: services(context, snapshot.data ?? []),
          );
        }
      ),
    );
  }


  Widget connectBLE() => FutureBuilder(
    future: device.connect(),
    builder: (context, snapshot) {
      switch(snapshot.connectionState) {
        case ConnectionState.none:
        case ConnectionState.waiting:
          return Container();
        case ConnectionState.active:
        case ConnectionState.done:
          return discoverBLE();
      }
    },
  );

  Widget discoverBLE() => FutureBuilder<List<BluetoothService>>(
    future: device.discoverServices(),
    builder: (context, snapshot) {
      switch(snapshot.connectionState) {
        case ConnectionState.none:
        case ConnectionState.waiting:
          return Container();
        case ConnectionState.active:
        case ConnectionState.done: {
          List<BluetoothService> services = snapshot.data ?? [];
          return merge(batteryBLE(services), versionSoftware(services));
        }
      }
    },
  );


  BluetoothCharacteristic batteryBLE(List<BluetoothService> services) {
    var batteryService = services.map((e) => e.characteristics.last);
    return batteryService.first;
  }

  BluetoothCharacteristic versionSoftware(List<BluetoothService> services) {
    var versionService = services.map((e) => e.characteristics.last);
    return versionService.first;
  }

  Widget readValue(BluetoothCharacteristic characteristic) => FutureBuilder<List<int>>(
    future: characteristic.read(),
    builder: (context, snapshot) {
      switch (snapshot.connectionState) {
        case ConnectionState.none:
        case ConnectionState.waiting:
          return Container();
        case ConnectionState.active:
        case ConnectionState.done: {
          return Text(snapshot.data.toString());
        }
      }
    }
  );

  Widget merge(BluetoothCharacteristic battery, BluetoothCharacteristic version) => Column(
    children: <Widget>[
      readValue(battery),
      readValue(version),
    ],
  );
}
