# Bare Git Dotfiles

This repository contains both the NixOS flake and home-relative dotfiles.
The configured host's `dotfiles-bootstrap.service` performs the first clone
and checkout automatically. If doing this manually instead:

```bash
mkdir -p "$HOME/.local/share"
git clone --bare https://github.com/tino376dev/dot-files "$HOME/.local/share/dotfiles.git"
git --git-dir="$HOME/.local/share/dotfiles.git" --work-tree="$HOME" \
  config --local status.showUntrackedFiles no
git --git-dir="$HOME/.local/share/dotfiles.git" --work-tree="$HOME" checkout
```

Back up or merge any conflicting files before checkout; do not force checkout.
The checkout includes `README.md` in your home directory and the flake under
`~/.config/nixos/`. If checkout reports conflicts, it does not replace them;
resolve them and rerun checkout.

For later Git operations, configure an alias:

```bash
git config --global alias.dotfiles \
  '!git --git-dir="$HOME/.local/share/dotfiles.git" --work-tree="$HOME"'
git dotfiles status
```

Review changes before staging and commit only files you intend to share. Do not
run `git dotfiles add .config` indiscriminately: applications can store private
or machine-specific data there. The repository itself lives under
`~/.local/share/dotfiles.git`; do not add it to its own work tree.

The `/etc/nixos` link points to `~/.config/nixos/`; after bootstrap,
`sudo nixos-rebuild switch` uses local edits there. The host's hostname must
match its `nixosConfigurations` output name. Avoid pointing `path:$HOME` at the
entire home directory: a path flake can copy unrelated files into the Nix store.
Use `nix flake update --flake path:$HOME/.config/nixos` for lock updates and
stage only the intended changes with `git dotfiles add`. Publishing a new
commit does not update an existing checkout automatically.

## DMS, Niri, And Wallpapers

The tracked `.config/dms/settings.tar.gz` is a backup, not an active DMS
settings file. To restore its `settings.json`, first back up any existing DMS
settings, then extract that file explicitly:

```bash
tar -xOf "$HOME/.config/dms/settings.tar.gz" dms/settings.json > "$HOME/.config/dms/settings.json"
```

DMS owns its writable session state, generated themes, and generated Niri
fragments. DMS setup or reset may change `~/.config/niri/dms/binds.kdl`; review
the Git diff afterward. Per-machine display settings may be written to
`~/.config/niri/dms/outputs.kdl`; review them before sharing.

Use the DMS UI to choose the included wallpaper files under
`~/.local/share/wallpapers/`. Alacritty imports its writable
`dank-theme.toml`; enable Alacritty theming in DMS and change the wallpaper or
theme to generate it. Helix and Bat use the terminal palette. Alacritty starts
Nushell; Fish configuration does not change the account's login shell. dprint
downloads its versioned formatter plugins when first used.

## Zen Profile

Start Zen once and use `about:support` to find the profile directory under
`~/.config/zen`. Copy the templates from `~/.config/nixos/assets/zen/` to that
profile's `user.js` and `chrome/userChrome.css`. Back up or merge existing files
first. The CSS imports DMS-generated `~/.config/dms/zen.css`; DMS must generate
it first. Do not commit passwords, history, extensions, or session data.
