{
  config,
  pkgs,
  lib,
  ...
}: let
  pass = "${config.programs.password-store.package}/bin/pass";
  oama = "${config.programs.oama.package}/bin/oama";
in {
  home.persistence = {
    "/persist/${config.home.homeDirectory}".directories = ["Calendars" "Contacts" ".local/share/vdirsyncer"];
  };

  accounts.calendar = {
    basePath = "Calendars";
    accounts = {
      personal = let
        emailCfg = config.accounts.email.accounts.personal;
      in {
        primary = true;
        primaryCollection = "Personal";
        khal = {
          enable = true;
          addresses = [emailCfg.address] ++ emailCfg.aliases;
          type = "discover";
        };
        remote = rec {
          type = "caldav";
          url = "https://dav.hppy200.dev";
          userName = emailCfg.address;
          passwordCommand = ["${pass}" "dav.hppy200.dev/${userName}"];
        };
        vdirsyncer = {
          enable = true;
          metadata = ["color" "displayname"];
          collections = ["from a" "from b"];
        };
      };
    };
  };

  programs.vdirsyncer.enable = true;
  services.vdirsyncer.enable = true;

  # Only run if gpg is unlocked
  systemd.user.services.vdirsyncer.Service = {
    ExecCondition = let
      gpgCmds = import ../cli/gpg-commands.nix {inherit pkgs config lib;};
    in ''
      /bin/sh -c "${gpgCmds.isUnlocked}"
    '';
    Restart = "on-failure";
    StartLimitBurst = 2;
    ExecStopPost = pkgs.writeShellScript "stop-post" ''
      # When it requires a discovery
      if [ "$SERVICE_RESULT" == "exit-code" ]; then
        ${lib.getExe config.services.vdirsyncer.package} discover --no-list
      fi
    '';
  };
}
