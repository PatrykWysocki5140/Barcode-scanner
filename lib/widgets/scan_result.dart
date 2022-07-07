import 'package:flutter/material.dart';

import '../pages/scanner.dart';

class ScanResult extends StatelessWidget {
  final String result;
  const ScanResult({required this.result});

  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Scan result'),
        ),
        body: Container(
            alignment: Alignment.center,
            child: Flex(
                direction: Axis.vertical,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text("Result: $result"),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ElevatedButton(
                              onPressed: () => scanBarcodeNormal(),
                              child: const Text('Save')),
                          ElevatedButton(
                              onPressed: () => {Navigator.pop(context)},
                              child: const Text('Delete')),
                        ],
                      ),
                    ],
                  )
                ])));
  }
}
