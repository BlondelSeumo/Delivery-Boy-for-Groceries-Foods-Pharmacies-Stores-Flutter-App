import '../models/faq.dart';

class FaqCategory {
  String id;
  String name;
  List<Faq> faqs;

  FaqCategory();

  FaqCategory.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      name = jsonMap['faqs'] != null ? jsonMap['name'].toString() : '';
      faqs = jsonMap['faqs'] != null ? List.from(jsonMap['faqs']).map((element) => Faq.fromJSON(element)).toList() : null;
    } catch (e) {
      id = '';
      name = '';
      faqs = [];
      print(e);
    }
  }
}
