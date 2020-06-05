import 'dart:async';

import 'package:flutter/material.dart';

import '../../generated/i18n.dart';
import '../helpers/app_config.dart' as config;

class EmptyOrdersWidget extends StatefulWidget {
  EmptyOrdersWidget({
    Key key,
  }) : super(key: key);

  @override
  _EmptyOrdersWidgetState createState() => _EmptyOrdersWidgetState();
}

class _EmptyOrdersWidgetState extends State<EmptyOrdersWidget> {
  bool loading = true;

  @override
  void initState() {
    Timer(Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        loading
            ? SizedBox(
                height: 3,
                child: LinearProgressIndicator(
                  backgroundColor: Theme.of(context).accentColor.withOpacity(0.2),
                ),
              )
            : SizedBox(),
        Container(
          alignment: AlignmentDirectional.center,
          padding: EdgeInsets.symmetric(horizontal: 30),
          height: config.App(context).appHeight(70),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(begin: Alignment.bottomLeft, end: Alignment.topRight, colors: [
                          Theme.of(context).focusColor.withOpacity(0.7),
                          Theme.of(context).focusColor.withOpacity(0.05),
                        ])),
                    child: Icon(
                      Icons.shopping_basket,
                      color: Theme.of(context).scaffoldBackgroundColor,
                      size: 70,
                    ),
                  ),
                  Positioned(
                    right: -30,
                    bottom: -50,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(150),
                      ),
                    ),
                  ),
                  Positioned(
                    left: -20,
                    top: -50,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(150),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 15),
              Opacity(
                opacity: 0.4,
                child: Text(
                  S.of(context).you_dont_have_any_order_assigned_to_you,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.display2.merge(TextStyle(fontWeight: FontWeight.w300)),
                ),
              ),
              SizedBox(height: 50),
            ],
          ),
        ),
      ],
    );
  }
}
