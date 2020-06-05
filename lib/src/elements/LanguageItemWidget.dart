import 'package:flutter/material.dart';

import '../models/language.dart';
import '../repository/settings_repository.dart' as settingRepo;

class LanguageItemWidget extends StatefulWidget {
  final Language language;
  final ValueChanged onTap;

  const LanguageItemWidget({
    Key key,
    this.language,
    this.onTap,
  }) : super(key: key);

  @override
  _LanguageItemWidgetState createState() => _LanguageItemWidgetState();
}

class _LanguageItemWidgetState extends State<LanguageItemWidget> with SingleTickerProviderStateMixin {
  Animation animation;
  AnimationController animationController;
  Animation<double> sizeCheckAnimation;
  Animation<double> rotateCheckAnimation;
  Animation<double> opacityAnimation;
  Animation opacityCheckAnimation;
  bool checked = false;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(duration: Duration(milliseconds: 350), vsync: this);
    CurvedAnimation curve = CurvedAnimation(parent: animationController, curve: Curves.easeOut);
    animation = Tween(begin: 0.0, end: 40.0).animate(curve)
      ..addListener(() {
        setState(() {});
      });
    opacityAnimation = Tween(begin: 0.0, end: 0.85).animate(curve)
      ..addListener(() {
        setState(() {});
      });
    opacityCheckAnimation = Tween(begin: 0.0, end: 1.0).animate(curve)
      ..addListener(() {
        setState(() {});
      });
    rotateCheckAnimation = Tween(begin: 2.0, end: 0.0).animate(curve)
      ..addListener(() {
        setState(() {});
      });
    sizeCheckAnimation = Tween<double>(begin: 0, end: 24).animate(curve)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.language.selected) {
      animationController.forward();
    }
    return InkWell(
      onTap: () async {
        widget.onTap(widget.language);
        if (widget.language.selected) {
          animationController.reverse();
        } else {
          animationController.forward();
        }
        settingRepo.setting.value.mobileLanguage.value = new Locale(widget.language.code, '');
        settingRepo.setting.notifyListeners();
        //settingRepo.locale.notifyListeners();
        //widget.language.selected = !widget.language.selected;
      },
      child: Container(
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
            Stack(
              alignment: AlignmentDirectional.center,
              children: <Widget>[
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(40)),
                    image: DecorationImage(image: AssetImage(widget.language.flag), fit: BoxFit.cover),
                  ),
                ),
                Container(
                  height: animation.value,
                  width: animation.value,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(40)),
                    color: Theme.of(context).accentColor.withOpacity(opacityAnimation.value),
                  ),
                  child: Transform.rotate(
                    angle: rotateCheckAnimation.value,
                    child: Icon(
                      Icons.check,
                      size: sizeCheckAnimation.value,
                      color: Theme.of(context).primaryColor.withOpacity(opacityCheckAnimation.value),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.language.englishName,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: Theme.of(context).textTheme.subhead,
                  ),
                  Text(
                    widget.language.localName,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: Theme.of(context).textTheme.caption,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
