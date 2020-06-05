import '../models/category.dart';
import '../models/market.dart';
import '../models/media.dart';
import '../models/option.dart';
import '../models/option_group.dart';
import '../models/review.dart';

class Product {
  String id;
  String name;
  double price;
  double discountPrice;
  Media image;
  String description;
  String ingredients;
  String capacity;
  String unit;
  String packageItemsCount;
  bool featured;
  bool deliverable;
  Market market;
  Category category;
  List<Option> options;
  List<OptionGroup> optionGroups;
  List<Review> productReviews;

  Product();

  Product.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      name = jsonMap['name'];
      price = jsonMap['price'] != null ? jsonMap['price'].toDouble() : 0.0;
      discountPrice = jsonMap['discount_price'] != null ? jsonMap['discount_price'].toDouble() : 0.0;
      price = discountPrice != 0 ? discountPrice : price;
      discountPrice = discountPrice == 0 ? discountPrice : jsonMap['price'] != null ? jsonMap['price'].toDouble() : 0.0;
      description = jsonMap['description'];
      capacity = jsonMap['capacity'].toString();
      unit = jsonMap['unit'].toString();
      packageItemsCount = jsonMap['package_items_count'].toString();
      featured = jsonMap['featured'] ?? false;
      deliverable = jsonMap['deliverable'] ?? false;
      market = jsonMap['market'] != null ? Market.fromJSON(jsonMap['market']) : new Market();
      category = jsonMap['category'] != null ? Category.fromJSON(jsonMap['category']) : new Category();
      image = jsonMap['media'] != null && (jsonMap['media'] as List).length > 0 ? Media.fromJSON(jsonMap['media'][0]) : new Media();
      options = jsonMap['options'] != null && (jsonMap['options'] as List).length > 0
          ? List.from(jsonMap['options']).map((element) => Option.fromJSON(element)).toList()
          : [];
      optionGroups = jsonMap['option_groups'] != null && (jsonMap['option_groups'] as List).length > 0
          ? List.from(jsonMap['option_groups']).map((element) => OptionGroup.fromJSON(element)).toList()
          : [];
      productReviews = jsonMap['product_reviews'] != null && (jsonMap['product_reviews'] as List).length > 0
          ? List.from(jsonMap['product_reviews']).map((element) => Review.fromJSON(element)).toList()
          : [];
    } catch (e) {
      id = '';
      name = '';
      price = 0.0;
      discountPrice = 0.0;
      description = '';
      capacity = '';
      unit = '';
      packageItemsCount = '';
      featured = false;
      deliverable = false;
      market = new Market();
      category = new Category();
      image = new Media();
      options = [];
      optionGroups = [];
      productReviews = [];
      print(jsonMap);
    }
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["name"] = name;
    map["price"] = price;
    map["discountPrice"] = discountPrice;
    map["description"] = description;
    map["capacity"] = capacity;
    map["package_items_count"] = packageItemsCount;
    return map;
  }

  @override
  bool operator ==(dynamic other) {
    return other.id == this.id;
  }

  @override
  int get hashCode => super.hashCode;
}
