/**
  Nushell feature.

  Nushell with direnv integration and fish-style prompt.
*/
let
  mod =
    { lib, pkgs, ... }:
    let
      scripts = pkgs.symlinkJoin {
        name = "nushell-scripts";
        paths = [ ./scripts ];
      };
    in
    {
      home.shell.enableNushellIntegration = true;

      programs.nushell = {
        enable = lib.mkDefault true;
        package = pkgs.nushell;

        plugins = with pkgs.nushellPlugins; [
          gstat
        ];

        shellAliases = {
          l = "lazygit";
          o = "opencode";
          y = "yazi";
          wt = "git worktree";
        };

        settings = {
          show_banner = false;
          completions = {
            case_sensitive = false;
            quick = true;
            partial = true;
            algorithm = "fuzzy";
          };
          history = {
            file_format = "sqlite";
            max_size = 100000;
          };
        };

        extraConfig = ''
          # Custom scripts
          use ${scripts}/nerd-grep.nu

          # Prompt configuration
          def create_left_prompt [] {
            let last_exit = $env.LAST_EXIT_CODE

            # user@host in green
            let user_host = $"(ansi green_bold)($env.USER)@(hostname)(ansi reset)"

            # git branch with icon in magenta
            let git_branch = do {
              let branch = (do { git branch --show-current } | complete)
              if $branch.exit_code == 0 and ($branch.stdout | str trim) != "" {
                $" (ansi magenta_bold)󰘬 ($branch.stdout | str trim)(ansi reset)"
              } else {
                ""
              }
            }

            # nix shell indicator in blue
            let nix_shell = if ($env.IN_NIX_SHELL? | default "" | is-not-empty) {
              $" (ansi blue_bold) (ansi reset)"
            } else {
              ""
            }

            # prompt suffix: red on error, blue on success
            let suffix = if $last_exit != 0 {
              $"(ansi red_bold)   (ansi reset)"
            } else {
              $"(ansi blue_bold)   (ansi reset)"
            }

            $"($user_host)($git_branch)($nix_shell)($suffix)"
          }

          def create_right_prompt [] {
            # full path in dim gray
            $"(ansi dark_gray) ($env.PWD)(ansi reset)"
          }

          $env.PROMPT_COMMAND = {|| create_left_prompt }
          $env.PROMPT_COMMAND_RIGHT = {|| create_right_prompt }
          $env.PROMPT_INDICATOR = ""
          $env.PROMPT_INDICATOR_VI_INSERT = ""
          $env.PROMPT_INDICATOR_VI_NORMAL = ""
          $env.PROMPT_MULTILINE_INDICATOR = "::: "
        '';

        extraEnv = ''
          # direnv hook
          $env.config = ($env.config? | default {} | merge {
            hooks: {
              pre_prompt: [
                {||
                  if (which direnv | is-not-empty) {
                    direnv export json | from json | default {} | load-env
                  }
                }
              ]
            }
          })
        '';
      };

      programs.direnv = {
        enable = true;
        nix-direnv.enable = true;
      };
    };
in
{
  __exports.shared.hm.value = mod;
  __module = mod;
}
