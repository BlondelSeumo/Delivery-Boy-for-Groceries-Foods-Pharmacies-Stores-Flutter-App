import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/i18n.dart';
import '../repository/settings_repository.dart' as settingRepo;
import '../repository/user_repository.dart' as userRepo;

class SplashScreenController extends ControllerMVC with ChangeNotifier {
  ValueNotifier<Map<String, double>> progress = new ValueNotifier(new Map());
  GlobalKey<ScaffoldState> scaffoldKey;

  SplashScreenController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    // Should define these variables before the app loaded
    progress.value = {"Setting": 0, "User": 0, "DeliveryAddress": 0};
  }

  @override
  void initState() {
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
    configureFirebase(_firebaseMessaging);
    settingRepo.setting.addListener(() {
      if (settingRepo.setting.value.appName != null && settingRepo.setting.value.appName != '' && settingRepo.setting.value.mainColor != null) {
        progress.value["Setting"] = 41;
        progress?.notifyListeners();
      }
    });
    settingRepo.myAddress.addListener(() {
      if (settingRepo.myAddress.value.address != null) {
        progress.value["DeliveryAddress"] = 29;
        progress?.notifyListeners();
      }
    });
    userRepo.currentUser.addListener(() {
      if (userRepo.currentUser.value.auth != null) {
        progress.value["User"] = 30;
        progress?.notifyListeners();
      }
    });
    Timer(Duration(seconds: 20), () {
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text(S.current.verify_your_internet_connection),
      ));
    });

    super.initState();
  }

  void configureFirebase(FirebaseMessaging _firebaseMessaging) {
    _firebaseMessaging.configure(
      onMessage: notificationOnMessage,
      onLaunch: notificationOnLaunch,
      onResume: notificationOnResume,
      onBackgroundMessage: myBackgroundMessageHandler,
    );
  }

  Future notificationOnResume(Map<String, dynamic> message) async {
    print(message['data']['id']);
    try {
      if (message['data']['id'] == "orders") {
        settingRepo.navigatorKey.currentState.pushReplacementNamed('/Pages', arguments: 3);
      }
    } catch (e) {
      print(e);
    }
  }

  Future notificationOnLaunch(Map<String, dynamic> message) async {
    String messageId = await settingRepo.getMessageId();
    try {
      if (messageId != message['google.message_id']) {
        if (message['data']['id'] == "orders") {
          await settingRepo.saveMessageId(message['google.message_id']);
          settingRepo.navigatorKey.currentState.pushReplacementNamed('/Pages', arguments: 3);
        }
      }
    } catch (e) {}
  }

  Future notificationOnMessage(Map<String, dynamic> message) async {
    Fluttertoast.showToast(
      msg: message['notification']['title'],
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 5,
    );
  }

  // ignore: missing_return
  static Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) {
    if (message.containsKey('data')) {
      // Handle data message
      //final dynamic data = message['data'];
    }

    if (message.containsKey('notification')) {
      // Handle notification message
      //final dynamic notification = message['notification'];
    }
  }
}
