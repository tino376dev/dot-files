{ lib, pkgs, ... }:
{
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ oo7-portal xdg-desktop-portal-gnome xdg-desktop-portal-gtk ];
    config.niri."org.freedesktop.impl.portal.Secret" = lib.mkForce "oo7-portal";
  };
}
