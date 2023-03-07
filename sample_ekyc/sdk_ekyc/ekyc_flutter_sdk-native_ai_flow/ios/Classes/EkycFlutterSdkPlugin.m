#import "EkycFlutterSdkPlugin.h"
#if __has_include(<ekyc_flutter_sdk/ekyc_flutter_sdk-Swift.h>)
#import <ekyc_flutter_sdk/ekyc_flutter_sdk-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "ekyc_flutter_sdk-Swift.h"
#endif

@implementation EkycFlutterSdkPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftEkycFlutterSdkPlugin registerWithRegistrar:registrar];
}
@end
