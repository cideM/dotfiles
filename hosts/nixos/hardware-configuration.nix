{ modulesPath, config, lib, pkgs, ... }:

{
  imports =
    [ 
      (modulesPath + "/installer/scan/not-detected.nix")
      (modulesPath + "/hardware/network/broadcom-43xx.nix")
    ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/arch" =
    { device = "/dev/disk/by-uuid/57b00a2f-919a-4d0d-b223-a00b10949d10";
      fsType = "ext4";
    };

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/b6331a7f-1fec-4a1d-8462-310b2a13b74f";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/A535-BD31";
      fsType = "vfat";
    };

  fileSystems."/data" =
    { device = "/dev/disk/by-uuid/44ac96b7-bf0b-485a-b7fe-f0b85f124336";
      fsType = "ext4";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/1b666feb-a77f-41fc-b9c5-c7c4c63fc4b0"; }
    ];

  nix.maxJobs = lib.mkDefault 16;
  # High-DPI console
  console.font = lib.mkDefault "${pkgs.terminus_font}/share/consolefonts/ter-u28n.psf.gz";
}
