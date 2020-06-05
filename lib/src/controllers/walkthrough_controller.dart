import 'package:mvc_pattern/mvc_pattern.dart';

import '../models/market.dart';

class WalkthroughController extends ControllerMVC {
  List<Market> topMarkets = <Market>[];

  WalkthroughController() {
    //listenForTopMarkets();
  }
}
