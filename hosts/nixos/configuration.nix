# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, hwConfig, operatorMono, ... }:
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

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 5;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernel.sysctl = {
    "vm.max_map_count" = 262144;
  };

  # All of this shit here is just in the hope to enable some form of Zoom
  # TODO: Understand what these things do and how and if they work
  services.pipewire.enable = true;
  xdg = {
    portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-wlr
        xdg-desktop-portal-gtk
      ];
      gtkUsePortal = true;
    };
  };

  fonts = {
    fontDir.enable = false;
    fonts = [ operatorMonoFontPkg ];
  };

  services.resolved = {
    enable = true;
  };

  systemd.network.enable = true;

  environment.etc."iwd/main.conf".text = ''
    [General]
    EnableNetworkConfiguration=true

    [Network]
    EnableIPv6=true
    NameResolvingService=systemd
  '';

  networking = {
    useDHCP = false;
    useNetworkd = true;
    hostName = "nixos";
    wireless.iwd.enable = true;
  };

  # Select internationalisation properties.
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


  programs.xwayland.enable = true;

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
    curl
    gnumake
    vim
    git

    wofi
    mako
    wl-clipboard
  ];


  # Some programs need SUID wrappers, can be configured further or are started
  # in user sessions.
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraSessionCommands = ''
      # Fix for some Java AWT applications (e.g. Android Studio), use this if
      # they aren't displayed properly:
      export _JAVA_AWT_WM_NONREPARENTING=1

      # https://www.reddit.com/r/swaywm/comments/i6qlos/how_do_i_use_an_ime_with_sway/g1lk4xh?utm_source=share&utm_medium=web2x&context=3
      export INPUT_METHOD=fcitx
      export QT_IM_MODULE=fcitx
      export GTK_IM_MODULE=fcitx
      export XMODIFIERS=@im=fcitx
      export XIM_SERVERS=fcitx
    '';
  };

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    authorizedKeysFiles = [ "/home/tifa/.ssh/authorized_keys" ];
    passwordAuthentication = false; # originally true
    permitRootLogin = "no";
    challengeResponseAuthentication = false;
  };

  services.lorri.enable = true;

  services.geoclue2.enable = true;

  services.gnome3.gnome-keyring.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  xdg.mime.enable = true;

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

  boot.initrd.luks.devices.luksroot = {
    device = "/dev/disk/by-uuid/3fd381f4-c774-43cd-b229-77d8969ca4b5";
    preLVM = true;
    allowDiscards = true;
  };
}
