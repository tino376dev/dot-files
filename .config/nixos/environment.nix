{
  programs.bash.interactiveShellInit = ''
    alias dot='git --git-dir="$HOME/.local/share/dotfiles.git" --work-tree="$HOME"'
  '';

  environment.sessionVariables = {
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_STATE_HOME = "$HOME/.local/state";
    XDG_CACHE_HOME = "$HOME/.cache";
  };
}
