#import "SampleSdkFlutterPlugin.h"
#if __has_include(<sample_sdk_flutter/sample_sdk_flutter-Swift.h>)
#import <sample_sdk_flutter/sample_sdk_flutter-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "sample_sdk_flutter-Swift.h"
#endif

@implementation SampleSdkFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftSampleSdkFlutterPlugin registerWithRegistrar:registrar];
}
@end
