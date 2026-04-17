{ pkgs, lib, ... }:

{
  networking.hostName = lib.mkDefault "Worklaptop";

  environment.systemPackages = with pkgs; [ ];
}
