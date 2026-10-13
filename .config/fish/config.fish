if status is-interactive
    set -g fish_greeting

    
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'

    alias vc="python -m venv .venv"
    alias va="source .venv/bin/activate.fish"
    alias vrm="rm -rf .venv"

    alias dots="git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME"

    starship init fish | source
end
