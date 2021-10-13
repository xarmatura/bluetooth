import 'package:bluetooth/helpers/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class ItemDevice extends StatelessWidget {

  final ScanResult result;
  final VoidCallback? onTap;
  const ItemDevice({Key? key, required this.result, this.onTap})
      : super(key: key);

  Widget deviceName(BuildContext context) => Text(
    result.device.name.isEmpty ? Strings.empty : result.device.name.toString(),
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

  Widget _buildAdvRow(BuildContext context, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title, style: Theme.of(context).textTheme.caption),
          const SizedBox(
            width: 12.0,
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context)
                  .textTheme
                  .caption
                  ?.apply(color: Colors.black),
              softWrap: true,
            ),
          ),
        ],
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
            _buildAdvRow(
                context, 'Complete Local Name', result.advertisementData.localName),
            _buildAdvRow(context, 'Tx Power Level',
                '${result.advertisementData.txPowerLevel ?? 'N/A'}'),
            _buildAdvRow(context, 'Manufacturer Data',
                getNiceManufacturerData(result.advertisementData.manufacturerData)),
            _buildAdvRow(
                context,
                'Service UUIDs',
                (result.advertisementData.serviceUuids.isNotEmpty)
                    ? result.advertisementData.serviceUuids.join(', ').toUpperCase()
                    : 'N/A'),
            _buildAdvRow(context, 'Service Data',
                getNiceServiceData(result.advertisementData.serviceData)),
          ],
        ),
      ),
    );
  }
}