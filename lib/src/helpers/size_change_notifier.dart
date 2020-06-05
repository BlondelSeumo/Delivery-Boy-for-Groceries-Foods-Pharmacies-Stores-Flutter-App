// Copyright 2015 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

typedef void SizeChangedCallBack(Size newSize);

class LayoutSizeChangeNotification extends LayoutChangedNotification {
  LayoutSizeChangeNotification(this.newSize) : super();
  Size newSize;
}

/// A widget that automatically dispatches a [SizeChangedLayoutNotification]
/// when the layout dimensions of its child change.
///
/// The notification is not sent for the initial layout (since the size doesn't
/// change in that case, it's just established).
///
/// To listen for the notification dispatched by this widget, use a
/// [NotificationListener<SizeChangedLayoutNotification>].
///
/// The [Material] class listens for [LayoutChangedNotification]s, including
/// [SizeChangedLayoutNotification]s, to repaint [InkResponse] and [InkWell] ink
/// effects. When a widget is likely to change size, wrapping it in a
/// [SizeChangedLayoutNotifier] will cause the ink effects to correctly repaint
/// when the child changes size.
///
/// See also:
///
///  * [Notification], the base class for notifications that bubble through the
///    widget tree.
class LayoutSizeChangeNotifier extends SingleChildRenderObjectWidget {
  /// Creates a [SizeChangedLayoutNotifier] that dispatches layout changed
  /// notifications when [child] changes layout size.
  const LayoutSizeChangeNotifier({Key key, Widget child}) : super(key: key, child: child);

  @override
  _SizeChangeRenderWithCallback createRenderObject(BuildContext context) {
    return new _SizeChangeRenderWithCallback(onLayoutChangedCallback: (size) {
      new LayoutSizeChangeNotification(size).dispatch(context);
    });
  }
}

class _SizeChangeRenderWithCallback extends RenderProxyBox {
  _SizeChangeRenderWithCallback({RenderBox child, @required this.onLayoutChangedCallback})
      : assert(onLayoutChangedCallback != null),
        super(child);

  // There's a 1:1 relationship between the _RenderSizeChangedWithCallback and
  // the `context` that is captured by the closure created by createRenderObject
  // above to assign to onLayoutChangedCallback, and thus we know that the
  // onLayoutChangedCallback will never change nor need to change.

  final SizeChangedCallBack onLayoutChangedCallback;

  Size _oldSize;

  @override
  void performLayout() {
    super.performLayout();
    // Don't send the initial notification, or this will be SizeObserver all
    // over again!
    if (size != _oldSize) onLayoutChangedCallback(size);
    _oldSize = size;
  }
}
