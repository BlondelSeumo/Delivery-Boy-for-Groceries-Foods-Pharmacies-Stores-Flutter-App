import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/i18n.dart';
import '../models/address.dart' as model;
import '../repository/user_repository.dart' as userRepo;

class DeliveryAddressesController extends ControllerMVC {
  List<model.Address> addresses = <model.Address>[];
  GlobalKey<ScaffoldState> scaffoldKey;

  DeliveryAddressesController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    listenForAddresses();
  }

  void listenForAddresses({String message}) async {
    final Stream<model.Address> stream = await userRepo.getAddresses();
    stream.listen((model.Address _address) {
      setState(() {
        addresses.add(_address);
      });
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

  Future<void> refreshAddresses() async {
    addresses.clear();
    listenForAddresses(message: S.current.addresses_refreshed_successfuly);
  }

  void addAddress(model.Address address) {
    userRepo.addAddress(address).then((value) {
      setState(() {
        this.addresses.add(value);
      });
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text(S.current.new_address_added_successfully),
      ));
    });
  }

  void chooseDeliveryAddress(model.Address address) {
    userRepo.deliveryAddress = address;
  }

  void updateAddress(model.Address address) {
//    if (address.isDefault) {
//      this.addresses.map((model.Address _address) {
//        setState(() {
//          _address.isDefault = false;
//        });
//      });
//    }
    userRepo.updateAddress(address).then((value) {
      //setState(() {});
//      scaffoldKey?.currentState?.showSnackBar(SnackBar(
//        content: Text(S.current.the_address_updated_successfully),
//      ));
      setState(() {});
      addresses.clear();
      listenForAddresses(message: S.current.the_address_updated_successfully);
    });
  }

  void removeDeliveryAddress(model.Address address) async {
    userRepo.removeDeliveryAddress(address).then((value) {
      setState(() {
        this.addresses.remove(address);
      });
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text("Delivery Address removed successfully"),
      ));
    });
  }
}
