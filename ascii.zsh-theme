# derived from minimal.zsh-themme
# put this file in .oh-my-zsh/custom/

# got visualization of "git stash" from
# https://github.com/yoshiori/oh-my-zsh-yoshiori/blob/master/yoshiori.zsh-theme

# add visualization of rebase

# import $(git_prompt_status) from lib/git.zsh

ZSH_THEME_GIT_PROMPT_PREFIX="["
ZSH_THEME_GIT_PROMPT_SUFFIX="]"
ZSH_THEME_GIT_PROMPT_DIRTY="*"
ZSH_THEME_GIT_PROMPT_CLEAN=""
ZSH_THEME_GIT_PROMPT_STASH_COUNT_BEFORE="#stash="
ZSH_THEME_GIT_PROMPT_STASH_COUNT_AFTER=""
ZSH_THEME_GIT_PROMPT_UNTRACKED="*untracked"
ZSH_THEME_GIT_PROMPT_UNMERGED="*unmerged"
ZSH_THEME_GIT_PROMPT_DELETED="*deleted"
ZSH_THEME_GIT_PROMPT_RENAMED="*renamed"
ZSH_THEME_GIT_PROMPT_MODIFIED="*modified"
ZSH_THEME_GIT_PROMPT_ADDED="*added"
ZSH_THEME_GIT_PROMPT_REBASING="*rebasing"

# called to show git's state on prompt
# original (minimal.zsh) impl. used $(current_branch) as a switch,
# so it doesn't work when detached head
git_custom_status() {
  local head=$(git_get_head)
  if [ -n "$head" ]; then
    echo -n "$ZSH_THEME_GIT_PROMPT_PREFIX"
    echo -n "$(parse_git_dirty)$head"
    echo -n "$(git_is_rebasing)$(git_prompt_stash_count)"
    echo -n "$(git_prompt_status)"
    echo -n "$ZSH_THEME_GIT_PROMPT_SUFFIX"
  fi
}

# git head
# when in git repos, returns symbolic-ref or short hash, otherwise empty string
function git_get_head(){
  local cb=$(current_branch) # current_branch is in git.plugin.zsh
  if [ -n "$cb" ]; then # if current_branch non-zero
    echo $cb
    return
  fi
  local head=$(git reflog 2>/dev/null | head -n 1 | cut -c 1-7)
  echo "$head"
}

function git_is_rebasing(){
  local rb=$(_git_is_rebasing)
  if [ "$rb" = "rebasing" ]; then
    echo "$ZSH_THEME_GIT_PROMPT_REBASING"
  fi
}

function git_is_rebasing() {
    local topdir=$(git rev-parse --show-toplevel 2>/dev/null)
    if [ $? -eq 0 ]; then
        if [ -d $topdir/.git/rebase-merge ]; then
            echo "$ZSH_THEME_GIT_PROMPT_REBASING"
        fi
    fi
}

# git stash count
function git_prompt_stash_count(){
  COUNT=$(git stash list 2>/dev/null | wc -l | tr -d ' ')
  if [ "$COUNT" -gt 0 ]; then
    echo "$ZSH_THEME_GIT_PROMPT_STASH_COUNT_BEFORE$COUNT$ZSH_THEME_GIT_PROMPT_STASH_COUNT_AFTER"
  fi
}


PROMPT='%1~$(git_custom_status)$%b '