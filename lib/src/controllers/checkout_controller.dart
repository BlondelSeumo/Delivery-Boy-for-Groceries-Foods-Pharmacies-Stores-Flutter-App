import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/i18n.dart';
import '../models/cart.dart';
import '../models/credit_card.dart';
import '../models/order.dart';
import '../models/order_status.dart';
import '../models/payment.dart';
import '../models/product_order.dart';
import '../repository/cart_repository.dart';
import '../repository/order_repository.dart' as orderRepo;
import '../repository/settings_repository.dart';
import '../repository/settings_repository.dart' as settingRepo;
import '../repository/user_repository.dart' as userRepo;

class CheckoutController extends ControllerMVC {
  List<Cart> carts = <Cart>[];
  Payment payment;
  double taxAmount = 0.0;
  double deliveryFee = 0.0;
  double subTotal = 0.0;
  double total = 0.0;
  CreditCard creditCard = new CreditCard();
  bool loading = true;
  GlobalKey<ScaffoldState> scaffoldKey;

  CheckoutController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    listenForCreditCard();
  }

  void listenForCreditCard() async {
    creditCard = await userRepo.getCreditCard();
    setState(() {});
  }

  void listenForCarts({String message, bool withAddOrder = false}) async {
    final Stream<Cart> stream = await getCart();
    stream.listen((Cart _cart) {
      if (!carts.contains(_cart)) {
        setState(() {
          carts.add(_cart);
        });
      }
    }, onError: (a) {
      print(a);
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text(S.current.verify_your_internet_connection),
      ));
    }, onDone: () {
      calculateSubtotal();
      if (withAddOrder != null && withAddOrder == true) {
        addOrder(carts);
      }
      if (message != null) {
        scaffoldKey?.currentState?.showSnackBar(SnackBar(
          content: Text(message),
        ));
      }
    });
  }

  void addOrder(List<Cart> carts) async {
    Order _order = new Order();
    _order.productOrders = new List<ProductOrder>();
    _order.tax = setting.value.defaultTax;
    OrderStatus _orderStatus = new OrderStatus();
    _orderStatus.id = '1'; // TODO default order status Id
    _order.orderStatus = _orderStatus;
    _order.deliveryAddress = userRepo.deliveryAddress;
    carts.forEach((_cart) {
      ProductOrder _productOrder = new ProductOrder();
      _productOrder.quantity = _cart.quantity;
      _productOrder.price = _cart.product.price;
      _productOrder.product = _cart.product;
      _productOrder.options = _cart.options;
      _order.productOrders.add(_productOrder);
    });
    orderRepo.addOrder(_order, this.payment).then((value) {
      if (value is Order) {
        setState(() {
          loading = false;
        });
      }
    });
  }

  void calculateSubtotal() async {
    subTotal = 0;
    carts.forEach((cart) {
      subTotal += cart.quantity * cart.product.price;
    });
    deliveryFee = carts[0].product.market.deliveryFee;
    taxAmount = (subTotal + deliveryFee) * settingRepo.setting.value.defaultTax / 100;
    total = subTotal + taxAmount + deliveryFee;
    setState(() {});
  }

  void updateCreditCard(CreditCard creditCard) {
    userRepo.setCreditCard(creditCard).then((value) {
      setState(() {});
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text('Payment card updated successfully'),
      ));
    });
  }
}
