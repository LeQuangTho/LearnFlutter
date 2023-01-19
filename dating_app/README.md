# Dating App ❤️ 🇻🇳

[![wakatime](https://wakatime.com/badge/user/dbffe694-c211-47a5-82ed-ff362b1a7a4a/project/b84a69e5-3a93-4554-ac83-4cb81cc2a0b4.svg)](https://wakatime.com/badge/user/dbffe694-c211-47a5-82ed-ff362b1a7a4a/project/b84a69e5-3a93-4554-ac83-4cb81cc2a0b4) [![CodeFactor](https://www.codefactor.io/repository/github/toilathor/learnflutter/badge)](https://www.codefactor.io/repository/github/toilathor/learnflutter)

Dating là app do toilathor viết nên là tôi viết document bằng tiếng Việt luôn ôkéee...😄🚀️😕🎉️

Đây sẽ là project mang tính chất dựng base dự trên bloc.

Project này đang được viết trên **Flutter 3.3.9 • channel stable** - **Tools • Dart 2.18.5 • DevTools 2.15.0**

## Getting Started

Chưa có nội dung gì ở đây cả..

### [Firebase](https://firebase.flutter.dev/) 

![Firebase Flutter](https://firebase.flutter.dev/img/flutterfire_300x.png)

> Việc setup Firebase sẽ thuận tiện hơn nếu sử dụng MacOS. Setup trên Windowns thường phải khởi động
> lại máy ở một số bước không được nhắc tới trước nên sẽ có phần rắc rối hơn.

### [Screen Util](https://pub.dev/packages/flutter_screenutil)

> Đây là một thư viện giúp cho việc xác định kích thước dễ dàng hơn.
> nó bao gồm các tiện ích như: lấy hướng xoay, tự động scale theo size design, lấy kích thước theo %
> màn hình,...

### [GetIt](https://pub.dev/packages/get_it)

> Sử dụng GetIt nhằm mục đích quản lý  các **instance**

Nhìn chung sẽ chủ yếu sử dụng

1. **registerLazySingleton** để khởi tạo các class như 1 một cách global
2. **registerFactory** sẽ được khởi tạo lại từ đầu  khi gọi

### Build Runner ⚙️

#### Gen all project

```shell
flutter packages pub run build_runner build --delete-conflicting-outputs
```

#### [Gen Splash Screen](https://pub.dev/packages/flutter_native_splash) 📱

```shell
flutter pub run flutter_native_splash:create --path=native_splash.yaml
```

#### [Gen Icon App](https://pub.dev/packages/flutter_launcher_icons) 🫠

```shell
flutter pub get
flutter pub run flutter_launcher_icons:main
```

Sử dụng build_runner cho các mục đích như:

* Gen model ([json_serializable](https://pub.dev/packages/json_serializable))
* Gen Icon Launcher App ([flutter_launcher_icons](https://pub.dev/packages/flutter_launcher_icons))
* Gen asset trong project ([flutter_gen](https://pub.dev/packages/flutter_gen))
* Gen Splash screen ([flutter_native_splash](https://pub.dev/packages/flutter_native_splash))

### Tool

#### Dart Barrel File Generator

Sử dụng tool này để gom các file trong 1 folder lại để clean import

* Để cài đặt cho [Android Studio](https://plugins.jetbrains.com/plugin/18980-dart-barrel-file-generator)
* Để cài đặt cho [Visual Studio Code](https://marketplace.visualstudio.com/items?itemName=miquelddg.dart-barrel-file-generator&ssr=false#overview)

#### APP ICON GENERATOR

[IconKitchen](https://icon.kitchen)

Trang web này sẽ hỗ trợ chúng ta trong việc gen Icon Launcher App với đầy đử kích thước, hệ điều
hành,...

#### App marketing

[AppsFlyer](https://www.appsflyer.com)  ✈️

AppsFlyer sẽ giúp cho việc sử dụng deeplink hiệu quả hơn, và còn tính năng
khác mà Apps Flyer cung cấp

### Code Convention

Trong quá trình code cần hạn chế tối đa việc copy code, cần phân tích xem có những màn hình nào sử dụng chung,
các **Widget** sử dụng chung để có thể tách ra thành các component **common** để tái sử dụng lại . Điều này sẽ rất hữu ích
trong quá trình **maintenance**

<details>
<summary>Click to expand!</summary>

#### Naming convention:

Classes, enums, typedefs, và extensions nên được đặt tên với ký tự đầu mỗi từ được viết hoa:
Ex: UpperCamelCase

```none
class MainScreen { ... }
enum MainItem { .. }
typedef Predicate<T> = bool Function(T value);
extension MyList<T> on List<T> { ... }
```

Libraries, packages, directories, và source files thì nên viết thường và có dấu gạch dưới giữa 2 từ:
Ex: lowercase_with_underscores

```none
library firebase_dynamic_links;
import 'socket/socket_manager.dart';
```

Variables, constants, parameters, và named parameters sẽ tương tự như Class nhưng ký tự đầu tiên sẽ
viết thường : Ex: lowerCamelCase

```none
var item;
const bookPrice = 3.14;
final urlScheme = RegExp('^([a-z]+):');
void sum(int bookPrice) {
  // ...
}
```

#### relative imports for files in lib

Để tránh nhầm lẫn khi cùng một class được import bằng 2 cách khác nhau thì nên sử dụng relative
import

```none
// Don't
import 'package:demo/src/utils/dialog_utils.dart';


// Do
import '../../../utils/dialog_utils.dart';
```

#### Specify types for class member

Nhớ rằng luôn luôn khai báo kiểu của member nếu như kiểu của nó được xác định, hạn chế khai báo kiểu
var

```none

//Don't
var item = 10;
final car = Car();
const timeOut = 2000;


//Do
int item = 10;
final Car bar = Car();
String name = 'john';
const int timeOut = 20;
```

#### Avoid using as instead, use is operator

```none

//Don't
(item as Animal).name = 'Lion';


//Do
if (item is Animal)
  item.name = 'Lion';
```

#### Use if condition instead of conditional expression

Nếu gặp phải trường hợp cần render dựa vào một điều kiện nào đó thì nên sử dụng lệnh if thay cho
conditional expression

```none

//Don't
Widget getText(BuildContext context) {
  return Row(
    children: [
      Text("Hello"),
      Platform.isAndroid ? Text("Android") : null,
      Platform.isAndroid ? Text("Android") : SizeBox(),
      Platform.isAndroid ? Text("Android") : Container(),
    ]
  );
}


//Do
Widget getText(BuildContext context) {
  return Row(
      children: 
      [
        Text("Hello"), 
        if (Platform.isAndroid) Text("Android")
      ]
  );
}
```

#### Use ?? and ?. operators

```none
//Don't
v = a == null ? b : a;

//Do
v = a ?? b;


//Don't
v = a == null ? null : a.b;

//Do
v = a?.b;
```

#### Use spread collections

```none

//Don't
var y = [4,5,6];
var x = [1,2];
x.addAll(y);


//Do
var y = [4,5,6];
var x = [1,2,...y];
```

##### Use Cascades Operator

```none
// Don't
var path = Path();
path.lineTo(0, size.height);
path.lineTo(size.width, size.height);
path.lineTo(size.width, 0);
path.close();  


// Do
var path = Path()
..lineTo(0, size.height)
..lineTo(size.width, size.height)
..lineTo(size.width, 0)
..close(); 
```

#### Use raw string

Raw String được dùng khi trong string có chứa dấu gạch chéo hoặc ký tự $

```none
//Don't
var s = 'This is demo string \\ and \$';


//Do
var s = r'This is demo string \ and $';
```

#### Don’t explicitly initialize variables null

Mặc định khi khai báo không có value thì memeber sẽ mang giá trị null nên việc khai báo null là
không cần thiết

```none

//Don't
int _item = null;


//Do
int _item;
```

#### Use expression function bodies

```none
//Don't
get width {
  return right - left;
}
Widget getProgressBar() {
  return CircularProgressIndicator(
    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
  );
}


//Do
get width => right - left;
Widget getProgressBar() => CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
    );
```

#### Split widget into different Widgets.

Khi setState() called trong một state thì tất cả widget con sẽ rebuild nên ở đây chúng ta nên chia
nhỏ các widget và gọi setState trong mỗi widget đó để đảm bảo performance

```none
Scaffold(
  appBar: CustomAppBar(title: "Verify Code"), // Sub Widget
  body: Container(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TimerView( // Sub Widget
            key: _timerKey,
            resendClick: () {})
      ],
    ),
  ),
)
```

#### Use ListView.builder for a long list

#### Use Const in Widgets

```none
Container(
      padding: const EdgeInsets.only(top: 10),
      color: Colors.black,
      child: const Center(
        child: const Text(
          "No Data found",
          style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
        ),
      ),
    );
```

</details>
