import './dan_toc.dart';
import './id_model.dart';
import './ho_ten.dart';
import './ngay_sinh.dart';
import './gioi_tinh.dart';
import './quoc_tich.dart';
import './nguyen_quan.dart';
import './ho_khau_thuong_tru.dart';
import './ngay_het_han.dart';
import './class_name.dart';
import './liveness.dart';

class Result {
  Id? id;

  Id? passportMrz;
  Id? loaiHoChieu;
  Id? passportNo;

  HoTen? hoTen;
  NgaySinh? ngaySinh;
  GioiTinh? gioiTinh;
  QuocTich? quocTich;
  NguyenQuan? nguyenQuan;
  HoKhauThuongTru? hoKhauThuongTru;
  NgayHetHan? ngayHetHan;
  DanToc? danToc;
  ClassName? className;
  Liveness? liveness;

  Result(
      {this.id,
      this.hoTen,
      this.ngaySinh,
      this.gioiTinh,
      this.quocTich,
      this.nguyenQuan,
      this.hoKhauThuongTru,
      this.ngayHetHan,
      this.danToc,
      this.className,
      this.liveness});

  Result.fromJson(Map<String, dynamic> json) {
    id = json['id'] != null ? Id.fromJson(json['id']) : null;
    passportMrz = json['passport_mrz'] != null ? Id.fromJson(json['id']) : null;
    loaiHoChieu =
        json['loai_ho_chieu'] != null ? Id.fromJson(json['id']) : null;
    passportNo = json['passport_no'] != null ? Id.fromJson(json['id']) : null;
    hoTen = json['ho_ten'] != null ? HoTen.fromJson(json['ho_ten']) : null;
    ngaySinh =
        json['ngay_sinh'] != null ? NgaySinh.fromJson(json['ngay_sinh']) : null;
    gioiTinh =
        json['gioi_tinh'] != null ? GioiTinh.fromJson(json['gioi_tinh']) : null;
    quocTich =
        json['quoc_tich'] != null ? QuocTich.fromJson(json['quoc_tich']) : null;
    nguyenQuan = json['nguyen_quan'] != null
        ? NguyenQuan.fromJson(json['nguyen_quan'])
        : null;
    hoKhauThuongTru = json['ho_khau_thuong_tru'] != null
        ? HoKhauThuongTru.fromJson(json['ho_khau_thuong_tru'])
        : null;
    ngayHetHan = json['ngay_het_han'] != null
        ? NgayHetHan.fromJson(json['ngay_het_han'])
        : null;
    danToc = json['dan_toc'] != null ? DanToc.fromJson(json['dan_toc']) : null;
    className = json['class_name'] != null
        ? ClassName.fromJson(json['class_name'])
        : null;
    liveness =
        json['liveness'] != null ? Liveness.fromJson(json['liveness']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.id != null) {
      data['id'] = this.id!.toJson();
    }
    if (this.hoTen != null) {
      data['ho_ten'] = this.hoTen!.toJson();
    }
    if (this.ngaySinh != null) {
      data['ngay_sinh'] = this.ngaySinh!.toJson();
    }
    if (this.gioiTinh != null) {
      data['gioi_tinh'] = this.gioiTinh!.toJson();
    }
    if (this.quocTich != null) {
      data['quoc_tich'] = this.quocTich!.toJson();
    }
    if (this.nguyenQuan != null) {
      data['nguyen_quan'] = this.nguyenQuan!.toJson();
    }
    if (this.hoKhauThuongTru != null) {
      data['ho_khau_thuong_tru'] = this.hoKhauThuongTru!.toJson();
    }
    if (this.ngayHetHan != null) {
      data['ngay_het_han'] = this.ngayHetHan!.toJson();
    }
    if (this.danToc != null) {
      data['dan_toc'] = this.danToc!.toJson();
    }
    if (this.className != null) {
      data['class_name'] = this.className!.toJson();
    }
    if (this.liveness != null) {
      data['liveness'] = this.liveness!.toJson();
    }
    return data;
  }
}
