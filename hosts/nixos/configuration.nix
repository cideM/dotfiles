{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  # Setup keyfile
  boot.initrd.secrets = {
    "/crypto_keyfile.bin" = null;
  };

  # Enable swap on luks
  boot.initrd.luks.devices."luks-9e289554-acf0-4056-9519-12d23516503b".device = "/dev/disk/by-uuid/9e289554-acf0-4056-9519-12d23516503b";
  boot.initrd.luks.devices."luks-9e289554-acf0-4056-9519-12d23516503b".keyFile = "/crypto_keyfile.bin";

  boot.loader.systemd-boot.configurationLimit = 5;

  services.logind.extraConfig = ''
    RuntimeDirectorySize=20G
  '';

  fonts = {
    fontDir.enable = true;
    fontconfig = {
      enable = true;
    };
    packages = [pkgs.operatorMonoFont];
  };

  programs.fish.enable = true;

  programs.steam = {
    enable = true;
  };

  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
  };

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "de_DE.utf8";
      LC_IDENTIFICATION = "de_DE.utf8";
      LC_MEASUREMENT = "de_DE.utf8";
      LC_MONETARY = "de_DE.utf8";
      LC_NAME = "de_DE.utf8";
      LC_NUMERIC = "de_DE.utf8";
      LC_PAPER = "de_DE.utf8";
      LC_TELEPHONE = "de_DE.utf8";
      LC_TIME = "de_DE.utf8";
    };
    inputMethod = {
      type = "fcitx5";
      enable = true;
      fcitx5.addons = with pkgs; [
        fcitx5-mozc
        fcitx5-gtk
        fcitx5-chinese-addons
      ];
    };
  };

  time.timeZone = "Europe/Berlin";

  nix = {
    settings = {
      trusted-users = ["root" "fbrs"];
      extra-sandbox-paths = ["/bin/sh=${pkgs.bash}/bin/sh"];
    };
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs = true
      keep-derivations = true
    '';
  };

  environment.systemPackages = with pkgs; [
    curl
    gnumake
    git
  ];

  programs.xwayland.enable = true;

  services.xserver = {
    enable = true;
    videoDrivers = ["nvidia"];
    # https://discourse.nixos.org/t/problem-with-xkboptions-it-doesnt-seem-to-take-effect/5269/2
    xkb = {
      options = "ctrl:nocaps";
      layout = "us";
    };

    displayManager = {
      gdm = {
        enable = true;
        wayland = true;
      };
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
  };

  programs.adb.enable = true;

  services.geoclue2.enable = true;
  services.printing.enable = true;

  sound.enable = true;
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  hardware = {
    graphics.enable = true;
    # Enable udev rules for Steam hardware such as the Steam Controller, other supported controllers and the HTC Vive
    steam-hardware.enable = true;
    pulseaudio.enable = false;
    # Allow installing more firmwares, without this WiFi might not work
    # https://github.com/NixOS/nixpkgs/issues/163586
    # But it's unclear if I actually need this
    # Okay I think I should enable this since updateMicrocode depends on this in hardware-configuration.nix
    enableRedistributableFirmware = true;
  };

  xdg.mime.enable = true;

  users.users.fbrs = {
    isNormalUser = true;
    description = "Florian";
    shell = pkgs.fish;
    extraGroups = ["adbusers" "wheel" "docker" "networkmanager"];
  };

  virtualisation.docker.enable = true;
  virtualisation.libvirtd.enable = true;

  nixpkgs.config.allowUnfree = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?
}
