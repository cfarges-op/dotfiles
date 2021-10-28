# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

### Added by Zinit's installer
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zinit-zsh/z-a-rust \
    zinit-zsh/z-a-as-monitor \
    zinit-zsh/z-a-patch-dl \
    zinit-zsh/z-a-bin-gem-node

### End of Zinit's installer chunk

zinit ice depth=1; zinit light romkatv/powerlevel10k

zinit wait lucid light-mode for \
  atinit"zicompinit; zicdreplay" \
      zdharma/fast-syntax-highlighting \
  atload"_zsh_autosuggest_start" \
      zsh-users/zsh-autosuggestions \
  blockf atpull'zinit creinstall -q .' \
      zsh-users/zsh-completions


# Configure history
export HISTFILE="$HOME/.zhistory"
export HISTSIZE=10000000
export SAVEHIST=10000000

setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_reduce_blanks
setopt share_history

# zsh-fzf-history-search
zinit ice lucid wait'0'
zinit light joshskidmore/zsh-fzf-history-search

# Set beginning key
bindkey "^[[H" beginning-of-line
bindkey "^[[1~" beginning-of-line # [PageUp] - go to beginning of line
bindkey "^[[5~" beginning-of-line # [PageUp] - go to beginning of line

# Set end of line
bindkey "^[[F" end-of-line
bindkey "^[[4~" end-of-line # [PageDown] - go to end of line
bindkey "^[[6~" end-of-line # [PageDown] - go to end of line

bindkey '^[[1;5C' forward-word  # [Ctrl-RightArrow] - move forward one word
bindkey '^[[1;5D' backward-word # [Ctrl-LeftArrow] - move backward one word

bindkey "^[[3~" delete-char # [Delete] - Forward letter

# Load asdf
zinit ice wait lucid
zinit load redxtech/zsh-asdf-direnv

# append completions to fpath
fpath=(${ASDF_DIR}/completions $fpath)


function _asdf_install_latest(){
    PLUGIN=$1
      echo "Going to install latest version of $PLUGIN"
        asdf plugin-add $PLUGIN
	  asdf install $PLUGIN latest
	    asdf global $PLUGIN latest
}
function apinstall(){
    PLUGIN=$(asdf plugin-list-all | fzf | cut -d' ' -f1)
      _asdf_install_latest $PLUGIN
}

# Completions

# kubectl
zinit light-mode lucid wait has"kubectl" for \
  id-as"kubectl_completion" \
  as"completion" \
  atclone"kubectl completion zsh > _kubectl" \
  atpull"%atclone" \
  run-atpull \
    zdharma/null
zpcompinit
alias k=kubectl

#zinit light-mode lucid wait has"aws" for \
#  id-as"aws_completion" \
#  as"completion" \
#  atpull"complete -C 'aws_completer' aws" \
#  run-atpull \
#    zdharma/null

zi wait"0c" lucid for \
 has'aws_completer' as'null' \
 id-as'aws_completion' \
 atload'autoload -Uz bashcompinit && bashcompinit && complete -C "$(which aws_completer)" aws' \
    zdharma/null

zi wait"0c" lucid for \
 has'tf_completer' as'null' \
 id-as'tf_completion' \
 atload'autoload -Uz bashcompinit && bashcompinit && complete -o nospace -C "$(which terraform)" terraform' \
    zdharma/null


#atload="complete -o nospace -C "$(which terraform)" terraform" \
#  run-atpull \
#    zdharma/null



autoload bashcompinit 
bashcompinit
autoload -U compinit 
compinit



zinit cdreplay -q # <- execute compdefs provided by rest of plugins

# Pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

export PYENV_VIRTUALENV_DISABLE_PROMPT=1

# LOAD P10K LAST
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


