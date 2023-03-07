class ClassName {
  static String getClassName(int i) {
    switch (i) {
      case 0:
        return "invalid_background";
        break;

      case 1:
        return "valid_front_CCCD";
        break;

      case 2:
        return "valid_back_CCCD";
        break;

      case 3:
        return "valid_front_CMND";
        break;
      case 4:
        return "valid_back_CMND";
        break;

      case 5:
        return "invalid_hand_cover_CCCD_front";
        break;

      case 6:
        return "invalid_hand_cover_CCCD_back";
        break;

      case 7:
        return "invalid_insert_text_paper_CCCD_front";
        break;

      case 8:
        return "invalid_insert_text_paper_CCCD_back";
        break;

      case 9:
        return "invalid_icon_CCCD_fron";
        break;

      case 10:
        return "invalid_icon_CCCD_back";
        break;

      case 11:
        return "invalid_device_CCCD";
        break;

      case 12:
        return "invalid_cut_edge_CCCD_front";
        break;

      case 13:
        return "invalid_cut_edge_CCCD_back";
        break;

      case 14:
        return "invalid_spotlight_CCCD_front";
        break;

      case 15:
        return "invalid_spotlight_CCCD_back";
        break;

      case 16:
        return "invalid_hand_cover_CMND_front";
        break;

      case 17:
        return "invalid_hand_cover_CMND_back";
        break;

      case 18:
        return "invalid_insert_text_paper_CMND_front";
        break;

      case 18:
        return "invalid_insert_text_paper_CMND_back";
        break;

      case 19:
        return "invalid_icon_CMND_front";
        break;

      case 20:
        return "invalid_icon_CMND_back";
        break;

      case 21:
        return "invalid_device_CMND";
        break;

      case 22:
        return "invalid_cut_edge_CMND_front";
        break;

      case 23:
        return "invalid_cut_edge_CMND_back";
        break;

      case 24:
        return "invalid_spotlight_CMND_front";
        break;

      case 25:
        return "invalid_spotlight_CMND_back";
        break;

      case 26:
        return "valid_front_chip";
        break;

      case 27:
        return "valid_back_chip";
        break;

      case 28:
        return "invalid_spotlight_CHIP_front";
        break;

      case 29:
        return "invalid_spotlight_CHIP_back";
        break;

      case 30:
        return "invalid_insert_text_paper_CHIP_front";
        break;

      case 31:
        return "invalid_insert_text_paper_CHIP_back";
        break;

      case 32:
        return "invalid_icon_CHIP_front";
        break;

      case 33:
        return "invalid_icon_CHIP_back";
        break;

      case 34:
        return "invalid_hand_cover_CHIP_front";
        break;

      case 35:
        return "invalid_hand_cover_CHIP_back";
        break;

      case 36:
        return "invalid_device_CHIP";
        break;

      case 37:
        return "invalid_cut_edge_CHIP_front";
        break;

      case 38:
        return "invalid_cut_edge_CHIP_back";
        break;

      case 39:
        return "valid_PASSPORT";
        break;

      default:
        return "invalid_background";
        break;
    }
  }
}

enum CardValidationClass {
  invalid_background,
  valid_front_CCCD,
  valid_back_CCCD,
  valid_front_CMND,
  valid_back_CMND,
  invalid_hand_cover_CCCD_front,
  invalid_hand_cover_CCCD_back,
  invalid_insert_text_paper_CCCD_front,
  invalid_insert_text_paper_CCCD_back,
  invalid_icon_CCCD_front,
  invalid_icon_CCCD_back,
  invalid_device_CCCD,
  invalid_cut_edge_CCCD_front,
  invalid_cut_edge_CCCD_back,
  invalid_spotlight_CCCD_front,
  invalid_spotlight_CCCD_back,
  invalid_hand_cover_CMND_front,
  invalid_hand_cover_CMND_back,
  invalid_insert_text_paper_CMND_front,
  invalid_insert_text_paper_CMND_back,
  invalid_icon_CMND_front,
  invalid_icon_CMND_back,
  invalid_device_CMND,
  invalid_cut_edge_CMND_front,
  invalid_cut_edge_CMND_back,
  invalid_spotlight_CMND_front,
  invalid_spotlight_CMND_back,
  valid_front_chip,
  valid_back_chip,
  invalid_spotlight_CHIP_front,
  invalid_spotlight_CHIP_back,
  invalid_insert_text_paper_CHIP_front,
  invalid_insert_text_paper_CHIP_back,
  invalid_icon_CHIP_front,
  invalid_icon_CHIP_back,
  invalid_hand_cover_CHIP_front,
  invalid_hand_cover_CHIP_back,
  invalid_device_CHIP,
  invalid_cut_edge_CHIP_front,
  invalid_cut_edge_CHIP_back,
  valid_PASSPORT,
}

