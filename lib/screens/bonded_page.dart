import 'package:bluetooth/screens/details_page.dart';
import 'package:bluetooth/helpers/constants.dart';
import 'package:bluetooth/helpers/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class BondedPage extends StatelessWidget {
  
  BondedPage({Key? key}) : super(key: key);
  final FlutterBlue bluetooth = FlutterBlue.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: RefreshIndicator(
          triggerMode: RefreshIndicatorTriggerMode.anywhere,
          onRefresh: () => bluetooth.bondedDevices
              .timeout(const Duration(seconds: Constants.timeout)),
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            controller: ScrollController(),
            children: <Widget>[
              fetchDevices(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget tileList(BuildContext context, BluetoothDevice device) => ListTile(
    title: Text(device.name),
    subtitle: Text(device.id.toString()),
    trailing: StreamBuilder<BluetoothDeviceState>(
      stream: device.state,
      initialData: BluetoothDeviceState.disconnected,
      builder: (c, snapshot) {
        if (snapshot.data == BluetoothDeviceState.connected) {
          return ElevatedButton(
            child: Text(Strings.connect.toUpperCase()),
            style: ElevatedButton.styleFrom(
              primary: Colors.black,
              onPrimary: Colors.white,
            ),
            onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) =>
                    DetailsPage(device: device))),
          );
        }
        return ElevatedButton(
          child: Text(Strings.connect.toUpperCase()),
          style: ElevatedButton.styleFrom(
            primary: Colors.black,
            onPrimary: Colors.white,
          ),
          onPressed: null
        );
      },
    ),
  );

  FutureBuilder<List<BluetoothDevice>> fetchDevices(BuildContext context) {
    return FutureBuilder(
      future: bluetooth.bondedDevices,
      initialData: const [],
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return const Text('Error');
          } else if (snapshot.hasData) {
            List<BluetoothDevice> deviceList = snapshot.data ?? [];
            return Column(
              children: deviceList.map((e) => Card(
                child: tileList(context, e),
              )).toList(),
            );
          } else {
            return const Text('Empty data');
          }
        } else {
          return Text('State: ${snapshot.connectionState}');
        }
      });
  }
}
