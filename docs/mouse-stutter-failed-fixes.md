# MX Master 4 Mouse Stutter

Logitech MX Master 4 with Bolt receiver (`046d:c548`) on NixOS with AMD CPU and Nvidia GPU. The mouse exhibits intermittent pointer stuttering that occurs **even when the system is idle or under light load**. The stutter can be temporarily resolved by switching the mouse off and on again, but will return after some time. This is not a USB power management issue or a performance load issue.

## USB power management is not the cause

Extensive testing ruled out USB power management. The following were tried in combination and individually, none resolved the stutter:

```nix
# boot.nix - kernel parameters
kernelParams = [
  "usbcore.autosuspend=-1"       # global USB autosuspend off
  "usbhid.mousepoll=1"           # force 1ms polling
  "usbcore.quirks=046d:c548:gki" # g=NO_LPM, k=NO_AUTOSUSPEND, i=RESET_RESUME
];

kernelModules = [
  "hid-logitech-dj"    # DJ receiver protocol
  "hid-logitech-hidpp" # HID++ protocol for Bolt/Unifying
];
```

```nix
# services.nix - udev rules
udev.extraRules = ''
  ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="046d", ATTR{power/control}="on"
  ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="046d", ATTR{idProduct}=="c548", ATTR{power/autosuspend}="-1"
'';
```

Moving the Bolt receiver to a USB hub closer to the mouse made no difference. The previous mouse, a G502 Lightspeed, did not exhibit this behavior on identical hardware.

## Root cause: Unknown (not performance-related)

The stutter occurs **even when the system is idle or under light load**, ruling out CPU/GPU compute workload as the cause. The issue appears intermittently and can be temporarily resolved by switching the mouse off and on again, suggesting a firmware or receiver-level issue rather than system resource contention.

The G502 Lightspeed did not exhibit this behavior on identical hardware, pointing to differences in how the Bolt receiver or MX Master 4 firmware handles connection stability compared to Lightspeed's receiver protocol.

## Nvidia power management is not the cause

Disabling Nvidia power management did not resolve the stutter:

```nix
nvidia = {
  powerManagement.enable = false;
  powerManagement.finegrained = false;
};
```

## Disabling cursor plane is not the cause

Forcing cursor rendering through the main framebuffer instead of DRM cursor planes did not resolve the stutter:

```kdl
debug {
    disable-cursor-plane
}
```

## PowerMizer disable is not the cause

Disabling PowerMizer entirely via kernel parameter did not resolve the stutter:

```nix
kernelParams = [
  "nvidia.NVreg_RegistryDwords=PowerMizerEnable=0x0"
];
```

## VRAM heap configuration is not the cause

The niri/Nvidia VRAM heap issue was tested by creating `/etc/nvidia/nvidia-application-profiles-rc.d/50-niri.json`:

```json
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
```

This did not resolve the stutter.

## Solaar configuration is not the cause

Installed latest Solaar and configured the MX Master 4 properly. The device shows up correctly in Solaar and all settings are accessible/configurable. However, adjusting Solaar settings (polling rate, power management, etc.) did not resolve the stutter.

## Commits

- `57b00cd` initial config with `usbcore.autosuspend=-1`
- `77ad401` added polling, quirks, udev rules (all ineffective)
- Removed PowerMizer disable kernel parameter after confirming ineffective
