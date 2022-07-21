import 'package:flutter/cupertino.dart';

class BlocBase {
  void dispose() {}
}

class BlocInherited<T extends BlocBase> extends InheritedWidget {
  final T bloc;

  const BlocInherited({Key? key, required this.bloc, required Widget child})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return oldWidget != this;
  }
}

class BlocHolder<T extends BlocBase> extends StatefulWidget {
  final Widget child;
  final T Function() blocBuilder;

  const BlocHolder({
    Key? key,
    required this.child,
    required this.blocBuilder,
  }) : super(key: key);

  @override
  _BlocHolderState createState() => _BlocHolderState<T>();

  static T? blocOf<T extends BlocBase>(BuildContext context) {
    return (context.getElementForInheritedWidgetOfExactType<BlocInherited<T>>()?.widget
            as BlocInherited<T>).bloc;
  }
}

class _BlocHolderState<T extends BlocBase> extends State<BlocHolder<T>> {
  late T _bloc;

  _BlocHolderState();

  @override
  void initState() {
    super.initState();
    _bloc = widget.blocBuilder();
  }

  @override
  Widget build(BuildContext context) {
    return BlocInherited<T>(bloc: _bloc, child: widget.child);
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }
}
