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
          use_kitty_protocol = true;

          shell_integration = {
            osc2 = true; # window title
            osc7 = true; # current directory (enables click-to-cd in kitty)
            osc133 = true; # prompt markers (semantic shell integration)
          };

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

          menus = [
            {
              name = "completion_menu";
              only_buffer_difference = false;
              marker = " ";
              type = {
                layout = "ide";
                min_completion_width = 0;
                max_completion_width = 150;
                max_completion_height = 25;
                padding = 0;
                border = false;
                cursor_offset = 0;
                description_mode = "prefer_right";
                min_description_width = 0;
                max_description_width = 50;
                max_description_height = 10;
                description_offset = 1;
                correct_cursor_pos = true;
              };
              style = {
                text = "white";
                selected_text = "white_reverse";
                description_text = "yellow";
                match_text = "{ attr: u }";
                selected_match_text = "{ attr: ur }";
              };
            }
          ];
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

          # Store last command output in $env.last, retrieve with `_`
          $env.config.hooks.display_output = {||
            tee { table --expand | print }
            | try { if $in != null { $env.last = $in } }
          }

          def _ []: nothing -> any { $env.last? }
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
