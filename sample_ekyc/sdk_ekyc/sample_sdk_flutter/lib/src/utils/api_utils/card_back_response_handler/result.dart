import './di_hinh.dart';
import './ngay_cap.dart';
import './noi_cap.dart';
import './ho_ten.dart';
import './gioi_tinh.dart';
import './ngay_sinh.dart';
import './quoc_tich.dart';
import './ngay_het_han.dart';
import './id.dart';
import './class_name.dart';
import './liveness.dart';

class Result {
  DiHinh? diHinh;
  NgayCap? ngayCap;
  NoiCap? noiCap;
  HoTen? hoTen;
  NgaySinh? ngaySinh;
  GioiTinh? gioiTinh;
  QuocTich? quocTich;
  NgayHetHan? ngayHetHan;
  Id? id;
  ClassName? className;
  Liveness? liveness;

  Result(
      {this.diHinh,
      this.ngayCap,
      this.noiCap,
      this.hoTen,
      this.ngaySinh,
      this.gioiTinh,
      this.quocTich,
      this.ngayHetHan,
      this.id,
      this.className,
      this.liveness});

  Result.fromJson(Map<String, dynamic> json) {
    diHinh =
        json['di_hinh'] != null ? new DiHinh.fromJson(json['di_hinh']) : null;
    ngayCap = json['ngay_cap'] != null
        ? new NgayCap.fromJson(json['ngay_cap'])
        : null;
    noiCap =
        json['noi_cap'] != null ? new NoiCap.fromJson(json['noi_cap']) : null;
    hoTen = json['ho_ten'] != null ? new HoTen.fromJson(json['ho_ten']) : null;
    ngaySinh = json['ngay_sinh'] != null
        ? new NgaySinh.fromJson(json['ngay_sinh'])
        : null;
    gioiTinh = json['gioi_tinh'] != null
        ? new GioiTinh.fromJson(json['gioi_tinh'])
        : null;
    quocTich = json['quoc_tich'] != null
        ? new QuocTich.fromJson(json['quoc_tich'])
        : null;
    ngayHetHan = json['ngay_het_han'] != null
        ? new NgayHetHan.fromJson(json['ngay_het_han'])
        : null;
    id = json['id'] != null ? new Id.fromJson(json['id']) : null;
    className = json['class_name'] != null
        ? new ClassName.fromJson(json['class_name'])
        : null;
    liveness = json['liveness'] != null
        ? new Liveness.fromJson(json['liveness'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.diHinh != null) {
      data['di_hinh'] = this.diHinh!.toJson();
    }
    if (this.ngayCap != null) {
      data['ngay_cap'] = this.ngayCap!.toJson();
    }
    if (this.noiCap != null) {
      data['noi_cap'] = this.noiCap!.toJson();
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
    if (this.ngayHetHan != null) {
      data['ngay_het_han'] = this.ngayHetHan!.toJson();
    }
    if (this.id != null) {
      data['id'] = this.id!.toJson();
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
