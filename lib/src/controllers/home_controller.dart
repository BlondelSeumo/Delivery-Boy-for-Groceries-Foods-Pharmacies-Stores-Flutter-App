import 'package:mvc_pattern/mvc_pattern.dart';

import '../models/category.dart';
import '../models/market.dart';
import '../models/product.dart';
import '../models/review.dart';
import '../repository/category_repository.dart';
import '../repository/market_repository.dart';
import '../repository/product_repository.dart';

class HomeController extends ControllerMVC {
  List<Category> categories = <Category>[];
  List<Market> topMarkets = <Market>[];
  List<Review> recentReviews = <Review>[];
  List<Product> trendingProducts = <Product>[];

  HomeController() {
    listenForCategories();
    listenForRecentReviews();
    listenForTrendingProducts();
  }

  void listenForCategories() async {
    final Stream<Category> stream = await getCategories();
    stream.listen((Category _category) {
      setState(() => categories.add(_category));
    }, onError: (a) {}, onDone: () {});
  }

  void listenForRecentReviews() async {
    final Stream<Review> stream = await getRecentReviews();
    stream.listen((Review _review) {
      setState(() => recentReviews.add(_review));
    }, onError: (a) {}, onDone: () {});
  }

  void listenForTrendingProducts() async {
    final Stream<Product> stream = await getTrendingProducts();
    stream.listen((Product _product) {
      setState(() => trendingProducts.add(_product));
    }, onError: (a) {
      print(a);
    }, onDone: () {});
  }

  Future<void> refreshHome() async {
    categories = <Category>[];
    topMarkets = <Market>[];
    recentReviews = <Review>[];
    trendingProducts = <Product>[];
    listenForCategories();
    listenForRecentReviews();
    listenForTrendingProducts();
  }
}
