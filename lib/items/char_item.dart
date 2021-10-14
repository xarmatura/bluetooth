import 'package:bluetooth/helpers/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

import 'desc_item.dart';

class CharItem extends StatelessWidget {
  final BluetoothCharacteristic characteristic;
  final List<DescItem> descriptorTiles;
  final VoidCallback? onReadPressed;
  final VoidCallback? onWritePressed;
  final VoidCallback? onNotificationPressed;

  const CharItem(
      {Key? key,
      required this.characteristic,
      required this.descriptorTiles,
      this.onReadPressed,
      this.onWritePressed,
      this.onNotificationPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<int>>(
      stream: characteristic.value,
      initialData: characteristic.lastValue,
      builder: (c, snapshot) {
        final value = snapshot.data;
        return ExpansionTile(
          title: ListTile(
            title: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text('Characteristic'),
                Text(
                    '0x${characteristic.uuid.toString().toUpperCase().substring(4, 8)}',
                    style: Theme.of(context).textTheme.bodyText1?.copyWith(
                        color: Theme.of(context).textTheme.caption?.color))
              ],
            ),
            subtitle: Text(value.toString()),
            contentPadding: const EdgeInsets.all(0.0),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: buttons(characteristic),
          ),
          children: descriptorTiles,
        );
      },
    );
  }

  List<Widget> buttons(BluetoothCharacteristic characteristic) {
    List<Widget> buttons = <Widget>[];

    if (characteristic.properties.read) {
      buttons.add(
        ElevatedButton(
          onPressed: onReadPressed,
          child: Text(Strings.read.toUpperCase()),
          style: ElevatedButton.styleFrom(
            primary: Colors.black,
            onPrimary: Colors.white,
          ),
        ),
      );
      buttons.add(const SizedBox(width: 2));
    }
    if (characteristic.properties.write) {
      buttons.add(
        ElevatedButton(
          onPressed: onWritePressed,
          child: Text(Strings.write.toUpperCase()),
          style: ElevatedButton.styleFrom(
            primary: Colors.black,
            onPrimary: Colors.white,
          ),
        ),
      );
      buttons.add(const SizedBox(width: 2));
    }
    if (characteristic.properties.notify) {
      buttons.add(
        ElevatedButton(
          onPressed: onNotificationPressed,
          child: Icon(
            characteristic.isNotifying ? Icons.sync_disabled : Icons.sync,
          ),
          style: ElevatedButton.styleFrom(
            primary: Colors.black,
            onPrimary: Colors.white,
          ),
        ),
      );
      buttons.add(const SizedBox(width: 2));
    }
    return buttons;
  }
}
