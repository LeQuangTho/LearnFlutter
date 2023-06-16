#include "include/f_plugin/f_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "f_plugin.h"

void FPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  f_plugin::FPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
