import 'dart:convert';
import 'dart:io';

import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;

import '../helpers/helper.dart';
import '../models/address.dart';
import '../models/order.dart';
import '../models/order_status.dart';
import '../models/payment.dart';
import '../models/user.dart';
import '../repository/user_repository.dart' as userRepo;

Future<Stream<Order>> getOrders() async {
  final String orderStatusId = "5"; // for delivered status
  User _user = userRepo.currentUser.value;
  if (_user.apiToken == null) {
    return Stream.value(Order());
  }
  final String _apiToken = 'api_token=${_user.apiToken}&';
  final String url =
      '${GlobalConfiguration().getString('api_base_url')}orders?${_apiToken}with=driver;productOrders;productOrders.product;orderStatus;deliveryAddress&search=driver.id:${_user.id};order_status_id:$orderStatusId&searchFields=driver.id:=;order_status_id:<>&searchJoin=and&orderBy=id&sortedBy=desc';
  print(url);
  try {
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', Uri.parse(url)));
    return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) => Helper.getData(data)).expand((data) => (data as List)).map((data) {
      return Order.fromJSON(data);
    });
  } on Exception catch (error) {
    print(error);
  }
}

Future<Stream<Order>> getNearOrders(Address myAddress, Address areaAddress) async {
  final String orderStatusId = "5"; // for delivered status
  User _user = userRepo.currentUser.value;
  if (_user.apiToken == null) {
    return Stream.value(Order());
  }
  final String _apiToken = 'api_token=${_user.apiToken}&';
  final String url =
      '${GlobalConfiguration().getString('api_base_url')}orders?${_apiToken}with=driver;productOrders;productOrders.product;orderStatus;deliveryAddress&search=driver.id:${_user.id};order_status_id:$orderStatusId&searchFields=driver.id:=;order_status_id:<>&searchJoin=and&orderBy=id&sortedBy=desc';
  print(url);
  try {
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', Uri.parse(url)));
    return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) => Helper.getData(data)).expand((data) => (data as List)).map((data) {
      return Order.fromJSON(data);
    });
  } on Exception catch (error) {
    print(error);
  }
}

Future<Stream<Order>> getOrdersHistory() async {
  final String orderStatusId = "5"; // for delivered status
  User _user = userRepo.currentUser.value;
  final String _apiToken = 'api_token=${_user.apiToken}&';
  final String url =
      '${GlobalConfiguration().getString('api_base_url')}orders?${_apiToken}with=driver;productOrders;productOrders.product;orderStatus;deliveryAddress&search=driver.id:${_user.id};order_status_id:$orderStatusId&searchFields=driver.id:=;order_status_id:=&searchJoin=and&orderBy=id&sortedBy=desc';
  print(url);
  try {
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', Uri.parse(url)));
    return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) => Helper.getData(data)).expand((data) => (data as List)).map((data) {
      return Order.fromJSON(data);
    });
  } on Exception catch (error) {
    print(error);
  }
}

Future<Stream<Order>> getOrder(orderId) async {
  User _user = userRepo.currentUser.value;
  if (_user.apiToken == null) {
    return new Stream.value(new Order());
  }
  final String _apiToken = 'api_token=${_user.apiToken}&';
  final String url =
      '${GlobalConfiguration().getString('api_base_url')}orders/$orderId?${_apiToken}with=user;productOrders;productOrders.product;orderStatus;deliveryAddress';
  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

  return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) => Helper.getObjectData(data)).map((data) {
    return Order.fromJSON(data);
  });
}

Future<Stream<Order>> getRecentOrders() async {
  User _user = userRepo.currentUser.value;
  if (_user.apiToken == null) {
    return new Stream.value(new Order());
  }
  final String _apiToken = 'api_token=${_user.apiToken}&';
  final String url =
      '${GlobalConfiguration().getString('api_base_url')}orders?${_apiToken}with=driver;productOrders;productOrders.product;orderStatus;deliveryAddress&search=driver.id:${_user.id}&searchFields=driver.id:=&orderBy=id&sortedBy=desc&limit=4';
  print(url);
  try {
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', Uri.parse(url)));
    return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) => Helper.getData(data)).expand((data) => (data as List)).map((data) {
      return Order.fromJSON(data);
    });
  } on Exception catch (error) {
    print(error);
  }
}

Future<Stream<OrderStatus>> getOrderStatus() async {
  User _user = userRepo.currentUser.value;
  if (_user.apiToken == null) {
    return new Stream.value(new OrderStatus());
  }
  final String _apiToken = 'api_token=${_user.apiToken}';
  final String url = '${GlobalConfiguration().getString('api_base_url')}order_statuses?$_apiToken';

  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

  return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) => Helper.getData(data)).expand((data) => (data as List)).map((data) {
    return OrderStatus.fromJSON(data);
  });
}

Future<Order> deliveredOrder(Order order) async {
  User _user = userRepo.currentUser.value;
  if (_user.apiToken == null) {
    return new Order();
  }
  final String _apiToken = 'api_token=${_user.apiToken}';
  final String url = '${GlobalConfiguration().getString('api_base_url')}orders/${order.id}?$_apiToken';
  final client = new http.Client();
  final response = await client.put(
    url,
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(order.deliveredMap()),
  );
  return Order.fromJSON(json.decode(response.body)['data']);
}

Future<Order> addOrder(Order order, Payment payment) async {
  /*
  User _user = userRepo.currentUser;
  CreditCard _creditCard = await userRepo.getCreditCard();
  order.user = _user;
  order.payment = payment;
  final String _apiToken = 'api_token=${_user.apiToken}';
  final String url = '${GlobalConfiguration().getString('api_base_url')}orders?$_apiToken';
  final client = new http.Client();
  Map params = order.toMap();
  params.addAll(_creditCard.toMap());
  final response = await client.post(
    url,
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(params),
  );
  print(response.body);
  return Order.fromJSON(json.decode(response.body)['data']);*/
}
