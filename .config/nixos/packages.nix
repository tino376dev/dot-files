{ finpilotZen, pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;
  programs.flyline.enable = true;
  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = false;
    enableZshIntegration = false;
    enableXonshIntegration = false;
    enableNushellIntegration = false;
  };

  environment.systemPackages = with pkgs; [
    alacritty
    bat
    bats
    brightnessctl
    bubblewrap
    carapace
    cliphist
    curl
    delta
    dprint
    dust
    eza
    fd
    ffmpeg
    ffmpegthumbnailer
    file
    fish
    fzf
    gh
    git
    glow
    gum
    helix
    jq
    just
    markdown-oxide
    marksman
    micro
    microsoft-edge
    numbat
    nushell
    oo7
    openfortivpn
    podman-compose
    poppler-utils
    ppp
    procps
    ripgrep
    ruff
    shellcheck
    signal-desktop
    tinymist
    topiary
    typst
    vivid
    xwayland-satellite
    yazi
    zed-editor
    finpilotZen
    zoxide
  ];
}
