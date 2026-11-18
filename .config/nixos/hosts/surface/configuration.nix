{
  imports = [ ./hardware-configuration.nix ];

  dotfiles.user = "tino";
  dotfiles.pushRepository = "git@github.com:tino376dev/dot-files.git";
  networking.hostName = "surface";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  time.timeZone = "Europe/Zurich";
  services.xserver.xkb.layout = "us";
  services.displayManager.dux-greeter.configHome = "/home/tino";

  users.users.tino = {
    description = "Forest";
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
  };

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = true;
      PermitRootLogin = "no";
    };
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.stateVersion = "26.05";
}
