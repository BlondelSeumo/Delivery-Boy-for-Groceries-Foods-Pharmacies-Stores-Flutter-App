import '../models/option.dart';
import '../models/product.dart';

class ProductOrder {
  String id;
  double price;
  double quantity;
  List<Option> options;
  Product product;
  DateTime dateTime;

  ProductOrder();

  ProductOrder.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      price = jsonMap['price'] != null ? jsonMap['price'].toDouble() : 0.0;
      quantity = jsonMap['quantity'] != null ? jsonMap['quantity'].toDouble() : 0.0;
      product = jsonMap['product'] != null ? Product.fromJSON(jsonMap['product']) : [];
      dateTime = DateTime.parse(jsonMap['updated_at']);
      options = jsonMap['options'] != null ? List.from(jsonMap['options']).map((element) => Option.fromJSON(element)).toList() : null;
    } catch (e) {
      id = '';
      price = 0.0;
      quantity = 0.0;
      product = new Product();
      dateTime = DateTime(0);
      options = [];
      print(e);
    }
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["price"] = price;
    map["quantity"] = quantity;
    map["product_id"] = product.id;
    map["options"] = options.map((element) => element.id).toList();
    return map;
  }
}
