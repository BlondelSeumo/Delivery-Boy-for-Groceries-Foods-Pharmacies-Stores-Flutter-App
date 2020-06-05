import 'package:flutter/material.dart';

class HeadingIconButtonWidget extends StatelessWidget {
  const HeadingIconButtonWidget({Key key, @required this.text, @required this.icon, this.showActions = false}) : super(key: key);

  final Text text;
  final Icon icon;
  final bool showActions;

  @override
  Widget build(BuildContext context) {
    return Container(
//      margin: EdgeInsets.only(top: 10),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                this.icon,
                SizedBox(width: 10),
                this.text,
              ],
            ),
          ),
          IconButton(
            color: Theme.of(context).hintColor,
            onPressed: () {},
            icon: Icon(Icons.more_horiz),
            iconSize: 28,
          )
        ],
      ),
    );
  }
}
