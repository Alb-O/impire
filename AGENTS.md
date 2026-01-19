# Adding SSH Hosts

1. Add host to `mod/dual/ssh.nix` matchBlocks:
   ```nix
   "hostname" = {
     hostname = "1.2.3.4";
     user = "username";
   };
   ```

2. Store password in sops:
   ```bash
   sops set users/<user>/secrets.yaml '["ssh"]["hostname"]["password"]' '"thepassword"'
   ```

3. Expose in `users/<user>/default.nix` sops.secrets:
   ```nix
   secrets."ssh/hostname/password" = {
     path = "${config.home.homeDirectory}/.ssh/hostname-password";
   };
   ```

4. Rebuild, then: `sshpass -f ~/.ssh/hostname-password ssh hostname`
