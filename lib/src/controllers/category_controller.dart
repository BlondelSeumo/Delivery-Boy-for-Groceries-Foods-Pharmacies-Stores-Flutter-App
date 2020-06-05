import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/i18n.dart';
import '../models/cart.dart';
import '../models/category.dart';
import '../models/product.dart';
import '../repository/cart_repository.dart';
import '../repository/category_repository.dart';
import '../repository/product_repository.dart';

class CategoryController extends ControllerMVC {
  List<Product> products = <Product>[];
  GlobalKey<ScaffoldState> scaffoldKey;
  Category category;
  bool loadCart = false;
  Cart cart;

  CategoryController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }

  void listenForProductsByCategory({String id, String message}) async {
    final Stream<Product> stream = await getProductsByCategory(id);
    stream.listen((Product _product) {
      setState(() {
        products.add(_product);
      });
    }, onError: (a) {
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text(S.current.verify_your_internet_connection),
      ));
    }, onDone: () {
      if (message != null) {
        scaffoldKey?.currentState?.showSnackBar(SnackBar(
          content: Text(message),
        ));
      }
    });
  }

  void listenForCategory({String id, String message}) async {
    final Stream<Category> stream = await getCategory(id);
    stream.listen((Category _category) {
      setState(() => category = _category);
    }, onError: (a) {
      print(a);
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text(S.current.verify_your_internet_connection),
      ));
    }, onDone: () {
      if (message != null) {
        scaffoldKey?.currentState?.showSnackBar(SnackBar(
          content: Text(message),
        ));
      }
    });
  }

  void listenForCart() async {
    final Stream<Cart> stream = await getCart();
    stream.listen((Cart _cart) {
      cart = _cart;
    });
  }

  bool isSameMarkets(Product product) {
    if (cart != null) {
      return cart.product?.market?.id == product.market.id;
    }
    return true;
  }

  void addToCart(Product product, {bool reset = false}) async {
    setState(() {
      this.loadCart = true;
    });
    var _cart = new Cart();
    _cart.product = product;
    _cart.options = [];
    _cart.quantity = 1;
    addCart(_cart, reset).then((value) {
      setState(() {
        this.loadCart = false;
      });
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text('This product was added to cart'),
      ));
    });
  }

  Future<void> refreshCategory() async {
    products.clear();
    category = new Category();
    listenForProductsByCategory(message: S.current.category_refreshed_successfuly);
    listenForCategory(message: S.current.category_refreshed_successfuly);
  }
}
