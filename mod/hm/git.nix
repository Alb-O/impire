/**
  Git feature.

  Version control with helpful defaults. Uses sops for gitea credentials when available.
*/
let
  mod =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    let
      giteaCredentials = "git/gitea/credentials";
      hasSops = config ? sops && config.sops ? secrets;
    in
    {
      home.packages = with pkgs; [
        git-toolbelt
      ];

      sops.secrets = lib.mkIf hasSops {
        "${giteaCredentials}" = { };
      };

      programs.git = {
        enable = true;
        lfs.enable = true;

        ignores = [
          ".DS_Store"
          "Thumbs.db"
          "*~"
          "*.swp"
          "*.tmp"
          "*.log"
          "*.blend1"
          "node_modules/"
          "dist/"
          "target/"
        ];

        settings = {
          alias = {
            undo = "reset --soft HEAD~1";
            unstage = "reset HEAD --";
            last = "log -1 HEAD";
            visual = "!gitk";
            cleanup = "!git branch --merged | grep -v '\\*\\|main\\|master\\|develop' | xargs -n 1 git branch -d";
            branches = "branch -a";
            remotes = "remote -v";
            # Clone bare with fetch refspec configured and main worktree added (tries main, master, dev)
            clone-bare = ''!f() { url="$1"; dir="''${2:-$(basename "$url" .git).git}"; git clone --bare "$url" "$dir" && git -C "$dir" config remote.origin.fetch '+refs/heads/*:refs/remotes/origin/*' && git -C "$dir" fetch origin && for b in main master dev; do if git -C "$dir" show-ref --verify --quiet "refs/remotes/origin/$b"; then git -C "$dir" worktree add "@/$b" "$b"; break; fi; done; }; f'';
          };
          diff = {
            colorMoved = "default";
          };
          init.defaultBranch = "main";
          core = {
            editor = "kak";
            autocrlf = false;
            safecrlf = true;
            filemode = true;
          };
          help.autocorrect = 1;
          rerere.enabled = true;
          log.date = "relative";
          worktree.guessRemote = true;
          credential.helper = lib.mkIf hasSops "store --file ${
            config.sops.secrets."${giteaCredentials}".path
          }";
          credential."https://github.com".helper = "${lib.getExe pkgs.gh} auth git-credential";
          credential."https://gist.github.com".helper = "${lib.getExe pkgs.gh} auth git-credential";
        };
      };
    };
in
{
  __exports.shared.hm.value = mod;
  __module = mod;
}
