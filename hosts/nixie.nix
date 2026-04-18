{ pkgs, lib, ... }:

{
  networking.hostName = lib.mkForce "Nixie";

  environment.systemPackages = with pkgs; [
    lazydocker
    google-cloud-sdk
    firebase-tools
    caddy
  ];

  environment.shellAliases = {
    rebuild-build = "sudo nixos-rebuild build --flake ~/Projects/nixos-config#Nixie";
    rebuild-switch = "sudo nixos-rebuild switch --flake ~/Projects/nixos-config#Nixie";

    homelab-up = "docker compose -f ~/Projects/homelab/compose.yml up -d";
    homelab-down = "docker compose -f ~/Projects/homelab/compose.yml down";

    school-up = "docker compose -f ~/Projects/school-projects/deskrpg/docker-compose.yml up -d";
    school-down = "docker compose -f ~/Projects/school-projects/deskrpg/docker-compose.yml down";
  };

  networking.firewall.checkReversePath = "loose";

  services.tailscale.enable = true;
  services.tailscale.extraUpFlags = [ "--ssh" ];
  services.tailscale.useRoutingFeatures = "both";

  home-manager.users.nicole = { pkgs, inputs, ... }: {
    home.username = "nicole";
    home.homeDirectory = "/home/nicole";
    home.stateVersion = "24.11";

    home.sessionPath = [
      "$HOME/.npm-global/bin"
    ];

    home.sessionVariables = {
      PATH = "$HOME/.npm-global/bin:$PATH";
    };

    home.packages = [
      inputs.antigravity.packages.${pkgs.system}.default
      pkgs.arrpc
    ];

    systemd.user.services.arrpc = {
      Unit = {
        Description = "ArRPC Discord Rich Presence Bridge";
        After = [ "graphical-session.target" ];
      };
      Service = {
        ExecStart = "${pkgs.arrpc}/bin/arrpc";
        Restart = "always";
        RestartSec = "5";
      };
      Install = {
        WantedBy = [ "default.target" ];
      };
    };

    programs.bash = {
      enable = true;
      initExtra = ''
        export PATH="$HOME/.npm-global/bin:$PATH"
        export PS1="\[\033[01;35m\]\u@\[\033[01;34m\]\h \[\033[01;32m\]\w \$ \[\033[00m\]"
      '';
    };

    programs.home-manager.enable = true;
  };

  services.code-server = {
    enable = true;
    user = "nicole";
    host = "127.0.0.1";
    port = 4444;
    auth = "none";
    disableTelemetry = true;
    disableUpdateCheck = true;

    extraPackages = with pkgs; [
      git
      nodejs_22
      python3
      gcc
      gnumake
      sqlite
      openssl
      jq
      bubblewrap
    ];
  };

  systemd.timers.immich-backup = {
    description = "Timer for daily Immich PostgreSQL backup";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
      Unit = "immich-backup.service";
    };
  };

  systemd.timers.vaultwarden-backup = {
    description = "Timer for daily Vaultwarden SQLite backup";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
      Unit = "vaultwarden-backup.service";
    };
  };

  sops.defaultSopsFile = ../secrets/secrets.yaml;
  sops.defaultSopsFormat = "yaml";
  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  sops.secrets."github/token" = { };
}
