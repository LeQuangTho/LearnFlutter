import 'package:base_flutter/ui/base/_base_model.dart';

class HomeModel extends BaseModel{
  int counter = 1;

  incrementCounter(){
    counter++;
    notifyListeners();
  }
}