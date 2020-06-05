import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/i18n.dart';
import '../controllers/map_controller.dart';
import '../elements/CircularLoadingWidget.dart';
import '../helpers/helper.dart';
import '../models/order.dart';
import '../models/route_argument.dart';

class MapWidget extends StatefulWidget {
  final RouteArgument routeArgument;
  final GlobalKey<ScaffoldState> parentScaffoldKey;

  MapWidget({Key key, this.routeArgument, this.parentScaffoldKey}) : super(key: key);

  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends StateMVC<MapWidget> {
  MapController _con;

  _MapWidgetState() : super(MapController()) {
    _con = controller;
  }

  @override
  void initState() {
    _con.currentOrder = widget.routeArgument?.param as Order;
    if (_con.currentOrder?.deliveryAddress?.latitude != null) {
      // user select a market
      print(_con.currentOrder.deliveryAddress.toMap().toString());
      _con.getOrderLocation();
      _con.getDirectionSteps();
    } else {
      _con.getCurrentLocation();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: _con.currentOrder?.deliveryAddress?.latitude == null
            ? new IconButton(
                icon: new Icon(Icons.sort, color: Theme.of(context).hintColor),
                onPressed: () => widget.parentScaffoldKey.currentState.openDrawer(),
              )
            : IconButton(
                icon: new Icon(Icons.arrow_back, color: Theme.of(context).hintColor),
                onPressed: () => Navigator.of(context).pop(),
              ),
        title: Text(
          S.of(context).delivery_addresses,
          style: Theme.of(context).textTheme.title.merge(TextStyle(letterSpacing: 1.3)),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.my_location,
              color: Theme.of(context).hintColor,
            ),
            onPressed: () {
              _con.goCurrentLocation();
            },
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.loose,
        alignment: AlignmentDirectional.bottomStart,
        children: <Widget>[
          _con.cameraPosition == null
              ? CircularLoadingWidget(height: 0)
              : GoogleMap(
                  mapToolbarEnabled: false,
                  mapType: MapType.normal,
                  initialCameraPosition: _con.cameraPosition,
                  markers: Set.from(_con.allMarkers),
                  onMapCreated: (GoogleMapController controller) {
                    _con.mapController.complete(controller);
                  },
                  onCameraMove: (CameraPosition cameraPosition) {
                    _con.cameraPosition = cameraPosition;
                  },
                  onCameraIdle: () {
                    _con.getOrdersOfArea();
                  },
                  polylines: _con.polylines,
                ),
          Container(
            height: 95,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            margin: EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.9),
              boxShadow: [
                BoxShadow(color: Theme.of(context).focusColor.withOpacity(0.1), blurRadius: 5, offset: Offset(0, 2)),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                _con.currentOrder?.orderStatus?.id == '5'
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              S.of(context).order_id + "#${_con.currentOrder.id}",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: Theme.of(context).textTheme.subhead,
                            ),
                            Text(
                              _con.currentOrder.payment?.method ?? S.of(context).cash_on_delivery,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: Theme.of(context).textTheme.caption,
                            ),
                            Text(
                              DateFormat('yyyy-MM-dd HH:mm').format(_con.currentOrder.dateTime),
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
                            S.of(context).items + ':' + _con.currentOrder.productOrders?.length?.toString() ?? 0,
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
        ],
      ),
    );
  }
}
