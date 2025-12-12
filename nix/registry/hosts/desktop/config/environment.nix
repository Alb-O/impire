# Environment configuration for desktop
{ pkgs, ... }:
{
  systemPackages = [ pkgs.lm_sensors ];

  # Nvidia application profile for niri compositor
  # Workaround for VRAM heap issue causing input stutter under load
  etc."nvidia/nvidia-application-profiles-rc.d/50-niri.json" = {
    text = ''
      {
          "rules": [{
              "pattern": {"feature": "procname", "matches": "niri"},
              "profile": "Limit Free Buffer Pool On Wayland Compositors"
          }],
          "profiles": [{
              "name": "Limit Free Buffer Pool On Wayland Compositors",
              "settings": [{"key": "GLVidHeapReuseRatio", "value": 0}]
          }]
      }
    '';
  };
}
