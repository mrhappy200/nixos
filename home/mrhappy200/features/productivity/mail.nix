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
      key = "89F5 591E A4E6 3506 1169  53BF 3AF8 AF8C 2C5E C2EC";
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
          address = "ronan@hppy200.dev";
          passwordCommand = "${pass} ${smtp.host}/${address}";

          imap.host = "blizzard.mxrouting.net";

          mbsync = {
            enable = true;
            create = "maildir";
            expunge = "both";
          };

          folders = {
            inbox = "Inbox";
            drafts = "Drafts";
            sent = "Sent";
            trash = "Trash";
          };
          neomutt = {
            enable = true;
            extraMailboxes = ["Drafts" "Junk" "Sent" "Trash"];
          };

          msmtp.enable = true;
          smtp.host = "blizzard.mxrouting.net";
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

  # Run 'createMaildir' after 'linkGeneration'
  home.activation = let
    mbsyncAccounts =
      lib.filter (a: a.mbsync.enable)
      (lib.attrValues config.accounts.email.accounts);
  in
    lib.mkIf (mbsyncAccounts != []) {
      createMaildir = lib.mkForce (lib.hm.dag.entryAfter ["linkGeneration"] ''
        run mkdir -m700 -p $VERBOSE_ARG ${
          lib.concatMapStringsSep " " (a: a.maildir.absPath) mbsyncAccounts
        }
      '');
    };
}
