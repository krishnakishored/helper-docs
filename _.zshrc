# ~/.zshrc
# Cleaned setup for Oh My Zsh + nvm + pyenv + kubectl + uv

# ---------- Oh My Zsh ----------
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="kishore"
plugins=(git uv)

# Load Oh My Zsh (includes completion setup; no separate compinit needed)
source "$ZSH/oh-my-zsh.sh"

# ---------- Aliases ----------
alias k="kubectl"

# ---------- NVM ----------
export NVM_DIR="$HOME/.nvm"
[[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"
[[ -s "$NVM_DIR/bash_completion" ]] && source "$NVM_DIR/bash_completion"

# Auto-switch node version when entering a directory with .nvmrc
load-nvmrc() {
  command -v nvm >/dev/null 2>&1 || return
  local nvmrc_path
  nvmrc_path="$(nvm_find_nvmrc 2>/dev/null)"
  if [[ -n "$nvmrc_path" ]]; then
    nvm use --silent >/dev/null
  fi
}
autoload -U add-zsh-hook
add-zsh-hook chpwd load-nvmrc
load-nvmrc

# ---------- Pyenv ----------
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

if command -v pyenv >/dev/null 2>&1; then
  eval "$(pyenv init --path)"
  eval "$(pyenv init -)"
  eval "$(pyenv virtualenv-init -)"
fi

# Recommended: use `pyenv local <version/env>` per project instead of auto-activating here.

# ---------- Tool completions ----------
# kubectl completion (only if installed)
if command -v kubectl >/dev/null 2>&1; then
  source <(kubectl completion zsh)
fi

# uv / uvx completions (only if installed)
if command -v uv >/dev/null 2>&1; then
  eval "$(uv generate-shell-completion zsh)"
fi
if command -v uvx >/dev/null 2>&1; then
  eval "$(uvx --generate-shell-completion zsh)"
fi

# ---------- Environment cleanup ----------
unset MINIKUBE_HOME
