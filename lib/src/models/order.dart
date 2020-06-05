import '../models/address.dart';
import '../models/order_status.dart';
import '../models/payment.dart';
import '../models/product_order.dart';
import '../models/user.dart';

class Order {
  String id;
  List<ProductOrder> productOrders;
  OrderStatus orderStatus;
  double tax;
  double deliveryFee;
  String hint;
  DateTime dateTime;
  User user;
  Payment payment;
  Address deliveryAddress;

  Order();

  Order.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      tax = jsonMap['tax'] != null ? jsonMap['tax'].toDouble() : 0.0;
      deliveryFee = jsonMap['delivery_fee'] != null ? jsonMap['delivery_fee'].toDouble() : 0.0;
      hint = jsonMap['hint'].toString();
      orderStatus = jsonMap['order_status'] != null ? OrderStatus.fromJSON(jsonMap['order_status']) : new OrderStatus();
      dateTime = DateTime.parse(jsonMap['updated_at']);
      user = jsonMap['user'] != null ? User.fromJSON(jsonMap['user']) : new User();
      deliveryAddress = jsonMap['delivery_address'] != null ? Address.fromJSON(jsonMap['delivery_address']) : new Address();
      productOrders = jsonMap['product_orders'] != null ? List.from(jsonMap['product_orders']).map((element) => ProductOrder.fromJSON(element)).toList() : [];
    } catch (e) {
      id = '';
      tax = 0.0;
      deliveryFee = 0.0;
      hint = '';
      orderStatus = new OrderStatus();
      dateTime = DateTime(0);
      user = new User();
      deliveryAddress = new Address();
      productOrders = [];
      print(e);
    }
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["user_id"] = user?.id;
    map["order_status_id"] = orderStatus?.id;
    map["tax"] = tax;
    map["delivery_fee"] = deliveryFee;
    map["products"] = productOrders.map((element) => element.toMap()).toList();
    map["payment"] = payment?.toMap();
    map["delivery_address_id"] = deliveryAddress?.id;
    return map;
  }

  Map deliveredMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["order_status_id"] = 5;
    return map;
  }
}
