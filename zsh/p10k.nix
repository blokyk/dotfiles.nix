{ config, ... }: {
  programs.zsh-powerlevel10k = {
    enable = true;
    theme = config.programs.zsh-powerlevel10k.themes.robbyrussell // {
      mode = "ascii";

      # this is the default robbyrussell git indicator, but with an
      # added pink '*' next to the branch if there are any changes
      # in the stash
      vcs.formatter = ''
        emulate -L zsh
        if [[ -n $P9K_CONTENT ]]; then
          # If P9K_CONTENT is not empty, it's either "loading" or from vcs_info (not from
          # gitstatus plugin). VCS_STATUS_* parameters are not available in this case.
          typeset -g my_git_format=$P9K_CONTENT
        else
          # Use VCS_STATUS_* parameters to assemble Git status. See reference:
          # https://github.com/romkatv/gitstatus/blob/master/gitstatus.plugin.zsh.

          # bold purple 'git:(' prefix
          typeset -g my_git_format="''${1+%B%4F}git:(''${1+%1F}"

          # either the branch name, or the commit if detached
          my_git_format+=''${''${VCS_STATUS_LOCAL_BRANCH:-''${VCS_STATUS_COMMIT[1,8]}}//\%/%%}

          # if there are things in the stash, add a pink star after the branch name
          if (( VCS_STATUS_STASHES >= 0 )); then
            my_git_format+="''${1+%13F}*"
          fi
          my_git_format+="''${1+%4F})"
          if (( VCS_STATUS_NUM_CONFLICTED || VCS_STATUS_NUM_STAGED ||
                VCS_STATUS_NUM_UNSTAGED   || VCS_STATUS_NUM_UNTRACKED )); then
            my_git_format+=" ''${1+%3F}✗"
          fi
        fi
      '';
    };
  };
}
