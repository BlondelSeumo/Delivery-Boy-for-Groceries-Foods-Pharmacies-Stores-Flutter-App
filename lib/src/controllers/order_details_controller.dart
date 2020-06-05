import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/i18n.dart';
import '../models/order.dart';
import '../repository/order_repository.dart';

class OrderDetailsController extends ControllerMVC {
  Order order;
  double taxAmount = 0.0;
  double subTotal = 0.0;
  double deliveryFee = 0.0;
  double total = 0.0;
  GlobalKey<ScaffoldState> scaffoldKey;

  OrderDetailsController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }

  void listenForOrder({String id, String message}) async {
    final Stream<Order> stream = await getOrder(id);
    stream.listen((Order _order) {
      setState(() => order = _order);
    }, onError: (a) {
      print(a);
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text(S.current.verify_your_internet_connection),
      ));
    }, onDone: () {
      calculateSubtotal();
      if (message != null) {
        scaffoldKey?.currentState?.showSnackBar(SnackBar(
          content: Text(message),
        ));
      }
    });
  }

  Future<void> refreshOrder() async {
    listenForOrder(id: order.id, message: S.current.order_refreshed_successfuly);
  }

  void doDeliveredOrder(Order _order) async {
    deliveredOrder(_order).then((value) {
      setState(() {
        this.order.orderStatus.id = '5';
      });
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text('The order deliverd successfully to client'),
      ));
    });
  }

  void calculateSubtotal() async {
    subTotal = 0;
    order.productOrders?.forEach((product) {
      subTotal += product.quantity * product.price;
    });
    deliveryFee = order.productOrders?.elementAt(0)?.product?.market?.deliveryFee ?? 0;
    taxAmount = (subTotal + deliveryFee) * order.tax / 100;
    total = subTotal + taxAmount + deliveryFee;

    taxAmount = subTotal * order.tax / 100;
    total = subTotal + taxAmount;
    setState(() {});
  }
}
