{ pkgs, lib, ... }:

{
  networking.hostName = lib.mkForce "Nixie";
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  users.users.nicole = {
    isNormalUser = true;
    description = "Nicole";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPnqJQIK0sUl2k/plnxcD03SzfHHS+xwUb68B495+BPt github@vioryn.cc"
    ];
  };

  environment.systemPackages = with pkgs; [
    google-chrome
    fastfetch
    git
    curl
    wget
    htop
    btop
    vim
    nano
    procps

    # Development tools
    nodejs_22
    python3
    gcc
    gnumake
    vscode
    sqlite

    # Security and operational utilities
    openssl
    jq
    unzip
    zip
    lazydocker
    bubblewrap

    # Infrastructure tooling
    google-cloud-sdk
    firebase-tools
    tailscale
    caddy
    docker-compose
    arrpc
  ];

  environment.shellAliases = {
    rebuild = "sudo nixos-rebuild switch --flake ~/nixos-config#Nixie";
    rebuild-flake = "sudo nixos-rebuild switch --flake ~/nixos-config#Nixie";

    homelab-up = "docker compose -f ~/Projects/homelab/compose.yml up -d";
    homelab-down = "docker compose -f ~/Projects/homelab/compose.yml down";

    school-up = "docker compose -f ~/Projects/school-projects/deskrpg/docker-compose.yml up -d";
    school-down = "docker compose -f ~/Projects/school-projects/deskrpg/docker-compose.yml down";
  };

  programs.git = {
    enable = true;
    config = {
      user.name = "Viorinite";
      user.email = "92729730+Viorinite@users.noreply.github.com";
      init.defaultBranch = "main";
      core.sshCommand = "ssh -i ~/.ssh/id_ed25519";
    };
  };

  programs.nix-ld.enable = true;
  nixpkgs.config.allowUnfree = true;
  virtualisation.docker.enable = true;

  # Required for Tailscale subnet routing and exit-node support.
  networking.firewall.checkReversePath = "loose";

  services.tailscale.enable = true;
  services.tailscale.extraUpFlags = [ "--ssh" ];
  services.tailscale.useRoutingFeatures = "both";

  # Bind code-server to localhost; publish it on the tailnet with `tailscale serve`.
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

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
    };
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

  sops.defaultSopsFile = ./secrets/secrets.yaml;
  sops.defaultSopsFormat = "yaml";

  # Use the host SSH key to keep secret decryption machine-specific.
  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  sops.secrets."github/token" = { };

  fonts.packages = with pkgs; [
    comfortaa
  ];

  fonts.fontconfig = {
    defaultFonts = {
      serif = [ "Comfortaa" ];
      sansSerif = [ "Comfortaa" ];
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
}
