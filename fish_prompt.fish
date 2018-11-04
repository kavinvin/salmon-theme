# You can override some default options with config.fish:
#
set -g theme_short_path yes

function fish_prompt

  set -l fish     "⋊>"
  set -l ahead    "↑"
  set -l behind   "↓"
  set -l diverged "⥄ "
  set -l dirty    "⨯"
  set -l none     "◦"

  set -l red_color        (set_color red)
  set -l normal_color     (set_color normal)
  set -l success_color    (set_color $fish_pager_color_progress ^/dev/null; or set_color cyan)
  set -l error_color      (set_color $fish_color_error ^/dev/null; or set_color red --bold)
  set -l directory_color  (set_color $fish_color_quote ^/dev/null; or set_color brown)
  set -l repository_color (set_color $fish_color_cwd ^/dev/null; or set_color green)
  set -l fish_pager_color_progress cyan
 
  set -l last_command_status $status
  set -l cwd (basename (prompt_pwd))

  function username --no-scope-shadowing
    echo -n -s $red_color $USER $normal_color
  end

  function directory --no-scope-shadowing
    echo -n -s $directory_color $cwd $normal_color
  end

  function git_prompt --no-scope-shadowing
    echo -n -s $repository_color (git_branch_name) $normal_color
  end

  function git_status --no-scope-shadowing
    if git_is_touched
      echo -n -s $dirty
    else
      echo -n -s (git_ahead $ahead $behind $diverged $none)
    end
  end

  function fish_status --no-scope-shadowing
    if test $last_command_status -eq 0
      echo -n -s $success_color $fish $normal_color
    else
      echo -n -s $error_color $fish $normal_color
    end
  end

  if git_is_repo
    echo -n (username) in (directory) on (git_prompt) (git_status) (fish_status) ""
  else
    echo -n (username) in (directory) (fish_status) ""
  end

end
