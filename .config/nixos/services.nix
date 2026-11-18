{ pkgs, ... }:
{
  services.accounts-daemon.enable = true;
  services.gnome.gnome-keyring.enable = false;
  services.dbus.packages = [ pkgs.oo7-server ];
  systemd.packages = [ pkgs.oo7-server ];
  services.gvfs.enable = true;
  services.power-profiles-daemon.enable = true;
  services.udisks2.enable = true;
  networking.networkmanager.enable = true;
  services.tailscale.enable = true;
}
