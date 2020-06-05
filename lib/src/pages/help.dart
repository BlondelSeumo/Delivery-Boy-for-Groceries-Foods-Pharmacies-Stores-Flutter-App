import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/i18n.dart';
import '../controllers/faq_controller.dart';
import '../elements/CircularLoadingWidget.dart';
import '../elements/DrawerWidget.dart';
import '../elements/FaqItemWidget.dart';
import '../elements/ShoppingCartButtonWidget.dart';

class HelpWidget extends StatefulWidget {
  @override
  _HelpWidgetState createState() => _HelpWidgetState();
}

class _HelpWidgetState extends StateMVC<HelpWidget> {
  FaqController _con;

  _HelpWidgetState() : super(FaqController()) {
    _con = controller;
  }

  @override
  Widget build(BuildContext context) {
    return _con.faqs.isEmpty
        ? Scaffold(
            body: CircularLoadingWidget(height: 500),
          )
        : DefaultTabController(
            length: _con.faqs.length,
            child: Scaffold(
              key: _con.scaffoldKey,
              drawer: DrawerWidget(),
              appBar: AppBar(
                backgroundColor: Theme.of(context).focusColor,
                elevation: 0,
                centerTitle: true,
                iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
                bottom: TabBar(
                  tabs: List.generate(_con.faqs.length, (index) {
                    return Tab(text: _con.faqs.elementAt(index).name ?? '');
                  }),
                  labelColor: Theme.of(context).primaryColor,
                ),
                title: Text(
                  S.of(context).faq,
                  style: Theme.of(context).textTheme.title.merge(TextStyle(letterSpacing: 1.3, color: Theme.of(context).primaryColor)),
                ),
                actions: <Widget>[
                  new ShoppingCartButtonWidget(iconColor: Theme.of(context).primaryColor, labelColor: Theme.of(context).accentColor),
                ],
              ),
              body: RefreshIndicator(
                onRefresh: _con.refreshFaqs,
                child: TabBarView(
                  children: List.generate(_con.faqs.length, (index) {
                    return SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          SizedBox(height: 15),
                          ListTile(
                            contentPadding: EdgeInsets.symmetric(vertical: 0),
                            leading: Icon(
                              Icons.help,
                              color: Theme.of(context).hintColor,
                            ),
                            title: Text(
                              S.of(context).help_supports,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.display1,
                            ),
                          ),
                          ListView.separated(
                            padding: EdgeInsets.symmetric(vertical: 5),
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            primary: false,
                            itemCount: _con.faqs.elementAt(index).faqs.length,
                            separatorBuilder: (context, index) {
                              return SizedBox(height: 15);
                            },
                            itemBuilder: (context, indexFaq) {
                              return FaqItemWidget(faq: _con.faqs.elementAt(index).faqs.elementAt(indexFaq));
                            },
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ),
          );
  }
}
