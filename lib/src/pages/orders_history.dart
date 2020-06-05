import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/i18n.dart';
import '../controllers/order_controller.dart';
import '../elements/EmptyOrdersWidget.dart';
import '../elements/OrderItemWidget.dart';
import '../elements/ShoppingCartButtonWidget.dart';
import '../models/route_argument.dart';

class OrdersHistoryWidget extends StatefulWidget {
  final GlobalKey<ScaffoldState> parentScaffoldKey;

  OrdersHistoryWidget({Key key, this.parentScaffoldKey}) : super(key: key);

  @override
  _OrdersHistoryWidgetState createState() => _OrdersHistoryWidgetState();
}

class _OrdersHistoryWidgetState extends StateMVC<OrdersHistoryWidget> {
  OrderController _con;

  _OrdersHistoryWidgetState() : super(OrderController()) {
    _con = controller;
  }

  @override
  void initState() {
    _con.listenForOrdersHistory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).copyWith(dividerColor: Colors.transparent);
    return Scaffold(
      key: _con.scaffoldKey,
      appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.sort, color: Theme.of(context).hintColor),
          onPressed: () => widget.parentScaffoldKey.currentState.openDrawer(),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          S.of(context).orders_history,
          style: Theme.of(context).textTheme.title.merge(TextStyle(letterSpacing: 1.3)),
        ),
        actions: <Widget>[
          new ShoppingCartButtonWidget(iconColor: Theme.of(context).hintColor, labelColor: Theme.of(context).accentColor),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _con.refreshOrders,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              _con.orders.isEmpty
                  ? EmptyOrdersWidget()
                  : ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      primary: false,
                      itemCount: _con.orders.length,
                      itemBuilder: (context, index) {
                        return Theme(
                          data: theme,
                          child: ExpansionTile(
                            backgroundColor: Theme.of(context).focusColor.withOpacity(0.05),
                            trailing: IconButton(
                              icon: Icon(Icons.arrow_forward),
                              onPressed: () {
                                Navigator.of(context).pushNamed('/OrderDetails', arguments: RouteArgument(id: _con.orders.elementAt(index).id));
                              },
                            ),
                            leading: _con.orders.elementAt(index).orderStatus.id == '5'
                                ? Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.green.withOpacity(0.2)),
                                    child: Icon(
                                      Icons.check,
                                      color: Colors.green,
                                      size: 32,
                                    ),
                                  )
                                : Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).hintColor.withOpacity(0.1)),
                                    child: Icon(
                                      Icons.update,
                                      color: Theme.of(context).hintColor.withOpacity(0.8),
                                      size: 30,
                                    ),
                                  ),
                            initiallyExpanded: false,
                            title: Text('${S.of(context).order_id}: #${_con.orders.elementAt(index).id}'),
                            subtitle: Text(
                              _con.orders.elementAt(index).deliveryAddress?.address ?? S.of(context).address_not_provided_contact_client,
                              style: Theme.of(context).textTheme.caption,
                              softWrap: false,
                              overflow: TextOverflow.fade,
                              maxLines: 1,
                            ),
                            children: List.generate(_con.orders.elementAt(index).productOrders?.length ?? 0, (indexProduct) {
                              return OrderItemWidget(
                                  heroTag: 'my_orders',
                                  order: _con.orders.elementAt(index),
                                  productOrder: _con.orders.elementAt(index).productOrders.elementAt(indexProduct));
                            }),
                          ),
                        );
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
