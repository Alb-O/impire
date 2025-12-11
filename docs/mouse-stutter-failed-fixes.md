# MX Master 4 Mouse Stutter

Logitech MX Master 4 with Bolt receiver (`046d:c548`) on NixOS with AMD CPU and Nvidia GPU. The mouse exhibits intermittent pointer stuttering that correlates with GPU load rather than USB activity.

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

## Current hypothesis: Nvidia driver frame timing

The stutter correlates with GPU-intensive rendering: complex browser animations, video decoding, compositor effects. This points to the Nvidia driver's power state transitions causing frame timing jitter in niri, which then affects input event delivery.

The G502 Lightspeed likely masked this because its receiver firmware optimizes for tighter latency tolerances than Bolt, which prioritizes battery life and multi-device pairing.

## Fixes to test

Disable Nvidia power management in `hardware.nix`:

```nix
nvidia = {
  powerManagement.enable = false; # was true
  powerManagement.finegrained = false;
};
```

If stutter persists, force cursor rendering through the main framebuffer instead of DRM cursor planes. In niri config:

```kdl
debug {
    disable-cursor-plane
}
```

If still present, disable PowerMizer entirely via kernel parameter:

```nix
kernelParams = [
  "nvidia.NVreg_RegistryDwords=PowerMizerEnable=0x0"
];
```

There's also a known niri/Nvidia VRAM heap issue. Create `/etc/nvidia/nvidia-application-profiles-rc.d/50-niri.json`:

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

## Commits

- `57b00cd` initial config with `usbcore.autosuspend=-1`
- `77ad401` added polling, quirks, udev rules (all ineffective)
