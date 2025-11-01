{
  pkgs,
  lib,
  config,
  ...
}:
let
  pass = "${config.programs.password-store.package}/bin/pass";
  oama = "${config.programs.oama.package}/bin/oama";

  common = rec {
    realName = "Ronan Berntsen";
    gpg = {
      key = "89F5 591E A4E6 3506 1169  53BF 3AF8 AF8C 2C5E C2EC";
      signByDefault = true;
    };
    signature = {
      showSignature = "append";
      text = ''
        ${realName}

        PGP: ${gpg.key}
      '';
    };
  };

  gmail_channels = {
    Inbox = {
      farPattern = "INBOX";
      nearPattern = "Inbox";
      extraConfig = {
        Create = "Near";
        Expunge = "Both";
      };
    };
    Archive = {
      farPattern = "Archived Mail";
      nearPattern = "Archive";
      extraConfig = {
        Create = "Both";
        Expunge = "Both";
      };
    };
    Junk = {
      farPattern = "[Gmail]/Spam";
      nearPattern = "Junk";
      extraConfig = {
        Create = "Near";
        Expunge = "Both";
      };
    };
    Trash = {
      farPattern = "[Gmail]/Trash";
      nearPattern = "Trash";
      extraConfig = {
        Create = "Near";
        Expunge = "Both";
      };
    };
    Drafts = {
      farPattern = "[Gmail]/Drafts";
      nearPattern = "Drafts";
      extraConfig = {
        Create = "Near";
        Expunge = "Both";
      };
    };
    Sent = {
      farPattern = "[Gmail]/Sent Mail";
      nearPattern = "Sent";
      extraConfig = {
        Create = "Near";
        Expunge = "Both";
      };
    };
  };
in
{
  home.persistence = {
    "/persist/${config.home.homeDirectory}".directories = [ "Mail" ];
  };

  accounts.email = {
    maildirBasePath = "Mail";
    accounts = {
      personal = rec {
        primary = true;
        address = "ronan@hppy200.dev";
        aliases = [ ];
        userName = address;
        passwordCommand = "${pass} ${smtp.host}/${address}";

        imap.host = "blizzard.mxrouting.net";
        mbsync = {
          enable = true;
          create = "maildir";
          expunge = "both";
        };
        neomutt = {
          enable = true;
          mailboxName = "=== Personal ===";
          extraMailboxes = [
            "Archive"
            "Drafts"
            "Inbox/spam"
            "Sent"
            "Trash"
          ];
        };

        msmtp.enable = true;
        smtp.host = "blizzard.mxrouting.net";
      }
      // common;
      personalGmail = rec {
        address = "ronanberntsen@gmail.com";
        userName = address;
        passwordCommand = "${oama} access ${address}";
        flavor = "gmail.com";

        mbsync = {
          enable = true;
          create = "maildir";
          expunge = "both";
          groups.personalGmail.channels = gmail_channels;
          extraConfig.account.AuthMechs = "XOAUTH2";
        };
        neomutt = {
          enable = true;
          mailboxName = "=== GMAIL ===";
          extraMailboxes = [
            "Archive"
            "Drafts"
            "Junk"
            "Sent"
            "Trash"
          ];
          # Gmail already stores a copy
          extraConfig = ''
            set copy = no
          '';
        };

        msmtp = {
          extraConfig.auth = "oauthbearer";
          enable = true;
        };
      }
      // common;
    };
  };

  programs.msmtp.enable = true;
  programs.mbsync = {
    enable = true;
    package = pkgs.isync.override { withCyrusSaslXoauth2 = true; };
  };

  services.mbsync = {
    enable = true;
    package = config.programs.mbsync.package;
  };

  # Only run if gpg is unlocked
  systemd.user.services.mbsync.Service.ExecCondition =
    let
      gpgCmds = import ../cli/gpg-commands.nix { inherit pkgs config lib; };
    in
    ''
      /bin/sh -c "${gpgCmds.isUnlocked}"
    '';

  # Ensure 'createMaildir' runs after 'linkGeneration'
  home.activation = {
    createMaildir = lib.mkForce (
      lib.hm.dag.entryAfter [ "linkGeneration" ] ''
        run mkdir -m700 -p $VERBOSE_ARG ${
          lib.concatStringsSep " " (
            lib.mapAttrsToList (_: v: v.maildir.absPath) config.accounts.email.accounts
          )
        }
      ''
    );
  };
}
