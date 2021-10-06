import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

/// Show when Bluetooth connection is empty
class ItemOff extends StatelessWidget {
  final BluetoothState state;
  const ItemOff({Key? key, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
