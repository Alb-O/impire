/**
  Lazygit feature.

  Terminal UI for git.
*/
let
  mod =
    { ... }:
    {
      programs.lazygit = {
        enable = true;
        settings = {
          gui = {
            theme = {
              authorColors."*" = "#268bd2"; # blue
              activeBorderColor = [ "#2aa198" "bold" ]; # cyan, bright
              inactiveBorderColor = [ "#586e75" ];       # dim base01
              selectedLineBgColor = [ "#073642" ];       # base02
              selectedRangeBgColor = [ "#073642" ];
              optionsTextColor = [ "#93a1a1" ];          # base1
              cherryPickedCommitBgColor = [ "#b58900" ]; # yellow
              cherryPickedCommitFgColor = [ "#002b36" ]; # base03
              unstagedChangesColor = [ "#cb4b16" ];      # orange
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
            border = "single";
            nerdFontsVersion = "3";
            showFileIcons = true;
          };
          git = {
            useExternalDiffGitConfig = true;
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
            editPreset = "kak";
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
