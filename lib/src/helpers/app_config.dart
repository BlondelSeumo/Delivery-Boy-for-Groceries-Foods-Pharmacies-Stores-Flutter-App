import 'package:flutter/material.dart';

import '../repository/settings_repository.dart' as settingRepo;

class App {
  BuildContext _context;
  double _height;
  double _width;
  double _heightPadding;
  double _widthPadding;

  App(_context) {
    this._context = _context;
    MediaQueryData _queryData = MediaQuery.of(this._context);
    _height = _queryData.size.height / 100.0;
    _width = _queryData.size.width / 100.0;
    _heightPadding = _height - ((_queryData.padding.top + _queryData.padding.bottom) / 100.0);
    _widthPadding = _width - (_queryData.padding.left + _queryData.padding.right) / 100.0;
  }

  double appHeight(double v) {
    return _height * v;
  }

  double appWidth(double v) {
    return _width * v;
  }

  double appVerticalPadding(double v) {
    return _heightPadding * v;
  }

  double appHorizontalPadding(double v) {
//    int.parse(settingRepo.setting.mainColor.replaceAll("#", "0xFF"));
    return _widthPadding * v;
  }
}

class Colors {
  Color mainColor(double opacity) {
    try {
      return Color(int.parse(settingRepo.setting.value.mainColor.replaceAll("#", "0xFF"))).withOpacity(opacity);
    } catch (e) {
      return Color(0xFFCCCCCC).withOpacity(opacity);
    }
  }

  Color secondColor(double opacity) {
    try {
      return Color(int.parse(settingRepo.setting.value.secondColor.replaceAll("#", "0xFF"))).withOpacity(opacity);
    } catch (e) {
      return Color(0xFFCCCCCC).withOpacity(opacity);
    }
  }

  Color accentColor(double opacity) {
    try {
      return Color(int.parse(settingRepo.setting.value.accentColor.replaceAll("#", "0xFF"))).withOpacity(opacity);
    } catch (e) {
      return Color(0xFFCCCCCC).withOpacity(opacity);
    }
  }

  Color mainDarkColor(double opacity) {
    try {
      return Color(int.parse(settingRepo.setting.value.mainDarkColor.replaceAll("#", "0xFF"))).withOpacity(opacity);
    } catch (e) {
      return Color(0xFFCCCCCC).withOpacity(opacity);
    }
  }

  Color secondDarkColor(double opacity) {
    try {
      return Color(int.parse(settingRepo.setting.value.secondDarkColor.replaceAll("#", "0xFF"))).withOpacity(opacity);
    } catch (e) {
      return Color(0xFFCCCCCC).withOpacity(opacity);
    }
  }

  Color accentDarkColor(double opacity) {
    try {
      return Color(int.parse(settingRepo.setting.value.accentDarkColor.replaceAll("#", "0xFF"))).withOpacity(opacity);
    } catch (e) {
      return Color(0xFFCCCCCC).withOpacity(opacity);
    }
  }

  Color scaffoldColor(double opacity) {
    // TODO test if brightness is dark or not
    try {
      return Color(int.parse(settingRepo.setting.value.scaffoldColor.replaceAll("#", "0xFF"))).withOpacity(opacity);
    } catch (e) {
      return Color(0xFFCCCCCC).withOpacity(opacity);
    }
  }
}
