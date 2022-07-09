class ScanItems {
  String scanValue;
  String date;
  bool checked;

  ScanItems(
      {required this.scanValue, required this.date, required this.checked});

  toJSONEncodable() {
    Map<String, dynamic> obj = {};

    obj['scanValue'] = scanValue;
    obj['date'] = date;
    obj['checked'] = checked;

    return obj;
  }
}

class ScanItemsList {
  List<ScanItems> items = [];

  toJSONEncodable() {
    return items.map((item) {
      return item.toJSONEncodable();
    }).toList();
  }
}


/*
class TodoItem {
  String title;
  bool done;

  TodoItem({required this.title, required this.done});

  toJSONEncodable() {
    Map<String, dynamic> m = new Map();

    m['title'] = title;
    m['done'] = done;

    return m;
  }
}

class TodoList {
  List<TodoItem> items = [];

  toJSONEncodable() {
    return items.map((item) {
      return item.toJSONEncodable();
    }).toList();
  }
}
*/