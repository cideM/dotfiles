# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, operatorMono, ... }:
let
  operatorMonoFontPkg = pkgs.stdenv.mkDerivation {
    name = "operator-mono-font";
    src = operatorMono;
    buildPhases = [ "installPhase" ];
    installPhase = ''
      mkdir -p $out/share/fonts/operator-mono
      cp -R "$src" "$out/share/fonts/operator-mono"
    '';
  };

in
{

  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 5;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernel.sysctl = {
    "vm.max_map_count" = 262144;
  };

  fonts = {
    fontDir.enable = false;
    fonts = [ operatorMonoFontPkg ];
  };

  services.resolved = {
    enable = true;
  };

  networking = {
    useDHCP = false;
    interfaces.wlp7s0.useDHCP = true;
    hostName = "nixos";
    networkmanager.enable = true;
    networkmanager.wifi.backend = "iwd";
    wireless.iwd.enable = true;
  };

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n = {
    inputMethod = {
      enabled = "fcitx";
      fcitx.engines = with pkgs.fcitx-engines; [ mozc ];
    };
  };

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  nixpkgs.config = {
    allowUnfree = true;
  };

  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget
    curl
    nano
    gnumake
    stow
    vim
    git
    gnome3.gnome-shell-extensions
    gnome3.dconf-editor
    chromium
  ];


  # Some programs need SUID wrappers, can be configured further or are started
  # in user sessions.
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryFlavor = "gnome3";
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  services.lorri.enable = true;

  services.geoclue2.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  xdg.mime.enable = true;

  services.xserver = {
    enable = true;
    layout = "us";
    # https://discourse.nixos.org/t/problem-with-xkboptions-it-doesnt-seem-to-take-effect/5269/2
    # Everything is broke, always.
    xkbOptions = "ctrl:nocaps";

    displayManager = {
      gdm.enable = true;
      gdm.wayland = false;
    };

    desktopManager = {
      gnome3 = {
        enable = true;
      };
    };
  };

  services.udev.packages = with pkgs; [ gnome3.gnome-settings-daemon ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.tifa = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [ "wheel" "networkmanager" "docker" ]; # Enable ‘sudo’ for the user.
  };

  home-manager.users.tifa = ./home.nix;

  virtualisation.docker.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.03"; # Did you read the comment?

}
