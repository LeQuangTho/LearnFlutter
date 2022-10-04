#import "NextBlePlugin.h"
#if __has_include(<next_ble/next_ble-Swift.h>)
#import <next_ble/next_ble-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "next_ble-Swift.h"
#endif

@implementation NextBlePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftNextBlePlugin registerWithRegistrar:registrar];
}
@end
