{ config, lib, pkgs, ... }:
let
  cfg = config.dotfiles;
  home = config.users.users.${cfg.user}.home;
  bootstrap = pkgs.writeShellApplication {
    name = "bootstrap-dotfiles";
    runtimeInputs = [ pkgs.coreutils pkgs.git ];
    text = builtins.readFile ./bootstrap-dotfiles.sh;
  };
in
{
  options.dotfiles = {
    user = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "User whose home is the dotfiles work tree, or null to disable bootstrap.";
    };
    repository = lib.mkOption {
      type = lib.types.str;
      default = "https://github.com/tino376dev/dot-files";
      description = "Git repository to clone on the first bootstrap.";
    };
  };

  config = lib.mkIf (cfg.user != null) {
    systemd.services.dotfiles-bootstrap = {
      description = "Clone and check out the user's bare dotfiles repository";
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
      environment.GIT_TERMINAL_PROMPT = "0";
      serviceConfig = {
        Type = "oneshot";
        User = cfg.user;
        RemainAfterExit = true;
        ExecStart = "${lib.getExe bootstrap} ${lib.escapeShellArgs [ cfg.repository home ]}";
      };
    };

    systemd.services.dotfiles-nixos-link = {
      description = "Link the user's NixOS configuration at /etc/nixos";
      requires = [ "dotfiles-bootstrap.service" ];
      after = [ "dotfiles-bootstrap.service" ];
      wantedBy = [ "multi-user.target" ];
      path = [ pkgs.coreutils ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
      script = ''
        target=${lib.escapeShellArg "${home}/.config/nixos"}
        if [ ! -f "$target/flake.nix" ]; then
          printf 'Missing flake: %s/flake.nix\n' "$target" >&2
          exit 1
        fi
        if [ -L /etc/nixos ] && [ "$(readlink /etc/nixos)" = "$target" ]; then
          exit 0
        fi
        if [ -e /etc/nixos ] || [ -L /etc/nixos ]; then
          printf '/etc/nixos already exists. Back it up and move it aside, then restart dotfiles-nixos-link.service.\n' >&2
          exit 1
        fi
        ln -s -- "$target" /etc/nixos
      '';
    };
  };
}
