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
        function __cargo_project_name
          set -l git_root (git rev-parse --show-toplevel 2>/dev/null)
          if test -z "$git_root"
            return 1
          end

          set -l git_path "$git_root/.git"

          if test -f "$git_path"
            set -l gitdir_content (cat "$git_path" | string replace "gitdir: " "")

            # Resolve relative gitdir paths (relative to the .git file location)
            set -l gitdir_path "$gitdir_content"
            if not string match -q "/*" "$gitdir_path"
              set gitdir_path (path resolve (dirname "$git_path")/"$gitdir_path")
            end

            if string match -q "*/.git/modules/*" "$gitdir_path"
              set -l module_path (string replace -r ".*/\\.git/modules/" "" "$gitdir_path")
              echo (string replace -r "/worktrees/.*" "" "$module_path")
              return 0

            else if string match -q "*/worktrees/*" "$gitdir_path"
              set -l repo_git_dir (string replace -r "/worktrees/.*" "" "$gitdir_path")

              if test (basename "$repo_git_dir") = ".git"
                # non-bare worktree: ".../repo/.git/worktrees/<name>"
                echo (basename (dirname "$repo_git_dir"))
              else
                # bare worktree: ".../evildoer.git/worktrees/<name>"
                echo (basename "$repo_git_dir")
                # if you want to strip ".git", use:
                # echo (basename "$repo_git_dir" | string replace -r "\\.git\$" "")
              end
              return 0
            end
          end

          echo (basename "$git_root")
        end

        function __update_cargo_target_dir --on-variable PWD
          # Only set in directories with Cargo.toml
          if not test -f Cargo.toml
            if set -q CARGO_TARGET_DIR
              set -e CARGO_TARGET_DIR
            end
            return
          end

          set -l project_name (__cargo_project_name)
          if test -n "$project_name"
            set -gx CARGO_TARGET_DIR "${cacheHome}/cargo/targets/$project_name"
          end
        end

        # Run once on shell startup
        __update_cargo_target_dir
      '';
    in
    {
      programs.fish.interactiveShellInit = cargoTargetDirScript;

      # Ensure the cache directory exists
      home.file."${cacheHome}/cargo/targets/.keep".text = "";
    };
in
{
  __exports.shared.hm.value = mod;
  __module = mod;
}
