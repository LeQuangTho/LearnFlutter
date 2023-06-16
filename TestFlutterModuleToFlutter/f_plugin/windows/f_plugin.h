#ifndef FLUTTER_PLUGIN_F_PLUGIN_H_
#define FLUTTER_PLUGIN_F_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace f_plugin {

class FPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  FPlugin();

  virtual ~FPlugin();

  // Disallow copy and assign.
  FPlugin(const FPlugin&) = delete;
  FPlugin& operator=(const FPlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace f_plugin

#endif  // FLUTTER_PLUGIN_F_PLUGIN_H_
