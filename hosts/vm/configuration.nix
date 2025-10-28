# Mostly taken from:
# https://github.com/mitchellh/nixos-config/
{
  config,
  pkgs,
  ...
}:
{
  imports = [
    ./hwconf.nix
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    binfmt.emulatedSystems = [ "x86_64-linux" ];
    loader = {
      systemd-boot = {
        enable = true;
        consoleMode = "0";
        configurationLimit = 5;
      };
      efi.canTouchEfiVariables = true;
      # Setup qemu so we can run x86_64 binaries
    };
  };

  # error: too mnay open files
  # https://discourse.nixos.org/t/unable-to-fix-too-many-open-files-error/27094/9
  security.pam.loginLimits = [
    {
      domain = "*";
      type = "soft";
      item = "nofile";
      value = "65536";
    }
    {
      domain = "*";
      type = "hard";
      item = "nofile";
      value = "1048576";
    }
  ];

  services = {
    tailscale.enable = true;
    openssh = {
      enable = true;
      settings.PasswordAuthentication = true;
      settings.PermitRootLogin = "no";
    };
    xserver = {
      enable = true;
      xkb.layout = "us";
    };
    desktopManager.gnome.enable = true;
    displayManager.gdm.enable = true;
    flatpak.enable = true;
  };

  fonts = {
    fontDir.enable = true;
    fontconfig = {
      enable = true;
    };
    packages = [ pkgs.operatorMonoFont ];
  };

  programs = {
    bcc.enable = true;
    fish.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  security.sudo.wheelNeedsPassword = false;

  virtualisation = {
    vmware.guest.enable = true;
    docker.enable = true;
  };

  # Share our host filesystem
  fileSystems."/host" = {
    fsType = "fuse./run/current-system/sw/bin/vmhgfs-fuse";
    device = ".host:/";
    options = [
      "umask=22"
      "uid=1000"
      "gid=1000"
      "allow_other"
      "auto_unmount"
      "defaults"
    ];
  };

  i18n = {
    defaultLocale = "en_US.UTF-8";
    inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5.addons = with pkgs; [
        fcitx5-chinese-addons
        fcitx5-gtk
        fcitx5-hangul
        fcitx5-mozc
      ];
    };
  };

  networking = {
    networkmanager.enable = true;
    hostName = "dev";
    useDHCP = false;
    firewall.enable = false;
  };

  # Enable systemd-resolved for DNS resolution
  services.resolved.enable = true;

  time.timeZone = "Europe/Berlin";

  nix = {
    package = pkgs.lixPackageSets.stable.lix;
    gc = {
      automatic = true;
      dates = "daily";
    };
    settings = {
      trusted-users = [
        "root"
        "fbrs"
      ];
    };
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs = true
      keep-derivations = true
      extra-access-tokens = !include ${config.sops.secrets."git_token".path}
    '';
  };

  environment.systemPackages = with pkgs; [
    curl
    gnumake
    git
    xclip
    wl-clipboard
    killall

    # https://github.com/mitchellh/nixos-config/blob/main/machines/vm-shared.nix
    # For hypervisors that support auto-resizing, this script forces it.
    # I've noticed not everyone listens to the udev events so this is a hack.
    (writeShellScriptBin "xrandr-auto" ''
      xrandr --output Virtual-1 --auto
    '')
  ];

  xdg.mime.enable = true;

  users = {
    users.fbrs = {
      isNormalUser = true;
      description = "Florian";
      shell = pkgs.fish;
      extraGroups = [
        "adbusers"
        "wheel"
        "docker"
        "networkmanager"
      ];
    };
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnsupportedSystem = true;
    };
  };

  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    age.keyFile = "/home/fbrs/.config/sops/age/keys.txt";
    secrets = {
      hello = {
        owner = config.users.users.fbrs.name;
      };
      git_token = {
        owner = config.users.users.fbrs.name;
      };
      claude_api_key = {
        owner = config.users.users.fbrs.name;
      };
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