extension CardValidationClassExt on CardValidationClass {
  String get message {
    switch (this) {
      case CardValidationClass.invalid_background:
        return "Hãy đặt thẻ bên trong khung chụp";
      case CardValidationClass.valid_front_CCCD:
        return "Mặt trước CCCD hợp lệ";
      case CardValidationClass.valid_front_CMND:
        return "Mặt trước CMND hợp lệ";
      case CardValidationClass.valid_front_chip:
        return "Mặt trước CCCD găn chíp hợp lệ";
      case CardValidationClass.valid_back_CCCD:
        return "Mặt sau CCCD hợp lệ";
      case CardValidationClass.valid_back_chip:
        return "Mặt sau CCCD găn chíp hợp lệ";
      case CardValidationClass.valid_back_CMND:
        return "Mặt sau CMND hợp lệ";
      case CardValidationClass.valid_PASSPORT:
        return "Hộ chiếu hợp lệ";
      case CardValidationClass.invalid_hand_cover_CCCD_front:
      case CardValidationClass.invalid_hand_cover_CCCD_back:
      case CardValidationClass.invalid_insert_text_paper_CCCD_front:
      case CardValidationClass.invalid_insert_text_paper_CCCD_back:
      case CardValidationClass.invalid_icon_CCCD_back:
      case CardValidationClass.invalid_spotlight_CCCD_front:
      case CardValidationClass.invalid_spotlight_CCCD_back:
      case CardValidationClass.invalid_spotlight_CMND_front:
      case CardValidationClass.invalid_spotlight_CMND_back:
      case CardValidationClass.invalid_hand_cover_CMND_front:
      case CardValidationClass.invalid_hand_cover_CMND_back:
      case CardValidationClass.invalid_insert_text_paper_CMND_front:
      case CardValidationClass.invalid_insert_text_paper_CMND_back:
      case CardValidationClass.invalid_icon_CMND_front:
      case CardValidationClass.invalid_icon_CMND_back:
      case CardValidationClass.invalid_spotlight_CHIP_front:
      case CardValidationClass.invalid_spotlight_CHIP_back:
      case CardValidationClass.invalid_insert_text_paper_CHIP_front:
      case CardValidationClass.invalid_insert_text_paper_CHIP_back:
      case CardValidationClass.invalid_icon_CHIP_front:
      case CardValidationClass.invalid_icon_CHIP_back:
      case CardValidationClass.invalid_hand_cover_CHIP_front:
      case CardValidationClass.invalid_hand_cover_CHIP_back:
        return "Tránh để thẻ bị chói sáng hoặc che khuất thông tin";
        break;
      case CardValidationClass.invalid_device_CCCD:
      case CardValidationClass.invalid_device_CMND:
      case CardValidationClass.invalid_device_CHIP:
        return "Không sử dụng thẻ photo hoặc bị hư hại";
        break;
      case CardValidationClass.invalid_cut_edge_CMND_front:
      case CardValidationClass.invalid_cut_edge_CMND_back:
      case CardValidationClass.invalid_cut_edge_CCCD_front:
      case CardValidationClass.invalid_cut_edge_CCCD_back:
      case CardValidationClass.invalid_cut_edge_CHIP_front:
      case CardValidationClass.invalid_cut_edge_CHIP_back:
        return "Hãy đặt thẻ bên trong khung chụp";
        break;
      default:
        return "Không tồn tại";
    }
  }
}
