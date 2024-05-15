{
  pkgs,
  lib,
  config,
  ...
}: let
  mbsync = "${config.programs.mbsync.package}/bin/mbsync";
  pass = "${config.programs.password-store.package}/bin/pass";

  common = rec {
    realName = "Ronan Berntsen";
    gpg = {
      key = "951D 15D8 CAD6 AC62 A18B B0FD 9C77 AB4C 9FDE F882";
      signByDefault = true;
    };
    signature = {
      showSignature = "append";
      text = ''
        ---
        ${realName}

        Don't worry be happy :)
        PGP: ${gpg.key}
      '';
    };
  };
in {
  home.persistence = {
    "/nix/persist/home/mrhappy200".directories = ["Mail"];
  };

  accounts.email = {
    maildirBasePath = "Mail";
    accounts = {
      personal =
        rec {
          primary = true;
          address = "ronanberntsen@gmail.com";
          passwordCommand = "${pass} ${smtp.host}/${address}";

          msmtp.enable = true;
          smtp.host = "smtp.gmail.com";
          userName = address;
        }
        // common;
    };
  };

  programs.mbsync.enable = true;
  programs.msmtp.enable = true;

  systemd.user.services.mbsync = {
    Unit = {Description = "mbsync synchronization";};
    Service = let
      gpgCmds = import ../cli/gpg-commands.nix {inherit pkgs;};
    in {
      Type = "oneshot";
      ExecCondition = ''
        /bin/sh -c "${gpgCmds.isUnlocked}"
      '';
      ExecStart = "${mbsync} -a";
    };
  };
  systemd.user.timers.mbsync = {
    Unit = {Description = "Automatic mbsync synchronization";};
    Timer = {
      OnBootSec = "30";
      OnUnitActiveSec = "5m";
    };
    Install = {WantedBy = ["timers.target"];};
  };
}
