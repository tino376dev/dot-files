use modules/fish-completer.nu

def --env y [...args] {
  let tmp = (mktemp -t "yazi-cwd.XXXXXX")
  yazi ...$args --cwd-file $tmp
  let cwd = (open $tmp)
  if $cwd != "" and $cwd != $env.PWD {
    cd $cwd
  }
  rm -fp $tmp
}

$env.config.ls.use_ls_colors = true
$env.config.completions.algorithm = "fuzzy"
$env.config.completions.external.enable = true

@complete fish-completer
extern git []
@complete fish-completer
extern nu []
@complete fish-completer
extern bat []
@complete fish-completer
extern databricks []

const ctrl_z = {
  name: toggle_job
  modifier: control
  keycode: char_z
  mode: [emacs vi_insert vi_normal]
  event: [{
    send: executehostcommand
    cmd: "try {job unfreeze (job list | get id.0)}"
  }]
}
$env.config.keybindings = $env.config.keybindings | append [$ctrl_z]

alias ls = ls -la
alias sudo = ^sudo -E
alias table = table -t "light"
def fg [] { try { job unfreeze (job list | get id.0) } }