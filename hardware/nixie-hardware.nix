{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "sd_mod" "alcor" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/mapper/luks-2f8a2d8d-60be-4e48-89b5-74371ce3e5d6";
    fsType = "ext4";
  };

  boot.initrd.luks.devices."luks-2f8a2d8d-60be-4e48-89b5-74371ce3e5d6".device =
    "/dev/disk/by-uuid/2f8a2d8d-60be-4e48-89b5-74371ce3e5d6";

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/4E19-33E1";
    fsType = "vfat";
    options = [ "fmask=0077" "dmask=0077" ];
  };

  swapDevices = [ ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
