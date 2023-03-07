import 'package:image/image.dart' as imglib;
import 'package:ekyc_flutter_sdk/src/utils/card_validation_result_handle.dart';

// abstract class CardValidationCallBack {
//   void takePicture(
//       imglib.Image? cardImage,
//       CardValidationClass? cardValidationClass,
//       bool cardValidationResult,
//       String message);
// }

typedef Future<void> CardValidationCallBack(
    imglib.Image? cardImage,
    imglib.Image? cropedCardImage,
    CardValidationClass? cardValidationClass,
    bool cardValidationResult,
    String message);
