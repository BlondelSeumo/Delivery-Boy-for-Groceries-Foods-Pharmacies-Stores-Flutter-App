import 'dart:convert';
import 'dart:io';

import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;

import '../helpers/helper.dart';
import '../models/favorite.dart';
import '../models/product.dart';
import '../models/user.dart';
import '../repository/user_repository.dart' as userRepo;

Future<Stream<Product>> getTrendingProducts() async {
  final String url = '${GlobalConfiguration().getString('api_base_url')}products?with=market&limit=6';

  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

  return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) => Helper.getData(data)).expand((data) => (data as List)).map((data) {
    return Product.fromJSON(data);
  });
}

Future<Stream<Product>> getProduct(String productId) async {
  final String url =
      '${GlobalConfiguration().getString('api_base_url')}products/$productId?with=nutrition;market;category;extras;productReviews;productReviews.user';

  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));
  return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) => Helper.getData(data)).map((data) {
    print(Product.fromJSON(data).market.toMap());
    return Product.fromJSON(data);
  });
}

Future<Stream<Product>> getProductsByCategory(categoryId) async {
  final String url = '${GlobalConfiguration().getString('api_base_url')}products?with=market&search=category_id:$categoryId&searchFields=category_id:=';

  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

  return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) => Helper.getData(data)).expand((data) => (data as List)).map((data) {
    return Product.fromJSON(data);
  });
}

Future<Stream<Favorite>> isFavoriteProduct(String productId) async {
  User _user = userRepo.currentUser.value;
  if (_user.apiToken == null) {
    return Stream.value(new Favorite());
  }
  final String _apiToken = 'api_token=${_user.apiToken}&';
  final String url = '${GlobalConfiguration().getString('api_base_url')}favorites/exist?${_apiToken}product_id=$productId&user_id=${_user.id}';

  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

  return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) => Helper.getObjectData(data)).map((data) => Favorite.fromJSON(data));
}

Future<Stream<Favorite>> getFavorites() async {
  User _user = userRepo.currentUser.value;
  if (_user.apiToken == null) {
    return Stream.value(new Favorite());
  }
  final String _apiToken = 'api_token=${_user.apiToken}&';
  final String url =
      '${GlobalConfiguration().getString('api_base_url')}favorites?${_apiToken}with=product;user;extras&search=user_id:${_user.id}&searchFields=user_id:=';

  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) => Helper.getData(data))
      .expand((data) => (data as List))
      .map((data) => Favorite.fromJSON(data));
}

Future<Favorite> addFavorite(Favorite favorite) async {
  User _user = userRepo.currentUser.value;
  if (_user.apiToken == null) {
    return new Favorite();
  }
  final String _apiToken = 'api_token=${_user.apiToken}';
  favorite.userId = _user.id;
  final String url = '${GlobalConfiguration().getString('api_base_url')}favorites?$_apiToken';
  final client = new http.Client();
  final response = await client.post(
    url,
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(favorite.toMap()),
  );
  return Favorite.fromJSON(json.decode(response.body)['data']);
}

Future<Favorite> removeFavorite(Favorite favorite) async {
  User _user = userRepo.currentUser.value;
  if (_user.apiToken == null) {
    return new Favorite();
  }
  final String _apiToken = 'api_token=${_user.apiToken}';
  final String url = '${GlobalConfiguration().getString('api_base_url')}favorites/${favorite.id}?$_apiToken';
  final client = new http.Client();
  final response = await client.delete(
    url,
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
  );
  return Favorite.fromJSON(json.decode(response.body)['data']);
}

Future<Stream<Product>> getProductsOfMarket(String marketId) async {
  final String url = '${GlobalConfiguration().getString('api_base_url')}products?with=market&search=market.id:$marketId&searchFields=market.id:=';

  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

  return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) => Helper.getData(data)).expand((data) => (data as List)).map((data) {
    return Product.fromJSON(data);
  });
}

Future<Stream<Product>> getTrendingProductsOfMarket(String marketId) async {
  // TODO Trending products only
  final String url = '${GlobalConfiguration().getString('api_base_url')}products?with=market&search=market.id:$marketId&searchFields=market.id:=';

  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

  return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) => Helper.getData(data)).expand((data) => (data as List)).map((data) {
    return Product.fromJSON(data);
  });
}

Future<Stream<Product>> getFeaturedProductsOfMarket(String marketId) async {
  // TODO Featured products only
  final String url = '${GlobalConfiguration().getString('api_base_url')}products?with=market&search=market_id:$marketId&searchFields=market_id:=';

  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

  return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) => Helper.getData(data)).expand((data) => (data as List)).map((data) {
    return Product.fromJSON(data);
  });
}
