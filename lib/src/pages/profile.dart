import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/i18n.dart';
import '../controllers/profile_controller.dart';
import '../elements/CircularLoadingWidget.dart';
import '../elements/OrderItemWidget.dart';
import '../elements/ProfileAvatarWidget.dart';
import '../elements/ShoppingCartButtonWidget.dart';

class ProfileWidget extends StatefulWidget {
  final GlobalKey<ScaffoldState> parentScaffoldKey;

  ProfileWidget({Key key, this.parentScaffoldKey}) : super(key: key);

  @override
  _ProfileWidgetState createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends StateMVC<ProfileWidget> {
  ProfileController _con;

  _ProfileWidgetState() : super(ProfileController()) {
    _con = controller;
  }

  @override
  void initState() {
    _con.listenForRecentOrders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).copyWith(dividerColor: Colors.transparent);
    return Scaffold(
      appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.sort, color: Theme.of(context).primaryColor),
          onPressed: () => widget.parentScaffoldKey?.currentState?.openDrawer(),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).accentColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          S.of(context).profile,
          style: Theme.of(context).textTheme.title.merge(TextStyle(letterSpacing: 1.3, color: Theme.of(context).primaryColor)),
        ),
        actions: <Widget>[
          new ShoppingCartButtonWidget(iconColor: Theme.of(context).primaryColor, labelColor: Theme.of(context).hintColor),
        ],
      ),
      key: _con.scaffoldKey,
      body: _con.user.apiToken == null
          ? CircularLoadingWidget(height: 500)
          : SingleChildScrollView(
//              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
              child: Column(
                children: <Widget>[
                  ProfileAvatarWidget(user: _con.user),
                  ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    leading: Icon(
                      Icons.person,
                      color: Theme.of(context).hintColor,
                    ),
                    title: Text(
                      S.of(context).about,
                      style: Theme.of(context).textTheme.display1,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      _con.user.bio,
                      style: Theme.of(context).textTheme.body1,
                    ),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    leading: Icon(
                      Icons.shopping_basket,
                      color: Theme.of(context).hintColor,
                    ),
                    title: Text(
                      S.of(context).recent_orders,
                      style: Theme.of(context).textTheme.display1,
                    ),
                  ),
                  _con.recentOrders.isEmpty
                      ? CircularLoadingWidget(height: 200)
                      : ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          primary: false,
                          itemCount: _con.recentOrders.length,
                          itemBuilder: (context, index) {
                            return Theme(
                              data: theme,
                              child: ExpansionTile(
                                initiallyExpanded: true,
                                title: Row(
                                  children: <Widget>[
                                    Expanded(child: Text('${S.of(context).order_id}: #${_con.recentOrders.elementAt(index).id}')),
                                    Text(
                                      '${_con.recentOrders.elementAt(index).orderStatus.status}',
                                      style: Theme.of(context).textTheme.caption,
                                    ),
                                  ],
                                ),
                                children: List.generate(_con.recentOrders.elementAt(index).productOrders.length, (indexProduct) {
                                  return OrderItemWidget(
                                      heroTag: 'recent_orders',
                                      order: _con.recentOrders.elementAt(index),
                                      productOrder: _con.recentOrders.elementAt(index).productOrders.elementAt(indexProduct));
                                }),
                              ),
                            );
                          },
                        ),
                ],
              ),
            ),
    );
  }
}
