{ pkgs, inputs, ... }:

{
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
      # Antigravity uses the socket exposed by ArRPC.
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
}
