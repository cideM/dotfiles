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
      ./hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 5;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelParams = [
    "processor.max_cstate=1"
  ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.kernel.sysctl = {
    "vm.max_map_count" = 262144;
  };

  services.logind.extraConfig = ''
    RuntimeDirectorySize=20G
  '';

  fonts = {
    fontDir.enable = false;
    fonts = [ operatorMonoFontPkg ];
  };

  services.udev.extraRules = ''
    # HW.1 / Nano
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="2581", ATTRS{idProduct}=="1b7c|2b7c|3b7c|4b7c", TAG+="uaccess", TAG+="udev-acl"
    # Blue
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="2c97", ATTRS{idProduct}=="0000|0000|0001|0002|0003|0004|0005|0006|0007|0008|0009|000a|000b|000c|000d|000e|000f|0010|0011|0012|0013|0014|0015|0016|0017|0018|0019|001a|001b|001c|001d|001e|001f", TAG+="uaccess", TAG+="udev-acl"
    # Nano S
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="2c97", ATTRS{idProduct}=="0001|1000|1001|1002|1003|1004|1005|1006|1007|1008|1009|100a|100b|100c|100d|100e|100f|1010|1011|1012|1013|1014|1015|1016|1017|1018|1019|101a|101b|101c|101d|101e|101f", TAG+="uaccess", TAG+="udev-acl"
    # Aramis
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="2c97", ATTRS{idProduct}=="0002|2000|2001|2002|2003|2004|2005|2006|2007|2008|2009|200a|200b|200c|200d|200e|200f|2010|2011|2012|2013|2014|2015|2016|2017|2018|2019|201a|201b|201c|201d|201e|201f", TAG+="uaccess", TAG+="udev-acl"
    # HW2
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="2c97", ATTRS{idProduct}=="0003|3000|3001|3002|3003|3004|3005|3006|3007|3008|3009|300a|300b|300c|300d|300e|300f|3010|3011|3012|3013|3014|3015|3016|3017|3018|3019|301a|301b|301c|301d|301e|301f", TAG+="uaccess", TAG+="udev-acl"
    # Nano X
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="2c97", ATTRS{idProduct}=="0004|4000|4001|4002|4003|4004|4005|4006|4007|4008|4009|400a|400b|400c|400d|400e|400f|4010|4011|4012|4013|4014|4015|4016|4017|4018|4019|401a|401b|401c|401d|401e|401f", TAG+="uaccess", TAG+="udev-acl"
  '';

  systemd.network.enable = true;
  systemd.coredump.enable = true;

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
        fcitx5-chinese-addons
        fcitx5-gtk
      ];
    };
  };

  time.timeZone = "Europe/Berlin";

  nix = {
    package = pkgs.nixUnstable;
    sandboxPaths = [ "/bin/sh=${pkgs.bash}/bin/sh" ];
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
