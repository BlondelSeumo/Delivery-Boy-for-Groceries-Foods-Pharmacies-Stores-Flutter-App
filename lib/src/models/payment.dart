class Payment {
  String id;
  String status;
  String method;

  Payment.init();

  Payment(this.method);

  Payment.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      status = jsonMap['status'] ?? '';
      method = jsonMap['method'] ?? '';
    } catch (e) {
      id = '';
      status = '';
      method = '';
      print(e);
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'status': status,
      'method': method,
    };
  }
}
