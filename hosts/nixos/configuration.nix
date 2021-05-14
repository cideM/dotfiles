{ config, pkgs, hwConfig, operatorMono, neovim-nightly-overlay, ... }:
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
      "${hwConfig}"
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 5;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelModules = [ "kvm-amd" ];
  boot.kernel.sysctl = {
    "vm.max_map_count" = 262144;
  };
  boot.crashDump.enable = true;

  services.logind.extraConfig = ''
    RuntimeDirectorySize=20G
  '';

  fonts = {
    fontDir.enable = false;
    fonts = [ operatorMonoFontPkg ];
  };

  systemd.network.enable = true;

  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
  };

  i18n.defaultLocale = "en_US.UTF-8";
  i18n = {
    inputMethod = {
      enabled = "fcitx5";
      fcitx5.addons = with pkgs; [
        fcitx5-mozc
        fcitx5-gtk
      ];
    };
  };

  time.timeZone = "Europe/Berlin";

  nix = {
    package = pkgs.nixUnstable;
    trustedUsers = [ "root" "tifa" ];
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs = true
      keep-derivations = true
    '';
  };

  environment.systemPackages = with pkgs; [
    curl
    gnumake
    vim
    git
    # compiles forever atm
    # chromium
  ];

  services.xserver = {
    enable = true;
    videoDrivers = [ "nvidia" ];
    layout = "us";
    # https://discourse.nixos.org/t/problem-with-xkboptions-it-doesnt-seem-to-take-effect/5269/2
    xkbOptions = "ctrl:nocaps";

    displayManager = {
      gdm.enable = true;
      gdm.wayland = false;
    };

    desktopManager = {
      gnome = {
        enable = true;
      };
    };
  };

  services.gnome.gnome-keyring.enable = true;

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryFlavor = "gnome3";
  };

  programs.adb.enable = true;

  services.openssh = {
    enable = false;
    authorizedKeysFiles = [ "/home/tifa/.ssh/authorized_keys" ];
    passwordAuthentication = false; # originally true
    permitRootLogin = "no";
    challengeResponseAuthentication = false;
  };

  services.geoclue2.enable = true;

  sound.enable = true;
  hardware.pulseaudio =
    {
      enable = true;
      package = pkgs.pulseaudioFull;
      extraConfig = ''
        load-module module-echo-cancel
      '';
      extraModules = [ pkgs.pulseaudio-modules-bt ];
    };

  hardware.bluetooth = {
    enable = true;
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
        ControllerMode = "bedr";
      };
    };
  };

  xdg.mime.enable = true;

  users.users.tifa = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [ "adbusers" "wheel" "docker" "networkmanager" ];
  };

  virtualisation.docker.enable = true;
  virtualisation.libvirtd.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.03"; # Did you read the comment?

  boot.initrd.luks.devices.luksroot = {
    device = "/dev/disk/by-uuid/3fd381f4-c774-43cd-b229-77d8969ca4b5";
    preLVM = true;
    allowDiscards = true;
  };
}
