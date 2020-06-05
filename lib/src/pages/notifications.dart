import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/i18n.dart';
import '../controllers/notification_controller.dart';
import '../elements/DrawerWidget.dart';
import '../elements/EmptyNotificationsWidget.dart';
import '../elements/NotificationItemWidget.dart';

class NotificationsWidget extends StatefulWidget {
  final GlobalKey<ScaffoldState> parentScaffoldKey;

  NotificationsWidget({Key key, this.parentScaffoldKey}) : super(key: key);

  @override
  _NotificationsWidgetState createState() => _NotificationsWidgetState();
}

class _NotificationsWidgetState extends StateMVC<NotificationsWidget> {
  NotificationController _con;

  _NotificationsWidgetState() : super(NotificationController()) {
    _con = controller;
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
          S.of(context).notifications,
          style: Theme.of(context).textTheme.title.merge(TextStyle(letterSpacing: 1.3)),
        ),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/Notifications');
            },
            child: Stack(
              alignment: AlignmentDirectional.bottomEnd,
              children: <Widget>[
                Icon(
                  Icons.notifications_none,
                  color: Theme.of(context).hintColor,
                  size: 28,
                ),
                Container(
                  child: Text(
                    _con.unReadNotificationsCount.toString(),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.caption.merge(
                          TextStyle(color: Theme.of(context).primaryColor, fontSize: 8),
                        ),
                  ),
                  padding: EdgeInsets.all(0),
                  decoration: BoxDecoration(color: Theme.of(context).accentColor, borderRadius: BorderRadius.all(Radius.circular(10))),
                  constraints: BoxConstraints(minWidth: 13, maxWidth: 13, minHeight: 13, maxHeight: 13),
                ),
              ],
            ),
            color: Colors.transparent,
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _con.refreshNotifications,
        child: _con.notifications.isEmpty
            ? EmptyNotificationsWidget()
            : ListView(
                padding: EdgeInsets.symmetric(vertical: 10),
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 10),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(vertical: 0),
                      leading: Icon(
                        Icons.notifications,
                        color: Theme.of(context).hintColor,
                      ),
                      title: Text(
                        S.of(context).notifications,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.display1,
                      ),
                      subtitle: Text(
                        S.of(context).swip_left_the_notification_to_delete_or_read__unread,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.caption,
                      ),
                    ),
                  ),
                  ListView.separated(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    primary: false,
                    itemCount: _con.notifications.length,
                    separatorBuilder: (context, index) {
                      return SizedBox(height: 15);
                    },
                    itemBuilder: (context, index) {
                      return NotificationItemWidget(
                        notification: _con.notifications.elementAt(index),
                        onMarkAsRead: () {
                          _con.doMarkAsReadNotifications(_con.notifications.elementAt(index));
                        },
                        onMarkAsUnRead: () {
                          _con.doMarkAsUnReadNotifications(_con.notifications.elementAt(index));
                        },
                        onRemoved: () {
                          _con.doRemoveNotification(_con.notifications.elementAt(index));
                        },
                      );
                    },
                  ),
                ],
              ),
      ),
    );
  }
}
