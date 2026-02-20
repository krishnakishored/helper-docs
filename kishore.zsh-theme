#!/usr/bin/env zsh
# ~/.oh-my-zsh/themes/kishore.zsh-theme
# Clean theme with:
# 1) two-line prompt
# 2) git branch/status via oh-my-zsh git plugin
# 3) git account label read from ~/.gitconfig (single source of truth)

########## COLORS ##########
for COLOR in CYAN WHITE YELLOW MAGENTA BLACK BLUE RED DEFAULT GREEN GREY; do
  eval PR_$COLOR='%{$fg[${(L)COLOR}]%}'
  eval PR_BRIGHT_$COLOR='%{$fg_bold[${(L)COLOR}]%}'
done
PR_RESET="%{$reset_color%}"

# Optional ls colors (kept from your previous setup)
export LS_COLORS="di=1;34:ln=35:so=32:pi=33:ex=31:bd=36;46:cd=36;43:su=30;41:sg=30;46:tw=30;42:ow=30;43:*.sh=1;32:*.bash=1;32:*.zsh=1;32:*.fish=1;32:*.csh=1;32:*.ksh=1;32"
export LSCOLORS="exfxcxdxbxexedabagacad"

########## STYLE ##########
RED_START="${PR_RESET}${PR_RED}@ "
GREEN_END="${PR_RESET}${PR_BRIGHT_GREEN} |"
GREEN_BASE_START="${PR_RESET}${PR_GREEN}➜ "
GREEN_START_P1="${PR_RESET}${GREEN_BASE_START}${PR_RESET} "

########## GIT/SVN PROMPT SETTINGS ##########
VCS_DIRTY_COLOR="${PR_RESET}${PR_YELLOW}"
VCS_CLEAN_COLOR="${PR_RESET}${PR_GREEN}"

ZSH_THEME_SVN_PROMPT_PREFIX="${PR_RESET}${PR_RED}‹svn:"
ZSH_THEME_SVN_PROMPT_SUFFIX=""
ZSH_THEME_SVN_PROMPT_DIRTY="${VCS_DIRTY_COLOR} ✘"
ZSH_THEME_SVN_PROMPT_CLEAN="${VCS_CLEAN_COLOR} ✔"

ZSH_THEME_GIT_PROMPT_PREFIX="${PR_RESET}${PR_BLUE} | gb: "
ZSH_THEME_GIT_PROMPT_SUFFIX=""
ZSH_THEME_GIT_PROMPT_DIRTY="${VCS_DIRTY_COLOR} ✘"
ZSH_THEME_GIT_PROMPT_CLEAN="${VCS_CLEAN_COLOR} ✔"
ZSH_THEME_GIT_PROMPT_ADDED="${PR_RESET}${PR_YELLOW} ✚${PR_RESET}"
ZSH_THEME_GIT_PROMPT_MODIFIED="${PR_RESET}${PR_YELLOW} ✹${PR_RESET}"
ZSH_THEME_GIT_PROMPT_DELETED="${PR_RESET}${PR_YELLOW} ✖${PR_RESET}"
ZSH_THEME_GIT_PROMPT_RENAMED="${PR_RESET}${PR_YELLOW} ➜${PR_RESET}"
ZSH_THEME_GIT_PROMPT_UNMERGED="${PR_RESET}${PR_YELLOW} ═${PR_RESET}"
ZSH_THEME_GIT_PROMPT_UNTRACKED="${PR_RESET}${PR_YELLOW} ✭${PR_RESET}"

########## HELPERS ##########
precmd() {
  # Keep precmd lightweight.
  PROMPT_HEAD="${RED_START}${PR_YELLOW}${PR_RESET}"
}

prompt_context() {
  # Current directory path
  echo -n "${PR_RESET}${PR_MAGENTA}%~%<<${PR_RESET}"
}

append_version_string() {
  # Show node/python versions only when project markers exist.
  local version_string=""

  if [[ -f .nvmrc && $+commands[node] -eq 1 ]]; then
    version_string+="%F{green} | node:$(node -v)%f"
  fi

  if [[ -f .python-version && $+commands[python] -eq 1 ]]; then
    version_string+="%F{yellow} | py:v$(python --version 2>&1 | awk '{print $2}')%f"
  fi

  echo "$version_string"
}

git_account_prompt() {
  # Show account only inside git repos.
  command git rev-parse --is-inside-work-tree >/dev/null 2>&1 || return

  local remote host account
  remote="$(git config --get remote.origin.url 2>/dev/null)"

  # SSH form: git@host-alias:org/repo.git
  if [[ "$remote" =~ '^git@([^:]+):' ]]; then
    host="${match[1]}"
  # HTTPS form: https://host/org/repo.git
  elif [[ "$remote" =~ '^https?://([^/]+)/' ]]; then
    host="${match[1]}"
  fi

  [[ -z "$host" ]] && host="unknown"

  # Read label from ~/.gitconfig:
  # [prompt "account"]
  #   github-kcodek = gh-kcodek
  account="$(git config --global --get "prompt.account.${host}" 2>/dev/null)"
  [[ -z "$account" ]] && account="$host"

  echo "%F{cyan} | ✭ ${account}%f"
}

########## PROMPT ##########
set_prompt() {
  setopt prompt_subst
  autoload zsh/terminfo

  PROMPT='${PROMPT_HEAD}$(prompt_context)$(append_version_string)$(git_prompt_info)$(git_account_prompt)
${GREEN_START_P1}'

  RPROMPT='${PR_RESET}${GREEN_END}${PR_RESET}'
  PROMPT2='${GREEN_BASE_START}${PR_RESET} %_ ${GREEN_BASE_START}${PR_RESET} '
}

set_prompt
