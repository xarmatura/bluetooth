import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

import 'char_item.dart';

class ServiceItem extends StatelessWidget {
  final BluetoothService service;
  final List<CharItem> characteristicTiles;

  const ServiceItem(
      {Key? key, required this.service, required this.characteristicTiles})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (characteristicTiles.isNotEmpty) {
      return ExpansionTile(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text('Service'),
            Text('0x${service.uuid.toString().toUpperCase().substring(4, 8)}',
                style: Theme.of(context).textTheme.bodyText1?.copyWith(
                    color: Theme.of(context).textTheme.caption?.color))
          ],
        ),
        children: characteristicTiles,
      );
    } else {
      return ListTile(
        title: const Text('Service'),
        subtitle:
        Text('0x${service.uuid.toString().toUpperCase().substring(4, 8)}'),
      );
    }
  }
}