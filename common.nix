{ config, pkgs, ... }:

{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.networkmanager.enable = true;

  time.timeZone = "Asia/Jakarta";
  i18n.defaultLocale = "en_US.UTF-8";

  users.users.nicole = {
    isNormalUser = true;
    description = "Nicole";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPnqJQIK0sUl2k/plnxcD03SzfHHS+xwUb68B495+BPt github@vioryn.cc"
    ];
  };

  environment.systemPackages = with pkgs; [
    fastfetch
    tmux
    git
    gh
    curl
    wget
    htop
    btop
    vim
    nano
    procps
    nodejs_22
    python3
    gcc
    gnumake
    sqlite
    openssl
    jq
    unzip
    zip
    bubblewrap
    google-chrome
    vscode
    docker-compose
    gradia
    himalaya
    obsidian
    gemini-cli
  ];

  environment.shellAliases = {
    rebuild = "sudo nixos-rebuild switch --flake ~/Projects/nixos-config#${config.networking.hostName}";
    rebuild-flake = "sudo nixos-rebuild switch --flake ~/Projects/nixos-config#${config.networking.hostName}";
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

  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
  programs.ssh.askPassword = "${pkgs.kdePackages.ksshaskpass}/bin/ksshaskpass";

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  programs.firefox.enable = true;

  services.tailscale.enable = true;

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  fonts.packages = with pkgs; [
    comfortaa
  ];

  fonts.fontconfig = {
    defaultFonts = {
      serif = [ "Comfortaa" ];
      sansSerif = [ "Comfortaa" ];
    };
  };

  system.stateVersion = "24.11";
}
