class CreditCard {
  String id;
  String number = '';
  String expMonth = '';
  String expYear = '';
  String cvc = '';

  CreditCard();

  CreditCard.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      number = jsonMap['stripe_number'].toString();
      expMonth = jsonMap['stripe_exp_month'].toString();
      expYear = jsonMap['stripe_exp_year'].toString();
      cvc = jsonMap['stripe_cvc'].toString();
    } catch (e) {
      id = '';
      number = '';
      expMonth = '';
      expYear = '';
      cvc = '';
      print(e);
    }
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["stripe_number"] = number;
    map["stripe_exp_month"] = expMonth;
    map["stripe_exp_year"] = expYear;
    map["stripe_cvc"] = cvc;
    return map;
  }

  bool validated() {
    return number != null && number != '' && expMonth != null && expMonth != '' && expYear != null && expYear != '' && cvc != null && cvc != '';
  }
}
