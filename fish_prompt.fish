function fish_prompt

  set -l last_command_status $status
  set -l cwd (basename (prompt_pwd))
  set -l vwd (basename "$VIRTUAL_ENV")

  set -l fish       "⋊>"
  set -l dead_fish  "<⋉"
  set -l ahead      "(ahead)"
  set -l behind     "(behind)"
  set -l diverged   "(diverged)"
  set -l dirty      "(dirty)"
  set -l none       ""

  set -l blue 8be9fd
  set -l red ff8888
  set -l pink ff89d6
  set -l yellow f1fa8c

  set -l normal_color     (set_color normal)
  set -l success_color    (set_color cyan)
  set -l error_color      (set_color red)
  set -l username_color   (set_color $red)
  set -l hostname_color   (set_color white)
  set -l directory_color  (set_color $yellow)
  set -l repository_color (set_color $blue)

  set -gx LSCOLORS gxfxbEaEBxxEhEhBaDaCaD
  set -gx fish_color_command green
  set -gx fish_color_error red
  set -gx fish_color_param yellow

  function username --no-scope-shadowing
    echo -n -s $username_color $USER $normal_color
  end

  function machine --no-scope-shadowing
	if test $SSH_CLIENT
	  echo -n -s $hostname_color @(hostname) $normal_color
	else
	  echo -s -s ""
	end
  end

  function directory --no-scope-shadowing
    echo -n -s $directory_color $cwd $normal_color
  end

  function git_repository --no-scope-shadowing
    echo -n -s $repository_color (git_branch_name) $normal_color
  end

  function git_status --no-scope-shadowing
    if git_is_touched
      echo -n -s $dirty
    else
      echo -n -s (git_ahead $ahead $behind $diverged $none)
    end
  end

  function git_prompt --no-scope-shadowing
    if git_is_repo
      echo -n on (git_repository) (git_status)
    end
  end

  function fish_status --no-scope-shadowing
    if test $last_command_status -eq 0
      echo -n -s $success_color $fish $normal_color
    else
      echo -n -s $success_color $dead_fish $normal_color
    end
  end

  function venv_status --no-scope-shadowing
    if test $VIRTUAL_ENV
      echo -n -s "($vwd)"
    end
  end

  echo -n (venv_status) (username)(machine) in (directory) (git_prompt) (fish_status) ""

end
