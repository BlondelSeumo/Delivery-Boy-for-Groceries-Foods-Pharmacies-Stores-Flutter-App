import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../generated/i18n.dart';
import '../controllers/order_details_controller.dart';
import '../elements/CircularLoadingWidget.dart';
import '../elements/DrawerWidget.dart';
import '../elements/OrderItemWidget.dart';
import '../elements/ShoppingCartButtonWidget.dart';
import '../helpers/helper.dart';
import '../models/route_argument.dart';
import '../repository/settings_repository.dart';

class OrderWidget extends StatefulWidget {
  final RouteArgument routeArgument;

  OrderWidget({Key key, this.routeArgument}) : super(key: key);

  @override
  _OrderWidgetState createState() {
    return _OrderWidgetState();
  }
}

class _OrderWidgetState extends StateMVC<OrderWidget> {
  OrderDetailsController _con;

  _OrderWidgetState() : super(OrderDetailsController()) {
    _con = controller;
  }

  @override
  void initState() {
    _con.listenForOrder(id: widget.routeArgument.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _con.scaffoldKey,
        drawer: DrawerWidget(),
        appBar: AppBar(
          leading: new IconButton(
            icon: new Icon(Icons.sort, color: Theme.of(context).hintColor),
            onPressed: () => _con.scaffoldKey?.currentState?.openDrawer(),
          ),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text(
            S.of(context).order_details,
            style: Theme.of(context).textTheme.title.merge(TextStyle(letterSpacing: 1.3)),
          ),
          actions: <Widget>[
            new ShoppingCartButtonWidget(iconColor: Theme.of(context).hintColor, labelColor: Theme.of(context).accentColor),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: _con.refreshOrder,
          child: _con.order == null
              ? CircularLoadingWidget(height: 500)
              : Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(bottom: _con.order.orderStatus.id == '5' ? 180 : 230),
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor.withOpacity(0.9),
                                boxShadow: [
                                  BoxShadow(color: Theme.of(context).focusColor.withOpacity(0.1), blurRadius: 5, offset: Offset(0, 2)),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  _con.order.orderStatus.id == '5'
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
                                  SizedBox(width: 15),
                                  Flexible(
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                S.of(context).order_id + "#${_con.order.id}",
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                                style: Theme.of(context).textTheme.subhead,
                                              ),
                                              Text(
                                                _con.order.payment?.method ?? S.of(context).cash_on_delivery,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                                style: Theme.of(context).textTheme.caption,
                                              ),
                                              Text(
                                                DateFormat('yyyy-MM-dd HH:mm').format(_con.order.dateTime),
                                                style: Theme.of(context).textTheme.caption,
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: <Widget>[
                                            Helper.getPrice(_con.total, context, style: Theme.of(context).textTheme.display1),
                                            Text(
                                              S.of(context).items + ':' + _con.order.productOrders?.length?.toString() ?? 0,
                                              style: Theme.of(context).textTheme.caption,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20, right: 10),
                              child: ListTile(
                                contentPadding: EdgeInsets.symmetric(vertical: 0),
                                leading: Icon(
                                  Icons.person_pin,
                                  color: Theme.of(context).hintColor,
                                ),
                                title: Text(
                                  S.of(context).customer,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.display1,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      _con.order.user.name,
                                      style: Theme.of(context).textTheme.body2,
                                    ),
                                  ),
                                  SizedBox(width: 20),
                                  SizedBox(
                                    width: 42,
                                    height: 42,
                                    child: FlatButton(
                                      padding: EdgeInsets.all(0),
                                      disabledColor: Theme.of(context).focusColor.withOpacity(0.4),
                                      //onPressed: () {
//                                    Navigator.of(context).pushNamed('/Profile',
//                                        arguments: new RouteArgument(param: _con.order.deliveryAddress));
                                      //},
                                      child: Icon(
                                        Icons.person,
                                        color: Theme.of(context).primaryColor,
                                        size: 24,
                                      ),
                                      color: Theme.of(context).accentColor.withOpacity(0.9),
                                      shape: StadiumBorder(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      _con.order.deliveryAddress?.address ?? S.of(context).address_not_provided_please_call_the_client,
                                      style: Theme.of(context).textTheme.body2,
                                    ),
                                  ),
                                  SizedBox(width: 20),
                                  SizedBox(
                                    width: 42,
                                    height: 42,
                                    child: FlatButton(
                                      padding: EdgeInsets.all(0),
                                      disabledColor: Theme.of(context).focusColor.withOpacity(0.4),
                                      onPressed: () {
                                        Navigator.of(context).pushNamed('/Pages', arguments: new RouteArgument(id: '3', param: _con.order));
                                      },
                                      child: Icon(
                                        Icons.directions,
                                        color: Theme.of(context).primaryColor,
                                        size: 24,
                                      ),
                                      color: Theme.of(context).accentColor.withOpacity(0.9),
                                      shape: StadiumBorder(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      _con.order.user.phone,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context).textTheme.body2,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  SizedBox(
                                    width: 42,
                                    height: 42,
                                    child: FlatButton(
                                      padding: EdgeInsets.all(0),
                                      onPressed: () {
                                        launch("tel:${_con.order.user.phone}");
                                      },
                                      child: Icon(
                                        Icons.call,
                                        color: Theme.of(context).primaryColor,
                                        size: 24,
                                      ),
                                      color: Theme.of(context).accentColor.withOpacity(0.9),
                                      shape: StadiumBorder(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20, right: 10),
                              child: ListTile(
                                contentPadding: EdgeInsets.symmetric(vertical: 0),
                                leading: Icon(
                                  Icons.shopping_basket,
                                  color: Theme.of(context).hintColor,
                                ),
                                title: Text(
                                  S.of(context).ordered_products,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.display1,
                                ),
                              ),
                            ),
                            ListView.separated(
                              padding: EdgeInsets.only(bottom: 50),
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              primary: false,
                              itemCount: _con.order.productOrders?.length ?? 0,
                              separatorBuilder: (context, index) {
                                return SizedBox(height: 15);
                              },
                              itemBuilder: (context, index) {
                                return OrderItemWidget(heroTag: 'my_orders', order: _con.order, productOrder: _con.order.productOrders.elementAt(index));
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      child: Container(
                        height: _con.order.orderStatus.id == '5' ? 200 : 246,
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
                            boxShadow: [BoxShadow(color: Theme.of(context).focusColor.withOpacity(0.15), offset: Offset(0, -2), blurRadius: 5.0)]),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width - 40,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      S.of(context).subtotal,
                                      style: Theme.of(context).textTheme.body2,
                                    ),
                                  ),
                                  Helper.getPrice(_con.subTotal, context, style: Theme.of(context).textTheme.subhead)
                                ],
                              ),
                              SizedBox(height: 5),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      S.of(context).delivery_fee,
                                      style: Theme.of(context).textTheme.body2,
                                    ),
                                  ),
                                  Helper.getPrice(_con.deliveryFee, context, style: Theme.of(context).textTheme.subhead)
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      "${S.of(context).tax} (${setting.value.defaultTax}%)",
                                      style: Theme.of(context).textTheme.body2,
                                    ),
                                  ),
                                  Helper.getPrice(_con.taxAmount, context, style: Theme.of(context).textTheme.subhead)
                                ],
                              ),
                              Divider(height: 30),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      S.of(context).total,
                                      style: Theme.of(context).textTheme.title,
                                    ),
                                  ),
                                  Helper.getPrice(_con.total, context, style: Theme.of(context).textTheme.title)
                                ],
                              ),
                              SizedBox(height: 20),
                              _con.order.orderStatus.id != '5'
                                  ? SizedBox(
                                      width: MediaQuery.of(context).size.width - 40,
                                      child: FlatButton(
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: Text(S.of(context).delivery_confirmation),
                                                  content: Text(S.of(context).would_you_please_confirm_if_you_have_delivered_all_meals),
                                                  actions: <Widget>[
                                                    // usually buttons at the bottom of the dialog
                                                    FlatButton(
                                                      child: new Text(S.of(context).confirm),
                                                      onPressed: () {
                                                        _con.doDeliveredOrder(_con.order);
                                                        Navigator.of(context).pop();
                                                      },
                                                    ),
                                                    FlatButton(
                                                      child: new Text(S.of(context).dismiss),
                                                      onPressed: () {
                                                        Navigator.of(context).pop();
                                                      },
                                                    ),
                                                  ],
                                                );
                                              });
                                        },
                                        padding: EdgeInsets.symmetric(vertical: 14),
                                        color: Theme.of(context).accentColor,
                                        shape: StadiumBorder(),
                                        child: Text(
                                          S.of(context).delivered,
                                          textAlign: TextAlign.start,
                                          style: TextStyle(color: Theme.of(context).primaryColor),
                                        ),
                                      ),
                                    )
                                  : SizedBox(height: 0),
                              SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
        ));
  }
}
