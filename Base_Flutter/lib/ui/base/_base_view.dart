import 'package:base_flutter/services/service_locator.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class BaseView<T extends ChangeNotifier> extends StatefulWidget {
  final Widget child;
  final Function(T model)? onModelReady;
  final Function(T model)? onModelDisposed;

  const BaseView(
      {Key? key,
      required this.child,
      this.onModelReady,
      this.onModelDisposed})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _BaseViewState<T> createState() => _BaseViewState<T>();
}

class _BaseViewState<T extends ChangeNotifier> extends State<BaseView<T>> {
  T model = locator<T>();

  @override
  void initState() {
    if (widget.onModelReady != null) {
      widget.onModelReady!(model);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<T>(
      create: (context) => model,
      child: widget.child,
    );
  }

  @override
  void dispose() {
    if (widget.onModelDisposed != null) {
      widget.onModelDisposed!(model);
    }
    super.dispose();
  }
}
