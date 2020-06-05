class OptionGroup {
  String id;
  String name;

  OptionGroup();

  OptionGroup.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      name = jsonMap['name'];
    } catch (e) {
      id = '';
      name = '';
      print(e);
    }
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["name"] = name;
    return map;
  }

  @override
  String toString() {
    return this.toMap().toString();
  }
}
