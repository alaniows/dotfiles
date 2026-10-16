source /usr/share/cachyos-fish-config/cachyos-config.fish

# overwrite greeting
# potentially disabling fastfetch
#function fish_greeting
#    # smth smth
#end
alias gaming="sudo /usr/local/bin/gaming-profile.sh"
alias gaming-off="sudo nvidia-smi --reset-gpu-clocks && powerprofilesctl set balanced"
alias halo-fix="~/.local/bin/halo-fix.sh"

set -g pure_symbol_prompt "╰─❯ "
set -g pure_begin_prompt_with_newline true
