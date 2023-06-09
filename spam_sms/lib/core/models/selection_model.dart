import 'package:get/get_rx/src/rx_types/rx_types.dart';

class SelectionModel<T> {
  final T value;
  RxBool selected = false.obs;

  SelectionModel({required this.value});
}
