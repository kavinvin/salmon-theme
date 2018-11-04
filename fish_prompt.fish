function fish_prompt

  set -l last_command_status $status
  set -l cwd (basename (prompt_pwd))

  set -l fish     "⋊>"
  set -l ahead    "↑"
  set -l behind   "↓"
  set -l diverged "⥄ "
  set -l dirty    "⨯"
  set -l none     ""

  set -l normal_color     (set_color normal)
  set -l success_color    (set_color cyan)
  set -l error_color      (set_color red)
  set -l username_color   (set_color red)
  set -l directory_color  (set_color brown)
  set -l repository_color (set_color green)

  function username --no-scope-shadowing
    echo -n -s $username_color $USER $normal_color
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
