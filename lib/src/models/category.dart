import '../models/media.dart';

class Category {
  String id;
  String name;
  Media image;

  Category();

  Category.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      name = jsonMap['name'];
      image = jsonMap['media'] != null && (jsonMap['media'] as List).length > 0 ? Media.fromJSON(jsonMap['media'][0]) : new Media();
    } catch (e) {
      id = '';
      name = '';
      image = new Media();
      print(e);
    }
  }
}
