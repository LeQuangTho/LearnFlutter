enum CardValidationClass {
  // invalid_background,
  // valid_front_CCCD,
  // valid_back_CCCD,
  // valid_front_CMND,
  // valid_back_CMND,
  // invalid_hand_cover_CCCD_front,
  // invalid_hand_cover_CCCD_back,
  // invalid_insert_text_paper_CCCD_front,
  // invalid_insert_text_paper_CCCD_back,
  // invalid_icon_CCCD_front,
  // invalid_icon_CCCD_back,
  // invalid_device_CCCD,
  // invalid_cut_edge_CCCD_front,
  // invalid_cut_edge_CCCD_back,
  // invalid_spotlight_CCCD_front,
  // invalid_spotlight_CCCD_back,
  // invalid_hand_cover_CMND_front,
  // invalid_hand_cover_CMND_back,
  // invalid_insert_text_paper_CMND_front,
  // invalid_insert_text_paper_CMND_back,
  // invalid_icon_CMND_front,
  // invalid_icon_CMND_back,
  // invalid_device_CMND,
  // invalid_cut_edge_CMND_front,
  // invalid_cut_edge_CMND_back,
  // invalid_spotlight_CMND_front,
  // invalid_spotlight_CMND_back,
  // valid_front_chip,
  // valid_back_chip,
  // invalid_spotlight_CHIP_front,
  // invalid_spotlight_CHIP_back,
  // invalid_insert_text_paper_CHIP_front,
  // invalid_insert_text_paper_CHIP_back,
  // invalid_icon_CHIP_front,
  // invalid_icon_CHIP_back,
  // invalid_hand_cover_CHIP_front,
  // invalid_hand_cover_CHIP_back,
  // invalid_device_CHIP,
  // invalid_cut_edge_CHIP_front,
  // invalid_cut_edge_CHIP_back,
  // valid_PASSPORT,

  invalid_background,

  // # Valid
  valid_front_CCCD,
  valid_back_CCCD,
  valid_front_CMND,
  valid_back_CMND,

  // # Invalid
  // # CCCD
  invalid_hand_cover_CCCD_front,
  invalid_hand_cover_CCCD_back,
  invalid_cut_edge_CCCD_front,
  invalid_cut_edge_CCCD_back,
  invalid_spotlight_CCCD_front,
  invalid_spotlight_CCCD_back,

  // # CMND
  invalid_hand_cover_CMND_front,
  invalid_hand_cover_CMND_back,
  invalid_cut_edge_CMND_front,
  invalid_cut_edge_CMND_back,
  invalid_spotlight_CMND_front,
  invalid_spotlight_CMND_back,

  valid_front_chip,
  valid_back_chip,
  invalid_spotlight_CHIP_front,
  invalid_spotlight_CHIP_back,
  invalid_hand_cover_CHIP_front,
  invalid_hand_cover_CHIP_back,
  invalid_cut_edge_CHIP_front,
  invalid_cut_edge_CHIP_back,

  // # PASSPORT
  valid_PASSPORT,

  invalid_SIDE
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
      // case CardValidationClass.invalid_insert_text_paper_CCCD_front:
      // case CardValidationClass.invalid_insert_text_paper_CCCD_back:
      // case CardValidationClass.invalid_icon_CCCD_back:
      case CardValidationClass.invalid_spotlight_CCCD_front:
      case CardValidationClass.invalid_spotlight_CCCD_back:
      case CardValidationClass.invalid_spotlight_CMND_front:
      case CardValidationClass.invalid_spotlight_CMND_back:
      case CardValidationClass.invalid_hand_cover_CMND_front:
      case CardValidationClass.invalid_hand_cover_CMND_back:
      // case CardValidationClass.invalid_insert_text_paper_CMND_front:
      // case CardValidationClass.invalid_insert_text_paper_CMND_back:
      // case CardValidationClass.invalid_icon_CMND_front:
      // case CardValidationClass.invalid_icon_CMND_back:
      case CardValidationClass.invalid_spotlight_CHIP_front:
      case CardValidationClass.invalid_spotlight_CHIP_back:
      // case CardValidationClass.invalid_insert_text_paper_CHIP_front:
      // case CardValidationClass.invalid_insert_text_paper_CHIP_back:
      // case CardValidationClass.invalid_icon_CHIP_front:
      // case CardValidationClass.invalid_icon_CHIP_back:
      case CardValidationClass.invalid_hand_cover_CHIP_front:
      case CardValidationClass.invalid_hand_cover_CHIP_back:
        return "Tránh để thẻ bị chói sáng hoặc che khuất thông tin";
        break;
      // case CardValidationClass.invalid_device_CCCD:
      // case CardValidationClass.invalid_device_CMND:
      // case CardValidationClass.invalid_device_CHIP:
      // return "Không sử dụng thẻ photo hoặc bị hư hại";
      // break;
      case CardValidationClass.invalid_cut_edge_CMND_front:
      case CardValidationClass.invalid_cut_edge_CMND_back:
      case CardValidationClass.invalid_cut_edge_CCCD_front:
      case CardValidationClass.invalid_cut_edge_CCCD_back:
      case CardValidationClass.invalid_cut_edge_CHIP_front:
      case CardValidationClass.invalid_cut_edge_CHIP_back:
        return "Hãy đặt thẻ bên trong khung chụp";
        break;
      case CardValidationClass.invalid_SIDE:
        return "Hãy sử dụng đúng mặt thẻ";
        break;
      default:
        return "Không tồn tại";
    }
  }
}
