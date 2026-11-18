{ pkgs, ... }:
{
  fonts.packages = [ pkgs.noto-fonts ];

  programs.niri.enable = true;
  programs.dux-shell = {
    enable = true;
    systemd.enable = true;
    systemd.target = "niri.service";
  };

  services.displayManager.dux-greeter = {
    enable = true;
    compositor.name = "niri";
  };
}
