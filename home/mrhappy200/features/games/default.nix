{pkgs, ...}: {
  imports = [
    #    ./lutris.nix
    ./prism-launcher.nix
  ];
  home = {
    packages = with pkgs; [gamescope];
    persistence = {
      "/nix/persist/home/mrhappy200" = {
        allowOther = true;
        directories = [
          {
            # Use symlink, as games may be IO-heavy
            directory = "Games";
            method = "symlink";
          }
        ];
      };
    };
  };
}
