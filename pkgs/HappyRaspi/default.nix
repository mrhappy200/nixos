{inputs, ...}: {
  HappyRaspi = inputs.nixos-generators.nixosGenerate {
    system = "aarch64-linux";
    format = "sd-aarch64";
    modules = [
      ./hosts/HappyRaspi
    ];
  };
}
