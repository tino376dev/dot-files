set -g fish_greeting
fish_add_path $HOME/.local/bin

if status is-interactive
    alias clc='clear'
    if command -q kubectl
        alias kube='kubectl'
    end
    if command -q micro
        set -gx EDITOR (command -s micro)
        set -gx VISUAL $EDITOR
        set -gx MICRO_TRUECOLOR 1
    end
    if command -q eza
        alias ll='eza -lah'
    end
    if command -q starship
        set -gx STARSHIP_CONFIG ~/.config/starship/starship.toml
        starship init fish | source
    end
    if command -q fzf
        set -gx FZF_DEFAULT_OPTS '--multi --layout default'
        set -gx fzf_directory_opts --bind 'ctrl-o:execute($EDITOR {} &> /dev/tty)'
        if functions -q fzf_configure_bindings
            fzf_configure_bindings --directory=\cf --git_log=\cl --git_status=\cs --processes=\cp
        end
        if command -q fd
            set -gx fzf_fd_opts --ignore-case --hidden --exclude .git --max-depth 6 --color=always
        end
        if command -q eza
            set -gx fzf_preview_dir_cmd eza --color=always --icons=always -laah
        end
        if command -q bat
            set -gx fzf_preview_file_cmd bat --color=always -n
        end
        if command -q delta
            set -gx fzf_diff_highlighter delta --paging=never --width=20
        end
    end
    if command -q zoxide
        zoxide init fish | source
    end
end