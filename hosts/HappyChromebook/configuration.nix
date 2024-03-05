# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      inputs.home-manager.nixosModules.default
      # ../../modules/nixos/nvidia.nix
      ../../modules/nixos/syncthing.nix
    ];

  # environment.persistence."/nix/persist" = {
  #   hideMounts = true;
  #   directories = [
  #     "/var/lib/bluetooth"
  #     "/etc/NetworkManager/system-connections"
  #   ];
  #   files = [ "/etc/machine-id" ];
  # };
  #
  # environment.persistence."/nix/persist-hdd" = {
  #   hideMounts = true;
  #   directories = [ ];
  #   files = [ ];
  # };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.systemd.enable = true;

  # boot.plymouth.enable = true;

  stylix.image = pkgs.fetchurl {
    url = "https://www.pixelstalk.net/wp-content/uploads/2016/05/Epic-Anime-Awesome-Wallpapers.jpg";
    sha256 = "enQo3wqhgf0FEPHj2coOCvo7DuZv+x5rL/WIo4qPI50=";
  };
  # stylix.polarity = "dark";
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/solarized-dark.yaml";
  # stylix.targets.plymouth.blackBackground = false;

  networking.hostName = "HappyChromebook"; # Define your hostname.

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
  };



  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "nl_NL.UTF-8";
    LC_IDENTIFICATION = "nl_NL.UTF-8";
    LC_MEASUREMENT = "nl_NL.UTF-8";
    LC_MONETARY = "nl_NL.UTF-8";
    LC_NAME = "nl_NL.UTF-8";
    LC_NUMERIC = "nl_NL.UTF-8";
    LC_PAPER = "nl_NL.UTF-8";
    LC_TELEPHONE = "nl_NL.UTF-8";
    LC_TIME = "nl_NL.UTF-8";
  };

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
    libinput.enable = true;
  };

  services.openssh = {
    enable = true;
    settings = {
      # PasswordAuthentication = false;
      # KbdInteractiveAuthentication = false;
    };
  };

  services.devmon.enable = true;

  programs.fish.enable = true;

  programs.hyprland.enable = true;
  programs.hyprland.package = inputs.hyprland.packages."${pkgs.system}".hyprland;

  users.mutableUsers = false;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.mrhappy200 = {
    isNormalUser = true;
    description = "Ronan Berntsen";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [ ];
    initialHashedPassword = "$6$lC8383BP7hKdOvSo$re6Jpw4qspCS4.2kujDYb68yHn8V0trh0XqLmiB8nFhH0IKnSOAJ1623EcW/iBxtiH9CiVd8QifC549zV8abD1";
    shell = pkgs.fish;
  };

  programs.fuse.userAllowOther = true;
  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = {
      "mrhappy200" = import ./home.nix;
    };
  };

  # make it build

  # Enable automatic login for the user.
  # services.getty.autologinUser = "mrhappy200";

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    #  wget
    neovim
    gnupg
    pulseaudio
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
