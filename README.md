# NixOS and Dotfiles

This repository is both a NixOS flake and a bare Git dotfiles repository.
Its root is intended to be checked out into `$HOME`: application configuration
is under `.config/`, shared NixOS modules and host definitions are under
`.config/nixos/`, and wallpapers are under `.local/share/wallpapers/`.
No Home Manager module is used.

The flake at `.config/nixos/flake.nix` exports `nixosConfigurations.surface` and a reusable NixOS
desktop module, based on `nixos-unstable`. For each additional machine, create
`.config/nixos/hosts/<name>/configuration.nix` and its own generated
`hardware-configuration.nix`, then add a `nixosConfigurations.<name>` entry to
`.config/nixos/flake.nix`. Keep each host's hardware, bootloader, user, and state version
specific to that machine.

## Surface Installation

Review the Surface configuration and hardware scan in
[.config/nixos/hosts/surface/](.config/nixos/hosts/surface/); verify filesystem
labels, bootloader settings, username, and state version on the target.
Once the repository is published and contains a reviewed `flake.lock`,
install from the NixOS installer after partitioning and mounting the target
filesystems:

```bash
sudo env NIX_CONFIG='experimental-features = nix-command flakes' \
  nixos-install --flake 'github:tino376dev/dot-files?dir=.config/nixos#surface'
```

Create and publish that repository before using these commands. For an existing installation,
use `nixos-rebuild switch` instead of `nixos-install`:

```bash
sudo env NIX_CONFIG='experimental-features = nix-command flakes' \
  nixos-rebuild switch --flake 'github:tino376dev/dot-files?dir=.config/nixos#surface'
```

Use a reviewed commit or tag for repeatable deployments; the lock file pins
flake inputs, while an unpinned branch can move. Surface devices may need
model-specific kernel or firmware configuration. Test on the actual device.

The Surface sets `dotfiles.user = "tino"`. At boot (or during the first switch),
`dotfiles-bootstrap.service` clones the repository as
`~/.local/share/dotfiles.git` and checks it out into the user's home. On the
initial checkout, it can replace existing files at paths tracked by the
repository, so back up anything you want to keep. It runs as that user and
leaves an already-existing bare repository alone. It never pulls updates
automatically. Network access
to the published repo is required; private repos require Git credentials for
that user. An unavailable repo causes a visible service failure.

`dotfiles-nixos-link.service` then links `/etc/nixos` to
`/home/tino/.config/nixos`. It refuses to replace an existing directory or
different symlink. Back up and move the old `/etc/nixos` aside manually, then
run `sudo systemctl restart dotfiles-nixos-link.service`. To inspect failures,
use `journalctl -u dotfiles-bootstrap -u dotfiles-nixos-link`; after resolving
a bootstrap failure or publishing the repository, restart
`dotfiles-bootstrap.service`, then `dotfiles-nixos-link.service`.

The hostname is `surface`, matching the flake output, so subsequent local
changes can be applied with plain `sudo nixos-rebuild switch`. This deliberately
trusts the selected user's editable configuration for root rebuilds.
See [.config/nixos/docs/DOTFILES.md](.config/nixos/docs/DOTFILES.md) for Git
operations. Set the user's password locally with `passwd`, connect Wi-Fi with
NetworkManager, and run `sudo tailscale up` to authenticate Tailscale.

## Updates

Update the lock with `nix flake update --flake path:$HOME/.config/nixos`,
review and commit `.config/nixos/flake.lock`, and push. Rebuild locally with
`sudo nixos-rebuild switch`, or from the desired GitHub revision as above.
Unstable updates can change the shell, greeter, Niri, and other system packages.
Keep the lock file so inputs remain reproducible.

Nix may copy tracked flake files into the world-readable Nix store. Never
commit passwords, Wi-Fi keys, private keys, tokens, or other secrets. Review
GUI-generated dotfiles for private or machine-specific data before committing.

The shared NixOS module imports the category files in `.config/nixos/`. Zen
comes from the [youwen5 community flake](https://github.com/youwen5/zen-browser-flake);
its user configuration remains separate from the Nix package.
