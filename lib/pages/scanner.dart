import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import '../widgets/scan_result.dart';

class Scanner extends StatefulWidget {
  const Scanner({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ScannerState createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> {
  String _scanBarcode = 'Unknown';

  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;

    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ScanResult(
                result: _scanBarcode,
              )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        child: Flex(
            direction: Axis.vertical,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                  onPressed: () => scanBarcodeNormal(),
                  child: const Text('Scan')),
            ]));
  }
}
