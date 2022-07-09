import 'package:barcode/models/scan_items_model.dart'; //ScanItems Class
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; //PlatformException
import 'package:intl/intl.dart'; //DateFormat
import 'package:localstorage/localstorage.dart'; //LocalStorage
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart'; //FlutterBarcodeScanner

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'barcode scanner';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: _title,
      home: MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({
    super.key,
  });

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  final ScanItemsList list = ScanItemsList();
  final LocalStorage storage = LocalStorage('barcode');
  TextEditingController controller = TextEditingController();
  bool initialized = false;

  _toggleItem(ScanItems item) {
    setState(() {
      item.checked = !item.checked;
      _saveToStorage();
    });
  }

  _saveToStorage() {
    storage.setItem('items', list.toJSONEncodable());
  }

  _addItem(String value) {
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('dd-MM-yyyy');
    String formatted = formatter.format(now);

    setState(() {
      final item =
          ScanItems(scanValue: (value), date: ("($formatted)"), checked: false);
      list.items.add(item);
      _saveToStorage();
    });
  }

  _deleteItem() {
    var toRemove = [];

    setState(() {
      for (var e in list.items) {
        if (e.checked == true) {
          toRemove.add(e);
        }
      }

      list.items.removeWhere((e) => toRemove.contains(e));
      _saveToStorage();
    });
  }

  _clearStorage() async {
    await storage.clear();

    setState(() {
      list.items = storage.getItem('items') ?? [];
    });
  }

  Future<void> _scanBarcodeNormal() async {
    String barcodeScanRes;

    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    if (!mounted) return;

    setState(() {
      if (barcodeScanRes != "-1") {
        controller.text = barcodeScanRes;
      }
    });
  }

  void _scanBarcodeDelete() async {
    setState(() {
      controller.text = "";
    });
  }

  void _scanBarcodeSave() {
    if (controller.value.text != "") {
      _addItem(controller.value.text);
      controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 25, 14, 177),
        title: const Text('Created By Patryk Wysocki'),
      ),
      body: Container(
          padding: const EdgeInsets.all(10.0),
          constraints: const BoxConstraints.expand(),
          child: FutureBuilder(
            future: storage.ready,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (!initialized) {
                var items = storage.getItem('items');

                if (items != null) {
                  list.items = List<ScanItems>.from(
                    (items as List).map(
                      (item) => ScanItems(
                        scanValue: item['scanValue'],
                        date: item['date'],
                        checked: item['checked'],
                      ),
                    ),
                  );
                }

                initialized = true;
              }

              List<Widget> scanItemsList = list.items.map((item) {
                return CheckboxListTile(
                  value: item.checked,
                  title: Text("${item.scanValue} ${item.date}"),
                  selected: item.checked,
                  onChanged: (_) {
                    _toggleItem(item);
                  },
                );
              }).toList();

              return Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: const Color.fromARGB(255, 25, 14, 177),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50))),
                          onPressed: () => _deleteItem(),
                          child: const Text('Delete selected')),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: const Color.fromARGB(255, 25, 14, 177),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50))),
                          onPressed: () => _clearStorage(),
                          child: const Text('Delete all')),
                    ],
                  ),
                  Expanded(
                    flex: 1,
                    child: ListView(
                      itemExtent: 50.0,
                      children: scanItemsList,
                    ),
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: const Color.fromARGB(255, 25, 14, 177),
                          fixedSize: const Size(200, 50),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50))),
                      onPressed: () => _scanBarcodeNormal(),
                      child: const Text('Scan')),
                  ListTile(
                    title: TextField(
                      enabled: false,
                      controller: controller,
                      decoration: const InputDecoration(
                        labelText: 'Result',
                      ),
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      IconButton(
                        color: const Color.fromARGB(255, 25, 14, 177),
                        icon: const Icon(Icons.save),
                        onPressed: _scanBarcodeSave,
                        tooltip: 'Save',
                      ),
                      IconButton(
                        color: const Color.fromARGB(255, 25, 14, 177),
                        icon: const Icon(Icons.delete),
                        onPressed: _scanBarcodeDelete,
                        tooltip: 'Delete',
                      )
                    ],
                  ),
                ],
              );
            },
          )),
    );
  }
}
