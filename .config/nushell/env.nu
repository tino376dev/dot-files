use std "path add"
path add ($nu.home-dir | path join ".local/bin")
$env.config.show_banner = false
mkdir $nu.cache-dir
mkdir $nu.data-dir
let autoload = $nu.data-dir | path join "vendor/autoload"
mkdir $autoload

$env.NU_LIB_DIRS = ($env.NU_LIB_DIRS | append ($nu.default-config-dir | path join "modules"))
$env.STARSHIP_CONFIG = ($nu.home-dir | path join ".config/starship/starship.toml")

let zoxide = $autoload | path join "zoxide.nu"
try { ^zoxide init nushell | save -f $zoxide }

let starship = $autoload | path join "starship.nu"
try { ^starship init nu | save -f $starship }

let carapace = $autoload | path join "carapace.nu"
try { ^carapace _carapace nushell | save -f $carapace }