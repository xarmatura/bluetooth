import 'package:bluetooth/helpers/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class DeviceItem extends StatelessWidget {

  final ScanResult result;
  final VoidCallback? onTap;
  const DeviceItem({Key? key, required this.result, this.onTap})
      : super(key: key);

  Widget deviceName(BuildContext context) => Text(
    result.device.name.isEmpty ? Strings.empty : result.device.name.toString(), // TODO Check emptiness
    style: Theme.of(context).textTheme.bodyText1,
  );

  Widget deviceIdentificator(BuildContext context) => Text(
    result.device.id.id.isEmpty ? Strings.empty : result.device.id.id.toString(),
    style: Theme.of(context).textTheme.bodyText2,
  );

  Widget deviceRssi(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      const Icon(Icons.signal_cellular_alt),
      Text(result.rssi.isNaN ? Strings.empty : result.rssi.toString() + ' dBm',
        style: Theme.of(context).textTheme.bodyText2)
    ]
  );

  Widget deviceTrailing() {
    return ElevatedButton(
      child: Text(Strings.connect.toUpperCase()),
      style: ElevatedButton.styleFrom(
        primary: Colors.black,
        onPrimary: Colors.white,
      ),
      onPressed: result.advertisementData.connectable ? onTap : null,
    );
  }

  Widget deviceCard(BuildContext context, String title, String? value) {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(title + ':', style: Theme.of(context).textTheme.bodyText1),
            Expanded(
              child: Text(
                value ?? 'N/A',
                style: Theme.of(context).textTheme
                    .bodyText2?.apply(color: Colors.grey), // TODO justify or m8 or remove card
                softWrap: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getNiceHexArray(List<int> bytes) {
    return '[${bytes.map((i) => i.toRadixString(16).padLeft(2, '0')).join(', ')}]'
        .toUpperCase();
  }

  String getNiceManufacturerData(Map<int, List<int>> data) {
    if (data.isEmpty) {
      return 'N/A';
    }
    List<String> res = [];
    data.forEach((id, bytes) {
      res.add(
          '${id.toRadixString(16).toUpperCase()}: ${getNiceHexArray(bytes)}');
    });
    return res.join(', ');
  }

  String getNiceServiceData(Map<String, List<int>> data) {
    if (data.isEmpty) {
      return 'N/A';
    }
    List<String> res = [];
    data.forEach((id, bytes) {
      res.add('${id.toUpperCase()}: ${getNiceHexArray(bytes)}');
    });
    return res.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Theme(data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: deviceRssi(context),
          title: deviceName(context),
          subtitle: deviceIdentificator(context),
          trailing: deviceTrailing(),
          children: <Widget>[
            deviceCard(context,Strings.localName, result.advertisementData.localName),
            deviceCard(context,Strings.txPowerLvl,result.advertisementData.txPowerLevel.toString()),
            deviceCard(context,Strings.manufacturerData,
                getNiceManufacturerData(result.advertisementData.manufacturerData)),
            deviceCard(context,Strings.uuid,
                (result.advertisementData.serviceUuids.isNotEmpty)
                    ? result.advertisementData.serviceUuids.join(', ').toUpperCase()
                    : 'N/A'),
            deviceCard(context,Strings.service,
                getNiceServiceData(result.advertisementData.serviceData)),
          ],
        ),
      ),
    );
  }
}