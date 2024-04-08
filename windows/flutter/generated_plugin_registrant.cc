//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <at_file_saver/file_saver_plugin.h>
#include <desktop_window/desktop_window_plugin.h>
#include <fast_rsa/fast_rsa_plugin.h>
#include <file_selector_windows/file_selector_windows.h>
#include <geolocator_windows/geolocator_windows.h>
#include <permission_handler_windows/permission_handler_windows_plugin.h>
#include <share_plus/share_plus_windows_plugin_c_api.h>
#include <url_launcher_windows/url_launcher_windows.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  FileSaverPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("FileSaverPlugin"));
  DesktopWindowPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("DesktopWindowPlugin"));
  FastRsaPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("FastRsaPlugin"));
  FileSelectorWindowsRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("FileSelectorWindows"));
  GeolocatorWindowsRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("GeolocatorWindows"));
  PermissionHandlerWindowsPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("PermissionHandlerWindowsPlugin"));
  SharePlusWindowsPluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("SharePlusWindowsPluginCApi"));
  UrlLauncherWindowsRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("UrlLauncherWindows"));
}
