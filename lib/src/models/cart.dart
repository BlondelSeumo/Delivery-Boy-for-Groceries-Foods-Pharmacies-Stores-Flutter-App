import '../models/option.dart';
import '../models/product.dart';

class Cart {
  String id;
  Product product;
  double quantity;
  List<Option> options;
  String userId;

  Cart();

  Cart.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      quantity = jsonMap['quantity'] != null ? jsonMap['quantity'].toDouble() : 0.0;
      product = jsonMap['product'] != null ? Product.fromJSON(jsonMap['product']) : new Product();
      options = jsonMap['options'] != null ? List.from(jsonMap['options']).map((element) => Option.fromJSON(element)).toList() : [];
      product.price = getProductPrice();
    } catch (e) {
      id = '';
      quantity = 0.0;
      product = new Product();
      options = [];
      print(e);
    }
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["quantity"] = quantity;
    map["product_id"] = product.id;
    map["user_id"] = userId;
    map["options"] = options.map((element) => element.id).toList();
    return map;
  }

  double getProductPrice() {
    double result = product.price;
    if (options.isNotEmpty) {
      options.forEach((Option option) {
        result += option.price != null ? option.price : 0;
      });
    }
    return result;
  }

  bool isSame(Cart cart) {
    bool _same = true;
    _same &= this.product == cart.product;
    _same &= this.options.length == cart.options.length;
    if (_same) {
      this.options.forEach((Option _option) {
        _same &= cart.options.contains(_option);
      });
    }
    return _same;
  }

  @override
  bool operator ==(dynamic other) {
    return other.id == this.id;
  }

  @override
  int get hashCode => super.hashCode;
}
