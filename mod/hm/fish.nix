/**
  Fish shell feature.

  Fish with direnv integration.
*/
let
  mod =
    { lib, ... }:
    {
      programs.fish = {
        enable = lib.mkDefault false;
        shellAbbrs = {
          l = "lazygit";
          o = "opencode";
          y = "yazi";
          wt = "git worktree";
        };
        functions.fish_prompt = ''
          set -l last_status $status

          # user@host
          set_color brgreen
          echo -n $USER@(prompt_hostname)
          set_color normal

          # git branch
          set -l git_branch (fish_git_prompt '%s' 2>/dev/null)
          if test -n "$git_branch"
            set_color brmagenta
            echo -n " 󰘬 $git_branch"
            set_color normal
          end

          # nix shell indicator
          if test -n "$IN_NIX_SHELL"
            set_color brblue
            echo -n '  '
            set_color normal
          end

          # prompt suffix
          if test $last_status -ne 0
            set_color brred
            echo -n '   '
          else
            set_color brblue
            echo -n '   '
          end
          set_color normal
        '';
        functions.yy = ''
          set tmp (mktemp -t "yazi-cwd.XXXXXX")
          command yazi $argv --cwd-file="$tmp"
          set cwd (cat "$tmp")
          if test -n "$cwd" -a "$cwd" != "$PWD"
            cd -- "$cwd"
          end
          rm -f -- "$tmp"
        '';
        functions.fish_right_prompt = ''
          set_color brblack
          echo -n ' '(prompt_pwd --full-length-dirs 100)
          set_color normal
        '';
        interactiveShellInit = ''
          abbr --add wt 'git worktree'

          function __abbr_git_worktree --argument-names tok
            set -l w (commandline -opc)

            # Expect: git worktree <tok>
            if test (count $w) -ge 3; and test $w[1] = git; and test $w[2] = worktree
              switch $tok
                case a
                  echo add; return 0
                case r
                  echo remove; return 0
              end
            end

            return 1
          end

          abbr --add --command git --function __abbr_git_worktree a
          abbr --add --command git --function __abbr_git_worktree r
        '';

      };

      programs.direnv = {
        enable = true;
        nix-direnv.enable = true;
      };

      programs.bash.enable = lib.mkForce false;
    };
in
{
  __exports.shared.hm.value = mod;
  __module = mod;
}
