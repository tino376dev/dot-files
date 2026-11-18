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
    pushRepository = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Origin push URL to set on each bootstrap, or null to leave it unchanged.";
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
        ExecStart = "${lib.getExe bootstrap} ${lib.escapeShellArgs [ cfg.repository home (if cfg.pushRepository == null then "" else cfg.pushRepository) ]}";
      };
    };
  };
}
