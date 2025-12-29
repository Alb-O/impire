/**
  Fish shell feature.

  Fish with direnv integration.
*/
let
  mod =
    { lib, ... }:
    {
      programs.fish = {
        enable = lib.mkDefault true;
        shellAbbrs = {
          l = "lazygit";
          o = "opencode";
          y = "yazi";
          wt = "git worktree";
        };
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
