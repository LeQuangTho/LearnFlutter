//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <f_plugin/f_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) f_plugin_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "FPlugin");
  f_plugin_register_with_registrar(f_plugin_registrar);
}
