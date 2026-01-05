/**
  Cargo feature.

  Sets CARGO_TARGET_DIR dynamically based on project name to enable sccache
  hits across git worktrees while keeping submodules separate.
*/
let
  mod =
    { config, ... }:
    let
      cacheHome = config.xdg.cacheHome;

      # Shell function to compute project name from git root
      # Handles: worktrees (uses main worktree name), submodules (uses submodule dir name)
      cargoTargetDirScript = ''
        # Check if a directory is a bare git repo (has HEAD, objects/, refs/)
        def __is_bare_repo [dir: string]: nothing -> bool {
          ([
            (($"($dir)/HEAD" | path type) == "file")
            (($"($dir)/objects" | path type) == "dir")
            (($"($dir)/refs" | path type) == "dir")
          ] | all { $in })
        }

        # Walk up directory tree to find a bare repo
        def __find_bare_repo []: nothing -> string {
          mut current = (pwd)
          mut result = ""
          while true {
            if (__is_bare_repo $current) {
              $result = $current
              break
            }
            let parent = ($current | path dirname)
            if $parent == $current {
              break
            }
            $current = $parent
          }
          $result
        }

        # Extract project name from bare repo path (strips .git suffix if present)
        def __bare_repo_name [path: string]: nothing -> string {
          $path | path basename | str replace --regex '\.git$' ""
        }

        # Compute project name from git root
        # Handles: worktrees (uses main worktree name), submodules (uses submodule dir name),
        # and bare repo subdirectories (orchestration dirs)
        def __cargo_project_name []: nothing -> string {
          let git_root = (do { git rev-parse --show-toplevel } | complete)
          if $git_root.exit_code != 0 {
            # Not in a worktree - check if we're inside a bare repo structure
            let bare_repo = (__find_bare_repo)
            if ($bare_repo | is-not-empty) {
              return (__bare_repo_name $bare_repo)
            }
            return ""
          }
          let git_root = ($git_root.stdout | str trim)

          let git_path = $"($git_root)/.git"

          if ($git_path | path type) == "file" {
            let gitdir_content = (open --raw $git_path | str replace "gitdir: " "" | str trim)

            # Resolve relative gitdir paths (relative to the .git file location)
            let gitdir_path = if ($gitdir_content | str starts-with "/") {
              $gitdir_content
            } else {
              $"($git_path | path dirname)/($gitdir_content)" | path expand
            }

            if ($gitdir_path =~ "/.git/modules/") {
              let module_path = ($gitdir_path | str replace --regex '.*/\.git/modules/' "")
              return ($module_path | str replace --regex "/worktrees/.*" "")

            } else if ($gitdir_path =~ "/worktrees/") {
              let repo_git_dir = ($gitdir_path | str replace --regex "/worktrees/.*" "")

              if ($repo_git_dir | path basename) == ".git" {
                # non-bare worktree: ".../repo/.git/worktrees/<name>"
                return ($repo_git_dir | path dirname | path basename)
              } else {
                # bare worktree: ".../evildoer.git/worktrees/<name>"
                return ($repo_git_dir | path basename | str replace --regex '\.git$' "")
              }
            }
          }

          $git_root | path basename
        }

        def --env __update_cargo_target_dir [] {
          let project_name = (__cargo_project_name)
          if ($project_name | is-not-empty) {
            $env.CARGO_TARGET_DIR = $"${cacheHome}/cargo/targets/($project_name)"
          } else if "CARGO_TARGET_DIR" in $env {
            hide-env CARGO_TARGET_DIR
          }
        }

        # Hook to update CARGO_TARGET_DIR on directory change
        $env.config.hooks.env_change.PWD = (
          ($env.config.hooks.env_change.PWD? | default []) | append {|before, after| __update_cargo_target_dir }
        )

        # Run once on shell startup
        __update_cargo_target_dir
      '';
    in
    {
      programs.nushell.extraConfig = cargoTargetDirScript;

      # Ensure the cache directory exists
      home.file."${cacheHome}/cargo/targets/.keep".text = "";
    };
in
{
  __exports.shared.hm.value = mod;
  __module = mod;
}
