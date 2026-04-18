{ lib, ... }:

{
  networking.hostName = lib.mkDefault "nibblet";

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  environment.shellAliases = {
    rebuild-build = "sudo nixos-rebuild build --flake ~/Projects/nixos-config#nibblet";
    rebuild-switch = "sudo nixos-rebuild switch --flake ~/Projects/nixos-config#nibblet";
  };
}
