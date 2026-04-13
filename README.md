# NixOS configuration

Declarative NixOS configuration managed with flakes, Home Manager, and `sops-nix`.

## Layout

- `flake.nix`: input definitions and NixOS system assembly
- `configuration.nix`: base system configuration and imported modules
- `nixie.nix`: host-specific packages, services, timers, and secrets integration
- `home.nix`: per-user Home Manager configuration
- `hardware-configuration.nix`: generated hardware profile

## Common commands

- Apply the system configuration: `sudo nixos-rebuild switch --flake .#Nixie`
- Update flake inputs: `nix flake update`
