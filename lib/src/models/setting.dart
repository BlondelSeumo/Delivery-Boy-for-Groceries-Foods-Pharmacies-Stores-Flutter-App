import 'package:flutter/cupertino.dart';

class Setting {
  String appName = '';
  double defaultTax;
  String defaultCurrency;
  String distanceUnit;
  bool currencyRight = false;
  bool payPalEnabled = true;
  bool stripeEnabled = true;
  String mainColor;
  String mainDarkColor;
  String secondColor;
  String secondDarkColor;
  String accentColor;
  String accentDarkColor;
  String scaffoldDarkColor;
  String scaffoldColor;
  String googleMapsKey;
  ValueNotifier<Locale> mobileLanguage = new ValueNotifier(Locale('en', ''));
  String appVersion;
  bool enableVersion = true;

  ValueNotifier<Brightness> brightness = new ValueNotifier(Brightness.light);

  Setting();

  Setting.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      appName = jsonMap['app_name'] ?? null;
      mainColor = jsonMap['main_color'] ?? null;
      mainDarkColor = jsonMap['main_dark_color'] ?? '';
      secondColor = jsonMap['second_color'] ?? '';
      secondDarkColor = jsonMap['second_dark_color'] ?? '';
      accentColor = jsonMap['accent_color'] ?? '';
      accentDarkColor = jsonMap['accent_dark_color'] ?? '';
      scaffoldDarkColor = jsonMap['scaffold_dark_color'] ?? '';
      scaffoldColor = jsonMap['scaffold_color'] ?? '';
      googleMapsKey = jsonMap['google_maps_key'] ?? null;
      mobileLanguage.value = Locale(jsonMap['mobile_language'] ?? "en", '');
      appVersion = jsonMap['app_version'] ?? '';
      distanceUnit = jsonMap['distance_unit'] ?? 'km';
      enableVersion = jsonMap['enable_version'] == null || jsonMap['enable_version'] == '0' ? false : true;
      defaultTax = double.tryParse(jsonMap['default_tax']) ?? 0.0; //double.parse(jsonMap['default_tax'].toString());
      defaultCurrency = jsonMap['default_currency'] ?? '';
      currencyRight = jsonMap['currency_right'] == null || jsonMap['currency_right'] == '0' ? false : true;
      payPalEnabled = jsonMap['enable_paypal'] == null || jsonMap['enable_paypal'] == '0' ? false : true;
      stripeEnabled = jsonMap['enable_stripe'] == null || jsonMap['enable_stripe'] == '0' ? false : true;
    } catch (e) {
      print(e);
    }
  }

//  ValueNotifier<Locale> initMobileLanguage(String defaultLanguage) {
//    SharedPreferences.getInstance().then((prefs) {
//      return new ValueNotifier(Locale(prefs.get('language') ?? defaultLanguage, ''));
//    });
//    return new ValueNotifier(Locale(defaultLanguage ?? "en", ''));
//  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["app_name"] = appName;
    map["default_tax"] = defaultTax;
    map["default_currency"] = defaultCurrency;
    map["currency_right"] = currencyRight;
    map["enable_paypal"] = payPalEnabled;
    map["enable_stripe"] = stripeEnabled;
    map["mobile_language"] = mobileLanguage.value.languageCode;
    return map;
  }
}
