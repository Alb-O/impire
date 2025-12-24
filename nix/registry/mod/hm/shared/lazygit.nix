/**
  Lazygit feature.

  Terminal UI for git.
*/
{
  __inputs.nix-colorizer = {
    url = "github:nutsalhan87/nix-colorizer";
  };
}
// (
  let
    mod =
      { config, inputs, ... }:
      let
        colors = config.lib.stylix.colors;
        colorizer = inputs.nix-colorizer.hex;
        # Darken the accent colors for subtle diff backgrounds (preserves hue)
        minusBg = colorizer.darken "#${colors.base08}" 0.55;
        minusEmphBg = colorizer.darken "#${colors.base08}" 0.45;
        plusBg = colorizer.darken "#${colors.base0B}" 0.55;
        plusEmphBg = colorizer.darken "#${colors.base0B}" 0.45;
        # Use blue/magenta for moved lines to distinguish from add/remove
        movedFromBg = colorizer.darken "#${colors.base0D}" 0.50;
        movedToBg = colorizer.darken "#${colors.base0E}" 0.50;
      in
      {
        programs.delta = {
          enable = true;
          options = {
            syntax-theme = "base16";
            features = "my-color-moved-theme";
            my-color-moved-theme = {
              # Map git's color-moved output to syntax highlighting with colored bg
              map-styles = "bold purple => syntax ${movedFromBg}, bold cyan => syntax ${movedToBg}";
              minus-style = "syntax ${minusBg}";
              minus-emph-style = "syntax ${minusEmphBg}";
              plus-style = "syntax ${plusBg}";
              plus-emph-style = "syntax ${plusEmphBg}";
              zero-style = "syntax";
            };
          };
        };
        programs.lazygit = {
          enable = true;
          settings = {
            gui = {
              theme = {
                authorColors."*" = "#${colors.base0D}";
                activeBorderColor = [
                  "#${colors.base0C}"
                  "bold"
                ];
                inactiveBorderColor = [ "#${colors.base03}" ];
                selectedLineBgColor = [ "#${colors.base02}" ];
                selectedRangeBgColor = [ "#${colors.base02}" ];
                optionsTextColor = [ "#${colors.base05}" ];
                cherryPickedCommitBgColor = [ "#${colors.base0A}" ];
                cherryPickedCommitFgColor = [ "#${colors.base00}" ];
                unstagedChangesColor = [ "#${colors.base09}" ];
              };
              scrollHeight = 2;
              scrollPastBottom = true;
              tabWidth = 2;
              mouseEvents = true;
              sidePanelWidth = 0.3333;
              language = "auto";
              timeFormat = "02 Jan 06";
              shortTimeFormat = "3:04PM";
              showListFooter = true;
              showFileTree = true;
              showCommandLog = true;
              showBottomLine = true;
              commandLogSize = 8;
              nerdFontsVersion = "3";
              showFileIcons = true;
              border = "single";
            };
            git = {
              pagers = [
                {
                  pager = "delta --paging=never --line-numbers --hyperlinks --hyperlinks-file-link-format=\"lazygit-edit://{path}:{line}\"";
                }
              ];
              commit = {
                signOff = false;
                autoWrapCommitMessage = true;
                autoWrapWidth = 72;
              };
              merging = {
                manualCommit = false;
                args = "";
              };
              mainBranches = [
                "master"
                "main"
              ];
              autoFetch = true;
              autoRefresh = true;
              fetchAll = true;
              branchLogCmd = "git log --graph --color=always --abbrev-commit --decorate --date=relative --pretty=medium {{branchName}} --";
              allBranchesLogCmds = [
                "git log --graph --all --color=always --abbrev-commit --decorate --date=relative --pretty=medium"
              ];
              log = {
                order = "topo-order";
                showGraph = "always";
                showWholeGraph = false;
              };
            };
            os = {
              editPreset = "kakoune";
              open = "xdg-open {{filename}} >/dev/null";
            };
            keybinding = {
              universal = {
                quit = "q";
                return = "<esc>";
                nextItem = "<down>";
                prevItem = "<up>";
                "nextItem-alt" = "j";
                "prevItem-alt" = "k";
                goInto = "<enter>";
                confirm = "<enter>";
                remove = "d";
                new = "n";
                edit = "e";
                openFile = "o";
                executeShellCommand = ":";
                refresh = "R";
                nextTab = "]";
                prevTab = "[";
                undo = "z";
                redo = "Z";
              };
              files = {
                commitChanges = "c";
                ignoreFile = "i";
                refreshFiles = "r";
                stashAllChanges = "s";
                toggleStagedAll = "a";
              };
              branches = {
                checkoutBranchByName = "c";
                rebaseBranch = "r";
                mergeIntoCurrentBranch = "M";
              };
              commits = {
                squashDown = "s";
                renameCommit = "r";
                pickCommit = "p";
                revertCommit = "t";
                cherryPickCopy = "C";
                pasteCommits = "V";
              };
            };
          };
        };
      };
  in
  {
    __exports.shared.hm.value = mod;
    __module = mod;
  }
)
