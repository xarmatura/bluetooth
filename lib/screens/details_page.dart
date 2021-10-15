import 'dart:typed_data';

import 'package:bluetooth/helpers/strings.dart';
import 'package:bluetooth/items/char_item.dart';
import 'package:bluetooth/items/desc_item.dart';
import 'package:bluetooth/items/service_item.dart';
import 'package:bluetooth/widgets/wave_progress.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:synchronized/synchronized.dart';

class DetailsPage extends StatelessWidget {
  DetailsPage({Key? key, required this.device}) : super(key: key);

  final BluetoothDevice device;
  final emptyByteList = Uint8List(18);
  final List<int> turnOnList = [
    37, 70, 0,
    8, 170, 128, 0, 158, 0,
    33, 70, 0, 8, 192,
    128, 0, 6, 2
  ];

  BluetoothCharacteristic services(BuildContext context, List<BluetoothService> services) {

    final list = services.map((e) => e.characteristics.last).toList();
    return list.first;
    // return services
    //     .map(
    //       (s) => Card(
    //         child: ServiceItem(
    //           service: s,
    //           characteristicTiles: s.characteristics
    //               .map(
    //                 (c) => CharItem(
    //                   characteristic: c,
    //                   onReadPressed: () => c.read(),
    //                   onWritePressed: () async {
    //                     showDialog(
    //                         context: context,
    //                         builder: (context) {
    //                           return AlertDialog(
    //                             actions: <Widget>[
    //                               TextButton(
    //                                   onPressed: () async {
    //                                     await c.write(emptyByteList,
    //                                         withoutResponse: true);
    //                                   },
    //                                   child: const Text(Strings.switchOff)),
    //                               TextButton(
    //                                 onPressed: () async {
    //                                   await c.write(turnOnList,
    //                                       withoutResponse: true);
    //                                 },
    //                                 child: const Text(Strings.switchOn),
    //                               )
    //                             ],
    //                           );
    //                         });
    //                   },
    //                   onNotificationPressed: () async {
    //                     var lock = Lock();
    //                     await lock.synchronized(
    //                       () async {
    //                         await c.setNotifyValue(!c.isNotifying);
    //                         await c.read();
    //                       },
    //                     );
    //                   },
    //                   descriptorTiles: c.descriptors
    //                       .map(
    //                         (d) => DescItem(
    //                             descriptor: d,
    //                             onReadPressed: () => d.read(),
    //                             onWritePressed: () {}),
    //                       )
    //                       .toList(),
    //                 ),
    //               )
    //               .toList(),
    //         ),
    //       ),
    //     )
    //     .toList();
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
            initialData: BluetoothDeviceState.disconnected,
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
                case BluetoothDeviceState.connecting:
                  onPressed = null;
                  text = '';
                  break;
                default:
                  onPressed = null;
                  text = snapshot.data.toString().substring(21).toUpperCase();
                  break;
              }
              return TextButton(
                onPressed: onPressed,
                child: Text(
                  text,
                  style: Theme.of(context)
                      .primaryTextTheme
                      .button
                      ?.copyWith(color: Colors.white),
                ),
              );
            },
          )
        ],
      ),
      body: FutureBuilder(
        future: device.connect(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return const Center(child: CircularProgressIndicator());
            case ConnectionState.active:
            case ConnectionState.done:
              return Column(
                children: <Widget>[
                  FutureBuilder(
                      future: device.discoverServices(),
                      builder: (_, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.none:
                          case ConnectionState.waiting:
                            return const Center(
                                child: CircularProgressIndicator());
                          case ConnectionState.active:
                          case ConnectionState.done:
                            return StreamBuilder<List<BluetoothService>>(
                              stream: device.services,
                              initialData: const [],
                              builder: (c, snapshot) {
                                return Column(
                                  children: <Widget>[
                                    Container(
                                      alignment: Alignment.center,
                                      padding:
                                          const EdgeInsets.only(top: 20.0),
                                      child: const WaveProgress(
                                          size: 180.0,
                                          borderColor: Colors.indigo,
                                          fillColor: Colors.indigo,
                                          progress: 20)),
                                    FutureBuilder(
                                      future: services(_, snapshot.data!).read(),
                                      builder: (_, snapshot) {
                                        switch (snapshot.connectionState) {
                                          case ConnectionState.none:
                                          case ConnectionState.waiting:
                                            return const Center(child: CircularProgressIndicator());
                                          case ConnectionState.active:
                                            return const Center(child: CircularProgressIndicator());
                                          case ConnectionState.done:
                                            return Text(snapshot.data.toString());
                                        }
                                      }),
                                  ],
                                );
                              },
                            );
                        }
                      })
                ],
              );
          }
        },
      ),
    );
  }
}
