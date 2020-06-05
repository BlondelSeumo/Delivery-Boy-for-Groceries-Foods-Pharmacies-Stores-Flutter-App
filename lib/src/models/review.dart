import '../models/market.dart';
import '../models/product.dart';
import '../models/user.dart';

class Review {
  String id;
  String review;
  String rate;
  User user;

  Review();

  Review.init(this.rate);

  Review.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      review = jsonMap['review'];
      rate = jsonMap['rate'].toString() ?? '0';
      user = jsonMap['user'] != null ? User.fromJSON(jsonMap['user']) : new User();
    } catch (e) {
      id = '';
      review = '';
      rate = '0';
      user = new User();
      print(e);
    }
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["review"] = review;
    map["rate"] = rate;
    map["user_id"] = user?.id;
    return map;
  }

  @override
  String toString() {
    return this.toMap().toString();
  }

  Map ofMarketToMap(Market market) {
    var map = this.toMap();
    map["market_id"] = market.id;
    return map;
  }

  Map ofProductToMap(Product product) {
    var map = this.toMap();
    map["product_id"] = product.id;
    return map;
  }
}
