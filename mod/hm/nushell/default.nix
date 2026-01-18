/**
  Nushell feature.

  Nushell with direnv integration and fish-style prompt.
*/
{
  __inputs = {
    imp-cli.url = "github:imp-nix/imp.cli";
    imp-cli.inputs.nixpkgs.follows = "nixpkgs";
    imp-gits.url = "github:imp-nix/imp.gits";
    imp-gits.inputs.nixpkgs.follows = "nixpkgs";
    imp-lint.url = "github:imp-nix/imp.lint";
    imp-lint.inputs.nixpkgs.follows = "nixpkgs";
  };

  __functor =
    _: _:
    let
      mod =
        {
          inputs,
          lib,
          pkgs,
          config,
          ...
        }:
        let
          scripts = pkgs.symlinkJoin {
            name = "nushell-scripts";
            paths = [ ./scripts ];
          };
          impCli = inputs.imp-cli.packages.${pkgs.system}.default;
          impGits = inputs.imp-gits.packages.${pkgs.system}.default;
          impLint = inputs.imp-lint.packages.${pkgs.system}.imp-lint;
        in
        {
          home.shell.enableNushellIntegration = true;

          home.packages = [
            impCli
            impGits
            impLint
            pkgs.pandoc
          ];

          programs.nushell = {
            enable = lib.mkDefault true;
            package = pkgs.nushell;

            plugins = with pkgs.nushellPlugins; [
              gstat
            ];

            shellAliases = {
              j = "worktree-jump";
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
              use ${scripts}/worktree-jump.nu
              use ${scripts}/pandoc-media.nu
              use ${scripts}/icons.nu *

              # imp modules (Nu-only)
              use ${config.home.profileDirectory}/lib/imp *
              use ${config.home.profileDirectory}/lib/imp-gits *
              use ${config.home.profileDirectory}/lib/imp-lint *
              def create_left_prompt [] {
                let last_exit = $env.LAST_EXIT_CODE

                let path = $env.PWD | str replace $env.HOME "~"
                let top_line = $"(ansi dark_gray)╭─(ansi reset) (ansi cyan)($path)(ansi reset)"

                # git branch with icon in magenta
                let git_branch = do {
                  let branch = (do { git branch --show-current } | complete)
                  if $branch.exit_code == 0 and ($branch.stdout | str trim) != "" {
                    $" (ansi magenta_bold)($ICON_GIT_BRANCH) ($branch.stdout | str trim)(ansi reset)"
                  } else {
                    ""
                  }
                }

                let nix_shell = if ($env.IN_NIX_SHELL? | default "" | is-not-empty) {
                  $" (ansi blue_bold)($ICON_NIX) (ansi reset)"
                } else {
                  ""
                }

                let corner_color = if $last_exit != 0 { ansi red } else { ansi dark_gray }
                let bottom_line = $"($corner_color)╰─(ansi reset)($git_branch)($nix_shell) "

                $"($top_line)\n($bottom_line)"
              }

              $env.PROMPT_COMMAND = {|| create_left_prompt }
              $env.PROMPT_COMMAND_RIGHT = {|| "" }
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
              $env.EDITOR = "xeno"

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
    };
}
