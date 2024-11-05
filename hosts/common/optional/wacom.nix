{ ... }:
let

in {
  services.input-remapper = {
    enable = true;
    enableUdevRules = true;
  };
}
