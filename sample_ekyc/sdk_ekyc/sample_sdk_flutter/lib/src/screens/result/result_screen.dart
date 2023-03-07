import 'package:sample_sdk_flutter/src/components/custom_text_style.dart';
import 'package:sample_sdk_flutter/src/components/primary_appbar.dart';
import 'package:sample_sdk_flutter/src/components/primary_button.dart';
import 'package:sample_sdk_flutter/src/utils/app_config.dart';
import 'package:flutter/material.dart';
import 'package:sample_sdk_flutter/src/utils/native_service.dart';
import 'package:sample_sdk_flutter/src/constants.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({Key? key}) : super(key: key);

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  @override
  void initState() {
    super.initState();
    if (AppConfig().eKycSessionInfor.isValid) {
      if (AppConfig().sdkCallback != null) {
        AppConfig().sdkCallback!.ekycResult(
            true,
            true,
            "",
            "",
            AppConfig().eKycSessionInfor.matchingDetail,
            AppConfig().eKycSessionInfor.name,
            AppConfig().eKycSessionInfor.dateOfBirth,
            AppConfig().eKycSessionInfor.idNumber,
            AppConfig().eKycSessionInfor.placeOfOrigin,
            AppConfig().eKycSessionInfor.placeOfResidence,
            AppConfig().eKycSessionInfor.dateOfExpiry,
            AppConfig().eKycSessionInfor.dateOfIssue,
            AppConfig().eKycSessionInfor.sex,
            AppConfig().eKycSessionInfor.ethnicity,
            AppConfig().eKycSessionInfor.personalIdentification,
            AppConfig().eKycSessionInfor.nation,
        ''
        );
      }
    } else {
      if (AppConfig().sdkCallback != null) {
        AppConfig().sdkCallback!.ekycResult(true, false, "erro",
            "Ekyc thất bại", 0, "", "", "", "", "", "", "", "", "", "", "","");
      }
    }
  }

  BoxDecoration boxDecoration({
    double radius = 2,
    Color color = Colors.transparent,
    Color? bgColor,
    double borderWidth = 1,
    var showShadow = false,
  }) {
    return BoxDecoration(
      color: bgColor ?? Colors.black,
      boxShadow: [BoxShadow(color: Colors.transparent)],
      border: Border.all(color: color, width: borderWidth),
      borderRadius: BorderRadius.all(Radius.circular(radius)),
    );
  }

  Row rowHeading(var label) {
    return Row(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Text(label,
              style: TextStyle(
                  color: Colors.black, fontSize: 18, fontFamily: 'Bold'),
              textAlign: TextAlign.left),
        ),
      ],
    );
  }

  Divider view() {
    return Divider(color: kPrimaryTextColor, height: 0.5);
  }

  Widget renderTableRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 10, 0),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.2,
              child: Text(label,
                  style: TextStyle(
                      color: kPrimaryTextColor,
                      fontSize: 16,
                      fontFamily: 'Regular'),
                  textAlign: TextAlign.left),
            )),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 10, 0),
            child: Container(
              child: Text(value,
                  style: TextStyle(
                      color: kPrimaryTextColor,
                      fontSize: 16,
                      fontFamily: 'Regular'),
                  textAlign: TextAlign.left),
            ),
          ),
        ),
      ],
    );
  }

  TableRow tableRow(var label, var value) {
    return TableRow(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
          child: Text(label,
              style: TextStyle(
                  color: kPrimaryTextColor,
                  fontSize: 16,
                  fontFamily: 'Regular'),
              textAlign: TextAlign.left),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
          child: Text(value,
              style: TextStyle(
                  color: kPrimaryTextColor,
                  fontSize: 16,
                  fontFamily: 'Regular'),
              textAlign: TextAlign.left),
        ),
      ],
    );
  }

  Row profileText(String label, String value, {var maxline = 1}) {
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 10, 0),
          child: Text(label,
              style: TextStyle(
                  color: kPrimaryTextColor,
                  fontSize: 16,
                  fontFamily: 'Regular'),
              textAlign: TextAlign.left),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 10, 0),
          child: Text(value,
              style: TextStyle(
                  color: kPrimaryTextColor,
                  fontSize: 16,
                  fontFamily: 'Regular'),
              textAlign: TextAlign.left),
        ),
      ],
    );
  }

  int val = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PrimaryAppBar(
        appBar: AppBar(),
        text: "Xác nhận thông tin",
        iconColor: Colors.white,
      ),
      // body: true
      body: !AppConfig().eKycSessionInfor.isValid
          ? getFailedBody("EKYC thất bại")
          : Stack(
              fit: StackFit.expand,
              children: <Widget>[
                Align(
                  alignment: Alignment.topCenter,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Container(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text("Họ và tên",
                                          style: getCustomTextStyle(
                                              fontSize: 15,
                                              color: Color.fromARGB(
                                                  255, 143, 142, 142))),
                                      Text(
                                        AppConfig().eKycSessionInfor.name,
                                        style: getCustomTextStyle(
                                          fontSize: 15,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                const Divider(
                                  height: 20,
                                  color: Color.fromARGB(255, 170, 170, 170),
                                ),
                                const SizedBox(height: 10),
                                Container(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text("Ngày sinh",
                                          style: getCustomTextStyle(
                                              fontSize: 15,
                                              color: Color.fromARGB(
                                                  255, 143, 142, 142))),
                                      Text(
                                        AppConfig()
                                            .eKycSessionInfor
                                            .dateOfBirth,
                                        style: getCustomTextStyle(
                                          fontSize: 15,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                const Divider(
                                  height: 20,
                                  color: Color.fromARGB(255, 170, 170, 170),
                                ),
                                // const SizedBox(height: 10),
                                Container(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        "Giới tinh",
                                        style: getCustomTextStyle(
                                          fontSize: 15,
                                          color: Color.fromARGB(
                                              255, 143, 142, 142),
                                        ),
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Radio(
                                            autofocus: false,
                                            value: "Nam",
                                            groupValue: val,
                                            onChanged: (value) {},
                                          ),
                                          Text("Nam"),
                                          Radio(
                                            value: "Nữ",
                                            groupValue: val,
                                            onChanged: (value) {},
                                          ),
                                          Text("Nữ"),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                const Divider(
                                  height: 20,
                                  color: Color.fromARGB(255, 170, 170, 170),
                                ),
                                const SizedBox(height: 10),
                                Container(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text("Quốc tịch",
                                          style: getCustomTextStyle(
                                              fontSize: 15,
                                              color: Color.fromARGB(
                                                  255, 143, 142, 142))),
                                      Text(
                                        AppConfig().eKycSessionInfor.nation,
                                        style: getCustomTextStyle(
                                          fontSize: 15,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                const Divider(
                                  height: 20,
                                  color: Color.fromARGB(255, 170, 170, 170),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text("Số CMND/CCCD/Hộ chiếu",
                                          style: getCustomTextStyle(
                                              fontSize: 15,
                                              color: Color.fromARGB(
                                                  255, 143, 142, 142))),
                                      Text(
                                        AppConfig().eKycSessionInfor.idNumber,
                                        style: getCustomTextStyle(
                                          fontSize: 15,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                const Divider(
                                  height: 20,
                                  color: Color.fromARGB(255, 170, 170, 170),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        "Ngày cấp",
                                        style: getCustomTextStyle(
                                            fontSize: 15,
                                            color: Color.fromARGB(
                                                255, 143, 142, 142)),
                                      ),
                                      Text(
                                        AppConfig()
                                            .eKycSessionInfor
                                            .dateOfIssue,
                                        style: getCustomTextStyle(
                                          fontSize: 15,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                const Divider(
                                  height: 20,
                                  color: Color.fromARGB(255, 170, 170, 170),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text("Giá trị đến",
                                          style: getCustomTextStyle(
                                              fontSize: 15,
                                              color: Color.fromARGB(
                                                  255, 143, 142, 142))),
                                      Text(
                                        AppConfig()
                                            .eKycSessionInfor
                                            .dateOfExpiry,
                                        style: getCustomTextStyle(
                                          fontSize: 15,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                const Divider(
                                  height: 20,
                                  color: Color.fromARGB(255, 170, 170, 170),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        "Nơi cấp",
                                        style: getCustomTextStyle(
                                          fontSize: 15,
                                          color: Color.fromARGB(
                                              255, 143, 142, 142),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: Text(
                                          AppConfig().eKycSessionInfor.issuedAt,
                                          style: getCustomTextStyle(
                                            fontSize: 15,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                const Divider(
                                  height: 20,
                                  color: Color.fromARGB(255, 170, 170, 170),
                                  //
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Visibility(
                                  visible:
                                      !AppConfig().eKycSessionInfor.isPassport,
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text(
                                              "Nguyên quán",
                                              style: getCustomTextStyle(
                                                fontSize: 15,
                                                color: Color.fromARGB(
                                                    255, 143, 142, 142),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(
                                              child: Text(
                                                AppConfig()
                                                    .eKycSessionInfor
                                                    .placeOfOrigin,
                                                style: getCustomTextStyle(
                                                  fontSize: 15,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      const Divider(
                                        height: 20,
                                        color:
                                            Color.fromARGB(255, 170, 170, 170),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                ),
                                Visibility(
                                  visible:
                                      !AppConfig().eKycSessionInfor.isPassport,
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text(
                                              "Nơi thường trú",
                                              style: getCustomTextStyle(
                                                fontSize: 15,
                                                color: const Color.fromARGB(
                                                    255, 143, 142, 142),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(
                                              child: Text(
                                                AppConfig()
                                                    .eKycSessionInfor
                                                    .placeOfResidence,
                                                style: getCustomTextStyle(
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      const Divider(
                                        height: 20,
                                        color:
                                            Color.fromARGB(255, 170, 170, 170),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                ),
                                Visibility(
                                  visible:
                                      AppConfig().eKycSessionInfor.isPassport,
                                  child: Container(
                                    padding: EdgeInsets.only(top: 10),
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            "Nguyên quán",
                                            style: getCustomTextStyle(
                                                fontSize: 15),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          // ignore: prefer_const_constructors
                                          TextField(
                                            decoration: const InputDecoration(
                                              hintText: "Nhập nguyên quán",
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(8.0),
                                                ),
                                              ),
                                            ),
                                          )
                                        ]),
                                  ),
                                ),
                                Visibility(
                                  visible:
                                      AppConfig().eKycSessionInfor.isPassport,
                                  child: Container(
                                    padding: EdgeInsets.only(top: 20),
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            "Nơi thường trú",
                                            style: getCustomTextStyle(
                                                fontSize: 15),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          // ignore: prefer_const_constructors
                                          TextField(
                                            decoration: const InputDecoration(
                                              hintText: "Nhập nơi thường trú",
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(8.0),
                                                ),
                                              ),
                                            ),
                                          )
                                        ]),
                                  ),
                                ),
                                const SizedBox(
                                  height: 40,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFF5E9),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  height: 100,
                                  padding: EdgeInsets.all(8),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Image.asset(
                                            'assets/images/warning_icon.png',
                                            package: 'sample_sdk_flutter',
                                            width: 20),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: Text(
                                            "Mọi thông tin làm giấy tờ giả là vi phạm pháp luật. Khách hàng chịu hoàn toàn trách nhiệm về thông tin đã cung cấp",
                                            textAlign: TextAlign.left,
                                            style: getCustomTextStyle(
                                              fontSize: 15,
                                              color: kPrimaryOrange,
                                            ),
                                          ),
                                        )
                                      ]),
                                ),
                                const SizedBox(height: 40),
                                PrimaryButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pushNamedAndRemoveUntil(
                                            AppConfig().backRoute,
                                            (Route<dynamic> route) => false);
                                  },
                                  text: "Xác nhận",
                                  color: Colors.white,
                                  backgroundColor: kPrimaryColor,
                                  borderRadius: BorderRadius.circular(8),
                                  // fontWeight: FontWeight.bold,
                                ),
                                const SizedBox(height: 20)
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget inforItemContainer(String key, String vakue) {
    return Container();
  }

  Widget getFailedBody(String message) {
    return Stack(fit: StackFit.expand, children: <Widget>[
      Align(
        alignment: Alignment.topCenter,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
                    decoration: BoxDecoration(
                        border: Border.all(color: kPrimaryTextColor),
                        borderRadius: BorderRadius.circular(8.0)),
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          const SizedBox(height: 8),
                          SizedBox(
                            width: 80,
                            child: Image.asset(
                                "assets/images/result_falied.png",
                                package: 'sample_sdk_flutter'),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "Thất Bại",
                            style: TextStyle(
                                color: kPrimaryTextColor,
                                fontSize: 25,
                                fontFamily: 'Bold'),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              child: Image.asset("assets/images/result_failed_icon.png",
                  package: 'sample_sdk_flutter'),
            ),
            const SizedBox(height: 40),
            Padding(
              padding: EdgeInsets.fromLTRB(30, 8, 30, 8),
              child: Container(
                child: Text(
                  message,
                  style: TextStyle(
                    fontSize: 20,
                    color: kPrimaryTextColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
      Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: EdgeInsets.only(bottom: 50),
          child: PrimaryButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  AppConfig().backRoute, (Route<dynamic> route) => false);
            },
            text: "Thử lại",
            color: Colors.white,
            backgroundColor: kPrimaryColor,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    ]);
  }
}
