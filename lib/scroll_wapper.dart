import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class ScrollWrapper extends StatefulWidget {
  const ScrollWrapper({
    super.key,
    required this.child,
    required this.onTap,
  });

  final Widget child;
  final Future<void> Function() onTap;

  @override
  State<ScrollWrapper> createState() => _ScrollWrapperState();
}

class _ScrollWrapperState extends State<ScrollWrapper> {
  ScrollController? _primaryScrollController;
  ScrollPositionWithSingleContext? _scrollPositionWithSingleContext;
  bool _attached = false;

  @override
  void dispose() {
    final scrollPositionWithSingleContext = _scrollPositionWithSingleContext;
    if (scrollPositionWithSingleContext != null) {
      _primaryScrollController?.detach(scrollPositionWithSingleContext);
    }
    scrollPositionWithSingleContext?.dispose();
    _scrollPositionWithSingleContext = null;
    _scrollPositionWithSingleContext = null;
    _primaryScrollController = null;
    _attached = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 初回ビルド時に attach 処理を行う
    if (!_attached) {
      _attach(context);
      _attached = true;
    }
    return widget.child;
  }

  void _attach(BuildContext context) {
    // context から primaryScrollController を取得
    final primaryScrollController =
        PrimaryScrollController.maybeOf(Navigator.of(context).context) ??
            PrimaryScrollController.maybeOf(context);
    if (primaryScrollController == null) return;

    // 偽の ScrollPosition（animateTo をオーバーライドしたもの） を primaryScrollController に attach する
    final scrollPositionWithSingleContext =
        _FakeScrollPositionWithSingleContext(
      context: context,
      callback: widget.onTap,
    );

    primaryScrollController.attach(scrollPositionWithSingleContext);

    _primaryScrollController = primaryScrollController;
    _scrollPositionWithSingleContext = scrollPositionWithSingleContext;
  }
}

// ScrollPositionWithSingleContext を継承し，スクロールイベントをカスタム処理に転送するためのクラス
class _FakeScrollPositionWithSingleContext
    extends ScrollPositionWithSingleContext {
  _FakeScrollPositionWithSingleContext({
    required BuildContext context,
    required Future<void> Function() callback,
  })  : _callback = callback,
        super(
          physics: const NeverScrollableScrollPhysics(),
          context: _FakeScrollContext(context),
        );

  final Future<void> Function() _callback;

  // 受け取った callback が呼ばれるように animateTo をオーバーライド
  @override
  Future<void> animateTo(
    double to, {
    required Duration duration,
    required Curve curve,
  }) {
    return _callback.call();
  }
}

// 偽装クラス
class _FakeScrollContext extends ScrollContext {
  _FakeScrollContext(this._context);

  final BuildContext _context;

  @override
  AxisDirection get axisDirection => AxisDirection.down;

  @override
  BuildContext get notificationContext => _context;

  @override
  void saveOffset(double offset) {}

  @override
  void setCanDrag(bool value) {}

  @override
  void setIgnorePointer(bool value) {}

  @override
  void setSemanticsActions(Set<SemanticsAction> actions) {}

  @override
  BuildContext get storageContext => _context;

  @override
  TickerProvider get vsync => _FakeTickerProvider();

  @override
  double get devicePixelRatio => MediaQuery.of(_context).devicePixelRatio;
}

// 偽装クラス
class _FakeTickerProvider extends TickerProvider {
  @override
  Ticker createTicker(TickerCallback onTick) {
    return Ticker(onTick);
  }
}
