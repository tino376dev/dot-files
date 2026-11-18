repository=$1
home=$2
git_dir="$home/.local/share/dotfiles.git"
staging="$git_dir.bootstrap"

if [ -e "$git_dir" ] || [ -L "$git_dir" ]; then
  if [ "$(git --git-dir="$git_dir" rev-parse --is-bare-repository)" != true ]; then
    printf 'Not a bare Git repository: %s\n' "$git_dir" >&2
    exit 1
  fi
  exit 0
fi

mkdir -p "$home/.local/share"
if [ ! -e "$staging" ] && [ ! -L "$staging" ]; then
  git clone --bare -- "$repository" "$staging"
fi

if [ "$(git --git-dir="$staging" rev-parse --is-bare-repository)" != true ]; then
  printf 'Not a bare Git repository: %s\n' "$staging" >&2
  exit 1
fi

git --git-dir="$staging" config --local status.showUntrackedFiles no
git --git-dir="$staging" --work-tree="$home" checkout --force
if [ ! -f "$home/.config/nixos/flake.nix" ]; then
  printf 'Checkout is missing %s/.config/nixos/flake.nix\n' "$home" >&2
  exit 1
fi
mv -T -- "$staging" "$git_dir"
