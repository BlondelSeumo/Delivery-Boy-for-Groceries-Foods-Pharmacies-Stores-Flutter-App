import '../models/media.dart';

class Option {
  String id;
  String optionGroupId;
  String name;
  double price;
  Media image;
  String description;
  bool checked;

  Option();

  Option.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      optionGroupId = jsonMap['option_group_id'] != null ? jsonMap['option_group_id'].toString() : '0';
      name = jsonMap['name'].toString();
      price = jsonMap['price'] != null ? jsonMap['price'].toDouble() : 0;
      description = jsonMap['description'];
      checked = false;
      image = jsonMap['media'] != null && (jsonMap['media'] as List).length > 0 ? Media.fromJSON(jsonMap['media'][0]) : new Media();
    } catch (e) {
      id = '';
      optionGroupId = '0';
      name = '';
      price = 0.0;
      description = '';
      checked = false;
      image = new Media();
      print(e);
    }
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["name"] = name;
    map["price"] = price;
    map["description"] = description;
    return map;
  }

  @override
  bool operator ==(dynamic other) {
    return other.id == this.id;
  }

  @override
  int get hashCode => super.hashCode;
}
