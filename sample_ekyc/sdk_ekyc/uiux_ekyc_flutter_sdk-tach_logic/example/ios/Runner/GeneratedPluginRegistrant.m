//
//  Generated file. Do not edit.
//

// clang-format off

#import "GeneratedPluginRegistrant.h"

#if __has_include(<camera/CameraPlugin.h>)
#import <camera/CameraPlugin.h>
#else
@import camera;
#endif

#if __has_include(<ekyc_flutter_sdk/EkycFlutterSdkPlugin.h>)
#import <ekyc_flutter_sdk/EkycFlutterSdkPlugin.h>
#else
@import ekyc_flutter_sdk;
#endif

#if __has_include(<path_provider_ios/FLTPathProviderPlugin.h>)
#import <path_provider_ios/FLTPathProviderPlugin.h>
#else
@import path_provider_ios;
#endif

#if __has_include(<tflite_flutter/TfliteFlutterPlugin.h>)
#import <tflite_flutter/TfliteFlutterPlugin.h>
#else
@import tflite_flutter;
#endif

#if __has_include(<uiux_ekyc_flutter_sdk/UiuxEkycFlutterSdkPlugin.h>)
#import <uiux_ekyc_flutter_sdk/UiuxEkycFlutterSdkPlugin.h>
#else
@import uiux_ekyc_flutter_sdk;
#endif

#if __has_include(<video_player_avfoundation/FLTVideoPlayerPlugin.h>)
#import <video_player_avfoundation/FLTVideoPlayerPlugin.h>
#else
@import video_player_avfoundation;
#endif

@implementation GeneratedPluginRegistrant

+ (void)registerWithRegistry:(NSObject<FlutterPluginRegistry>*)registry {
  [CameraPlugin registerWithRegistrar:[registry registrarForPlugin:@"CameraPlugin"]];
  [EkycFlutterSdkPlugin registerWithRegistrar:[registry registrarForPlugin:@"EkycFlutterSdkPlugin"]];
  [FLTPathProviderPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTPathProviderPlugin"]];
  [TfliteFlutterPlugin registerWithRegistrar:[registry registrarForPlugin:@"TfliteFlutterPlugin"]];
  [UiuxEkycFlutterSdkPlugin registerWithRegistrar:[registry registrarForPlugin:@"UiuxEkycFlutterSdkPlugin"]];
  [FLTVideoPlayerPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTVideoPlayerPlugin"]];
}

@end
