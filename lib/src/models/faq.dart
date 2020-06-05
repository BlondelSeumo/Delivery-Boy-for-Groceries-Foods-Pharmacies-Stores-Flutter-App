class Faq {
  String id;
  String question;
  String answer;

  Faq();

  Faq.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      question = jsonMap['question'] != null ? jsonMap['question'] : '';
      answer = jsonMap['answer'] != null ? jsonMap['answer'] : '';
    } catch (e) {
      id = '';
      question = '';
      answer = '';
      print(e);
    }
  }
}
