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

          imap.host = "imap.gmail.com";

          mbsync = {
            enable = true;
            create = "maildir";
            expunge = "both";
          };

          folders = {
            inbox = "\[Gmail\]/Inbox";
            drafts = "\[Gmail\]/Drafts";
            sent = "\[Gmail\]/Sent\ Mail";
            trash = "\[Gmail\]/Bin";
          };
          neomutt = {
            enable = true;
            extraMailboxes = [
              "[Gmail]/Drafts"
              "[Gmail]/Spam"
              "[Gmail]/Sent\ Mail"
              "[Gmail]/Bin"
            ];
          };

          msmtp.enable = true;
          smtp.host = "smtp.gmail.com";
          userName = address;
        }
        // common;

      school =
        rec {
          primary = false;
          address = "193763@gsf.nl";
          passwordCommand = "${pass} ${smtp.host}/${address}";

          imap.host = "imap.gmail.com";

          mbsync = {
            enable = true;
            create = "maildir";
            expunge = "both";
          };

          folders = {
            inbox = "\[Gmail\]/Inbox";
            drafts = "\[Gmail\]/Drafts";
            sent = "\[Gmail\]/Sent\ Mail";
            trash = "\[Gmail\]/Bin";
          };
          neomutt = {
            enable = true;
            extraMailboxes = [
              "[Gmail]/Drafts"
              "[Gmail]/Spam"
              "[Gmail]/Sent\ Mail"
              "[Gmail]/Bin"
            ];
          };

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

  # Run 'createMaildir' after 'linkGeneration'
  home.activation = let
    mbsyncAccounts = lib.filter (a: a.mbsync.enable) (lib.attrValues config.accounts.email.accounts);
  in
    lib.mkIf (mbsyncAccounts != []) {
      createMaildir = lib.mkForce (lib.hm.dag.entryAfter ["linkGeneration"] ''
        run mkdir -m700 -p $VERBOSE_ARG ${
          lib.concatMapStringsSep " " (a: a.maildir.absPath) mbsyncAccounts
        }
      '');
    };
}
