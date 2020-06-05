import '../models/media.dart';

class Market {
  String id;
  String name;
  Media image;
  String rate;
  String address;
  String description;
  String phone;
  String mobile;
  String information;
  double deliveryFee;
  double adminCommission;
  double defaultTax;
  String latitude;
  String longitude;
  bool closed;
  bool availableForDelivery;
  double deliveryRange;
  double distance;

  Market();

  Market.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      name = jsonMap['name'];
      image = jsonMap['media'] != null && (jsonMap['media'] as List).length > 0 ? Media.fromJSON(jsonMap['media'][0]) : new Media();
      rate = jsonMap['rate'] ?? '0';
      deliveryFee = jsonMap['delivery_fee'] != null ? jsonMap['delivery_fee'].toDouble() : 0.0;
      adminCommission = jsonMap['admin_commission'] != null ? jsonMap['admin_commission'].toDouble() : 0.0;
      deliveryRange = jsonMap['delivery_range'] != null ? jsonMap['delivery_range'].toDouble() : 0.0;
      address = jsonMap['address'];
      description = jsonMap['description'];
      phone = jsonMap['phone'];
      mobile = jsonMap['mobile'];
      defaultTax = jsonMap['default_tax'] != null ? jsonMap['default_tax'].toDouble() : 0.0;
      information = jsonMap['information'];
      latitude = jsonMap['latitude'];
      longitude = jsonMap['longitude'];
      closed = jsonMap['closed'] ?? false;
      availableForDelivery = jsonMap['available_for_delivery'] ?? false;
      distance = jsonMap['distance'] != null ? double.parse(jsonMap['distance'].toString()) : 0.0;
    } catch (e) {
      id = '';
      name = '';
      image = new Media();
      rate = '0';
      deliveryFee = 0.0;
      adminCommission = 0.0;
      deliveryRange = 0.0;
      address = '';
      description = '';
      phone = '';
      mobile = '';
      defaultTax = 0.0;
      information = '';
      latitude = '0';
      longitude = '0';
      closed = false;
      availableForDelivery = false;
      distance = 0.0;
      print(e);
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'delivery_fee': deliveryFee,
      'distance': distance,
    };
  }
}
