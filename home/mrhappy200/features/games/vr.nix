{
  lib,
  config,
  pkgs,
  ...
}:
let
  p = pkgs.pkgsi686Linux;
  patched-monado-32 = p.applyPatches {
    src = p.monado.src; # Replace with p.monado-git.src if targeting the git version
    inherit (p.monado) patches;

    postPatch = (p.monado.postPatch or "") + ''
      sed -i '1s/^/#ifndef MAX\n#define MAX(a,b) (((a) > (b)) ? (a) : (b))\n#endif\n/' src/xrt/compositor/multi/comp_multi_system.c
    '';
  };
  pkg = pkgs.pkgsi686Linux.wivrn.overrideAttrs (prev: {
    pname = "wivrn-server-lib";

    postUnpack =
      builtins.replaceStrings [ "return 1" ] [ "echo 'Bypassing Monado commit hash check'" ]
        (prev.postUnpack or "");
    nativeBuildInputs = with p; [
      cmake
      git
      glslang
      pkg-config
      python3
    ];

    buildInputs = with p; [
      boost
      eigen
      glm
      libdrm
      nlohmann_json
      openxr-loader
      udev
      vulkan-headers
      vulkan-loader
    ];

    desktopItems = [ ];

    cmakeFlags = [
      (lib.cmakeBool "WIVRN_BUILD_SERVER" false)
      (lib.cmakeBool "WIVRN_BUILD_WIVRNCTL" false)
      (lib.cmakeBool "WIVRN_BUILD_SERVER_LIBRARY" true)
      (lib.cmakeBool "FETCHCONTENT_FULLY_DISCONNECTED" true)
      (lib.cmakeFeature "WIVRN_OPENXR_MANIFEST_TYPE" "absolute")
      (lib.cmakeFeature "GIT_DESC" "v${prev.version}")
      (lib.cmakeFeature "GIT_COMMIT" "${prev.version}")
      (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_MONADO" "${patched-monado-32}")
    ];

    preFixup = "";
  });

  xrbinder = pkgs.xrbinder;

  xrbinderDefaultConfig = ''
    # UDP port for IPC
    serverPort = 9011
    # "bus" mode: runs ipc_server and serves both GUI and the XR app
    ipcMode = bus

    #[source.system_click]
    #actionType = action_bool
    #subactionOverride = /user/hand/right
    #bindings = /interaction_profiles/oculus/touch_controller:/user/hand/right/input/system/click
    #[source.system_click_float]
    #actionType = action_float
    #subactionOverride = /user/hand/right
    #bindings = /interaction_profiles/oculus/touch_controller:/user/hand/right/input/system/click
    #[source.x_click]
    #actionType = action_bool
    #bindings = /interaction_profiles/oculus/touch_controller:/user/hand/left/input/x/click
    #[source.x_click_float]
    #actionType = action_float
    #bindings = /interaction_profiles/oculus/touch_controller:/user/hand/left/input/x/click
    #[source.x_touch]
    #actionType = action_bool
    #bindings = /interaction_profiles/oculus/touch_controller:/user/hand/left/input/x/touch
    #[source.x_touch_float]
    #actionType = action_float
    #bindings = /interaction_profiles/oculus/touch_controller:/user/hand/left/input/x/touch
    #[source.y_click]
    #actionType = action_bool
    #bindings = /interaction_profiles/oculus/touch_controller:/user/hand/left/input/y/click
    #[source.y_click_float]
    #actionType = action_float
    #bindings = /interaction_profiles/oculus/touch_controller:/user/hand/left/input/y/click
    #[source.y_touch]
    #actionType = action_bool
    #bindings = /interaction_profiles/oculus/touch_controller:/user/hand/left/input/y/touch
    #[source.y_touch_float]
    #actionType = action_float
    #bindings = /interaction_profiles/oculus/touch_controller:/user/hand/left/input/y/touch
    #[source.trigger_touch]
    #actionType = action_bool
    #bindings = /interaction_profiles/oculus/touch_controller:/user/hand/left/input/trigger/touch,/interaction_profiles/oculus/touch_controller:/user/hand/right/input/trigger/touch
    #[source.trigger_touch_float]
    #actionType = action_float
    #bindings = /interaction_profiles/oculus/touch_controller:/user/hand/left/input/trigger/touch,/interaction_profiles/oculus/touch_controller:/user/hand/right/input/trigger/touch
    #[source.trigger_value]
    #actionType = action_float
    #bindings = /interaction_profiles/oculus/touch_controller:/user/hand/left/input/trigger/value,/interaction_profiles/oculus/touch_controller:/user/hand/right/input/trigger/value
    #[source.thumbstick_click]
    #actionType = action_bool
    #bindings = /interaction_profiles/oculus/touch_controller:/user/hand/left/input/thumbstick/click,/interaction_profiles/oculus/touch_controller:/user/hand/right/input/thumbstick/click
    #[source.thumbstick_click_float]
    #actionType = action_float
    #bindings = /interaction_profiles/oculus/touch_controller:/user/hand/left/input/thumbstick/click,/interaction_profiles/oculus/touch_controller:/user/hand/right/input/thumbstick/click
    #[source.thumbstick_touch]
    #actionType = action_bool
    #bindings = /interaction_profiles/oculus/touch_controller:/user/hand/left/input/thumbstick/touch,/interaction_profiles/oculus/touch_controller:/user/hand/right/input/thumbstick/touch
    #[source.thumbstick_touch_float]
    #actionType = action_float
    #bindings = /interaction_profiles/oculus/touch_controller:/user/hand/left/input/thumbstick/touch,/interaction_profiles/oculus/touch_controller:/user/hand/right/input/thumbstick/touch
    #[source.thumbstick_position]
    #actionType = action_vector2
    #bindings = /interaction_profiles/oculus/touch_controller:/user/hand/left/input/thumbstick,/interaction_profiles/oculus/touch_controller:/user/hand/right/input/thumbstick
    #[source.thumbstick_x]
    #actionType = action_float
    #bindings = /interaction_profiles/oculus/touch_controller:/user/hand/left/input/thumbstick/x,/interaction_profiles/oculus/touch_controller:/user/hand/right/input/thumbstick/x
    #[source.thumbstick_y]
    #actionType = action_float
    #bindings = /interaction_profiles/oculus/touch_controller:/user/hand/left/input/thumbstick/y,/interaction_profiles/oculus/touch_controller:/user/hand/right/input/thumbstick/y
    #[source.squeeze_value]
    #actionType = action_float
    #bindings = /interaction_profiles/oculus/touch_controller:/user/hand/left/input/squeeze/value,/interaction_profiles/oculus/touch_controller:/user/hand/right/input/squeeze/value
    #[source.thumbrest_touch]
    #actionType = action_bool
    #bindings = /interaction_profiles/oculus/touch_controller:/user/hand/left/input/thumbrest/touch,/interaction_profiles/oculus/touch_controller:/user/hand/right/input/thumbrest/touch
    #[source.thumbrest_touch_float]
    #actionType = action_float
    #bindings = /interaction_profiles/oculus/touch_controller:/user/hand/left/input/thumbrest/touch,/interaction_profiles/oculus/touch_controller:/user/hand/right/input/thumbrest/touch
    #[source.menu_click]
    #actionType = action_bool
    #bindings = /interaction_profiles/oculus/touch_controller:/user/hand/left/input/menu/click
    #[source.menu_click_float]
    #actionType = action_float
    #bindings = /interaction_profiles/oculus/touch_controller:/user/hand/left/input/menu/click
    #[source.a_click]
    #actionType = action_bool
    #subactionOverride = /user/hand/right
    #bindings = /interaction_profiles/oculus/touch_controller:/user/hand/right/input/a/click
    #[source.a_click_float]
    #actionType = action_float
    #subactionOverride = /user/hand/right
    #bindings = /interaction_profiles/oculus/touch_controller:/user/hand/right/input/a/click
    #[source.a_touch]
    #actionType = action_bool
    #subactionOverride = /user/hand/right
    #bindings = /interaction_profiles/oculus/touch_controller:/user/hand/right/input/a/touch
    #[source.a_touch_float]
    #actionType = action_float
    #subactionOverride = /user/hand/right
    #bindings = /interaction_profiles/oculus/touch_controller:/user/hand/right/input/a/touch
    #[source.b_click]
    #actionType = action_bool
    #subactionOverride = /user/hand/right
    #bindings = /interaction_profiles/oculus/touch_controller:/user/hand/right/input/b/click
    #[source.b_click_float]
    #actionType = action_float
    #subactionOverride = /user/hand/right
    #bindings = /interaction_profiles/oculus/touch_controller:/user/hand/right/input/b/click
    #[source.b_touch]
    #actionType = action_bool
    #subactionOverride = /user/hand/right
    #bindings = /interaction_profiles/oculus/touch_controller:/user/hand/right/input/b/touch
    #[source.b_touch_float]
    #actionType = action_float
    #subactionOverride = /user/hand/right
    #bindings = /interaction_profiles/oculus/touch_controller:/user/hand/right/input/b/touch
  '';

  xrbinderLayers = "${xrbinder}/share/openxr/1/api_layers";
  patchedManifest =
    pkgs.runCommand "xrbinder-manifest"
      {
        nativeBuildInputs = [ pkgs.jq ];
      }
      ''
        jq '.api_layer.library_path = "${xrbinderLayers}/libxrBinder_module.so"' \
          ${xrbinderLayers}/manifest.json > $out
      '';
in
{
  xdg.dataFile."openxr/1/api_layers/implicit.d/XR_APILAYER_NOVENDOR_xr_binder.json".source =
    patchedManifest;
  #xdg.dataFile."openxr/1/api_layers/implicit.d/XR_APILAYER_NOVENDOR_xr_binder.json".text =
  #  builtins.toJSON
  #    {
  #      file_format_version = "1.0.0";
  #      api_layer = {
  #        name = "XR_APILAYER_NOVENDOR_xr_binder";
  #        disable_environment = "DISABLE_XR_APILAYER_NOVENDOR_xr_binder";
  #        api_version = "1.0";
  #        implementation_version = "1";
  #        description = "Advanced layer for binding actions";
  #        library_path = "${xrbinderLayers}/libxrBinder_module.so";
  #      };
  #    };

  xdg.configFile."xrBinder/xrBinder.ini".text = xrbinderDefaultConfig;
  xdg.configFile."xrBinder/app_java.ini".text = xrbinderDefaultConfig;

  systemd.user.services.xrbinder-ipc = {
    Unit = {
      Description = "xrBinder IPC Server";
      Documentation = "https://gitlab.com/mittorn/xrBinder";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${xrbinderLayers}/ipc_server 9011";
      Restart = "on-failure";
      RestartSec = "3s";
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };

  home.packages = [
    (pkgs.writeShellScriptBin "xrbinder-gui" ''
      exec "${xrbinderLayers}/client_gui" "$@"
    '')
  ];
  xdg.configFile."openxr/1/active_runtime.i686.json".source =
    "${pkg}/share/openxr/1/openxr_wivrn.json";
}
