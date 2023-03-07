String getMessageFromErrorCode(String? error_code) {
  if (error_code == null) {
    return "Lỗi không xác định";
  }
  switch (error_code) {
    case "SUCCESS":
      return "Thành công";
    case "E000":
      return "Không có khuôn mặt trong cả ảnh GTTT và ảnh chụp chân dung";
    case "E100":
      return "Không có ảnh input đầu vào (ảnh GTTT hoặc ảnh chân dung)";
    case "E109":
      return "Không có ảnh input đầu vào (Video chân dung hoặc ảnh chân dung)";
    case "E150":
      return "Input format của ảnh phải thuộc PNG, JPG or JPEG";
    case "E151":
      return "Input format của video phải thuộc MP4, MOV, AVI, MPEG, MKV, VMV, MPG";
    case "E014":
      return "Không có Session ID (Trong trường hợp API cần session_id)";
    case "E016":
      return "Không tìm thấy user_id (Trong trường hợp API cần user_id)";
    case "E028":
      return "user_id này đã được migrate trước đó, không thể migrate nữa";
    case "E020":
      return "Không có đầu vào Embed, trong trường hợp search face/video bằng embedding";
    case "E023":
      return "Request ID không được truyền vào, trong trường hợp cần Request ID trong API";
    case "E025":
      return "Request ID này không tồn tại trong hệ thống";
    case "E026":
      return "Độ dài Request ID cần ngắn hơn 41 ký tự";
    case "E021":
      return "Request ID này đã được sử dụng, vui lòng sử dụng Request ID khác";
    case "E856":
      return "User này đã được migrate, vui lòng sử dụng force_replace = true nếu cần thay thế";
    case "E022":
      return "Trong trường hợp xóa User, không được nhập user_id = UNK";
    case "E116":
      return "Input không được None";
    case "E326":
      return "Customer chưa thực hiện thành công eKYC, chưa verify được";
    case "E019":
      return "Không tìm thấy Session ID";
    case "E027":
      return "Json gửi lên không đúng định dạng";
    case "E002":
      return "Không xuất hiện mặt trước thẻ trong ảnh";
    case "E010":
      return "Không đăng ký thẻ với session_id đầu vào";
    case "E011":
      return "Không đăng ký khuôn mặt với session_id đầu vào";
    case "E015":
      return "Không tồn tại khách hàng tương ứng với session_id";
    case "E012":
      return "Không tìm thấy người dùng";
    case "E017":
      return "Người dùng không tồn tại, và session_id không được nhập";
    case "E103":
      return "Upload ảnh chân dung nhưng cần là GTTT";
    case "E040":
      return "Lần đăng ký mặt trước thất bại, nhưng đang cố đăng ký mặt sau, yêu cầu đăng ký lại mặt trước";
    case "ERROR":
      return "Không thành công";
    case "E212":
      return "Liveness Card fail vì sử dụng ảnh bị chụp cắt góc mặt sau";
    case "E213":
      return "Liveness Card fail vì sử dụng ảnh bị cắt lẹm vào cạnh mặt sau";
    case "E214":
      return "Liveness Card fail vì sử dụng ảnh bị cắt góc mặt trước";
    case "E215":
      return "Liveness Card fail vì sử dụng ảnh bị cắt lẹm vào cạnh mặt trước";
    case "E201":
      return "Liveness Card fail vì bị cắt một phần cạnh sau";
    case "E202":
      return "Liveness Card fail vì bị cắt một phần cạnh trước";
    case "E203":
      return "Liveness Card fail vì bị cắt một nửa";
    case "E217":
      return "Liveness Thẻ không thành công, có tay chèn vào quá sâu";
    case "E218":
      return "Liveness Thẻ không thành công, thẻ chụp quá lóa";
    case "E206":
      return "Liveness Card fail vì sử dụng ảnh template";
    case "E211":
      return "Liveness Card fail vì sử dụng ảnh template mặt trước";
    case "E315":
      return "Thẻ đăng ký vào không thuộc các loại thẻ được hỗ trợ";
    case "E216":
      return "Liveness Card fail vì sử dụng ảnh background";
    case "E210":
      return "Ảnh GTTT được chụp từ thiết bị thứ 3";
    case "E210":
      return "Liveness Card fail vì sử dụng ảnh chụp trên thiết bị khác";
    case "E204":
      return "Liveness Card fail vì sử dụng ảnh Photo";
    case "E205":
      return "Liveness Card fail vì sử dụng ảnh bị chói, che, viết, tay đè lên che mất thông tin cần đọc";
    case "E207":
      return "Liveness Card fail vì sử dụng ảnh in màu";
    case "E008":
      return "Không xuất hiện khuôn mặt trên GTTT";
    case "E316":
      return "Thẻ mặt sau đăng ký không cùng loại với thẻ mặt trước";
    case "E901":
      return "Khuôn mặt trên GTTT và khuôn mặt trên ảnh chân dung khớp";
    case "E902":
      return "Khuôn mặt trên GTTT và khuôn mặt trên ảnh chân dung không khớp";
    case "E200":
      return "Liveness Card fail vì có nhiều mặt trên thẻ";
    case "E998":
      return "Liveness Thẻ không thành công";
    case "E854":
      return "Card đã tồn tại, không được đăng ký";
    case "E222":
      return "Không match thông tin nơi cấp giữa mặt sau và mặt trước";
    case "E853":
      return "Thẻ GTTT đã tồn tại, nếu muốn đăng ký tiếp (Replace) thì vui lòng thêm tham số force_replace = True trong Form Data";
    case "E851":
      return "Đã có khuôn mặt đăng ký với Session ID này, nếu muốn đăng ký tiếp (Replace) thì vui lòng thêm tham số force_replace = True trong Form Data";
    case "E102":
      return "Ảnh chụp GTTT bị mờ, vui lòng chụp lại";
    case "E013":
      return "Không xuất hiện thẻ trong ảnh";
    case "E018":
      return "Không có input ảnh GTTT";
    case "E903":
      return "Hai ảnh chân dung khớp với nhau";
    case "E909":
      return "Ảnh đăng ký không khớp với ảnh quá khứ đã đăng ký";
    case "E904":
      return "Hai ảnh chân dung không khớp với nhau";
    case "E850":
      return "Khuôn mặt đã tồn tại, không thể đăng ký tiếp";
    case "E306":
      return "Khuôn mặt đăng ký giống với khuôn mặt đã đăng ký trong quá khứ";
    case "E115":
      return "Khuôn mặt đăng ký giống với khuôn mặt đã đăng ký trong quá khứ";
    case "E852":
      return "Video chân dung đã được đăng ký với Session_ID này, nếu muốn đăng ký tiếp (Replace) thì vui lòng thêm tham số force_replace = True trong Form Data";
    case "E308":
      return "Tay xuất hiện trên mặt";
    case "E319":
      return "Mặt bị che";
    case "E303":
      return "Ảnh chân dung không hợp lệ do đeo kính râm";
    case "E301":
      return "Ảnh chân dung không hợp lệ do có vật cản (Khẩu trang, vv) che mặt";
    case "E300":
      return "Ảnh chân dung không hợp lệ do có icon trên mặt";
    case "E314":
      return "Ảnh video chất lượng kém, do mờ, nhòe, tối, vv";
    case "E001":
      return "Không xuất hiện khuôn mặt trên ảnh chụp chân dung";
    case "E101":
      return "Không nhập đầu vào ảnh chân dung";
    case "E105":
      return "Không nhập input là video chân dung";
    case "E814":
      return "Video format có vấn đề, cần check lại vì không đọc được";
    case "E813":
      return "Không xuất hiện khuôn mặt trong video chân dung";
    case "E309":
      return "Không có mặt trong video";
    case "E305":
      return "Ảnh chân dung không hợp lệ do mặt trong ảnh bị cắt";
    case "E304":
      return "Ảnh mặt chân dung không hợp lệ do có kích thước nhỏ";
    case "E307":
      return "Có nhiều hơn 1 khuôn mặt trong ảnh/video";
    case "E313":
      return "Ảnh/Video không có mặt chính diện";
    case "E311":
      return "Mặt không hợp lệ do nhìn không thật - Deepfake";
    case "E302":
      return "Ảnh chân dung không hợp lệ do chụp qua thiết bị khác";
    case "E317":
      return "Mắt không được nhắm";
    case "E310":
      return "Mặt đăng ký hỏng do nhắm mắt";
    case "E312":
      return "Xảy ra khi hệ thống phát hiện có khả năng video đã qua chỉnh sửa, là video cut mặt hoặc chụp từ thiết bị khác";
    case "E997":
      return "Liveness Video không thành công";
    case "E996":
      return "Liveness khuôn mặt không thành công";
    case "S999":
      return "Liveness thành công";
    case "TIMEOUT":
      return "Liveness timeout";
    default:
      return "Lỗi không xác định";
  }
}
