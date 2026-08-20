{ inputs, pkgs, ... }:
let
  xrizer-multilib =
    let
      pkg = inputs.nixpkgs-xr.packages.${pkgs.stdenv.hostPlatform.system}.xrizer;
    in
    pkgs.symlinkJoin {
      name = "xrizer-multilib";
      paths =
        let
          attrs = {
            # Remove patch when https://github.com/Supreeeme/xrizer/issues/358 gets closed
            patches = [ ./fix-xrizer.diff ];
            postInstall = ''
              mkdir -p $out/lib/xrizer/$platformPath
              mv "$out/lib/libxrizer.so" "$out/lib/xrizer/$platformPath/vrclient.so"
            '';
          };
        in
        [
          (pkg.overrideAttrs attrs)
          ((pkgs.pkgsi686Linux.callPackage pkg.override { }).overrideAttrs attrs)
        ];
    };
  wivrn-custom =
    (pkgs.wivrn.override {
      xrizer = xrizer-multilib;
    }).overrideAttrs
      (oldAttrs: {
        monado = pkgs.applyPatches {
          src = pkgs.monado.src; # Replace with pkgs.monado-git.src if targeting the git version
          inherit (oldAttrs.monado) patches;

          postPatch = (oldAttrs.monado.postPatch or "") + ''
            sed -i '1s/^/#ifndef MAX\n#define MAX(a,b) (((a) > (b)) ? (a) : (b))\n#endif\n/' src/xrt/compositor/multi/comp_multi_system.c
          '';
        };
        postUnpack =
          builtins.replaceStrings [ "return 1" ] [ "echo 'Bypassing Monado commit hash check'" ]
            (oldAttrs.postUnpack or "");
      });
in
{
  services.wivrn = {
    enable = true;
    package = wivrn-custom;
    openFirewall = true;

    # Run WiVRn as a systemd service on startup
    autoStart = true;
    highPriority = true;

    steam.enable = true;
    steam.importOXRRuntimes = true;

    # You should use the default configuration (which is no configuration), as that works the best out of the box.
    # However, if you need to configure something see https://github.com/WiVRn/WiVRn/blob/master/docs/configuration.md for configuration options and https://mynixos.com/nixpkgs/option/services.wivrn.config.json for an example configuration.
  };
  programs.steam = {
    enable = true;
    package = pkgs.steam.override {
      extraProfile = ''
        # Allows Monado/WiVRn to be used
        export PRESSURE_VESSEL_IMPORT_OPENXR_1_RUNTIMES=1
        # Fixes timezones on VRChat
        unset TZ
      '';
    };
  };
  boot.kernelPatches = [
    {
      name = "amdgpu-ignore-ctx-privileges";
      patch = pkgs.fetchpatch {
        name = "cap_sys_nice_begone.patch";
        url = "https://github.com/Frogging-Family/community-patches/raw/master/linux61-tkg/cap_sys_nice_begone.mypatch";
        hash = "sha256-Y3a0+x2xvHsfLax/uwycdJf3xLxvVfkfDVqjkxNaYEo=";
      };
    }
  ];
}
