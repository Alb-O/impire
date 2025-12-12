# MX Master 4 Mouse Stutter

Logitech MX Master 4 with Bolt receiver (`046d:c548`) on NixOS with AMD CPU and Nvidia GPU. The mouse exhibits intermittent pointer stuttering that **definitively correlates with CPU/GPU compute workload**, especially when browsers (Firefox or Chromium) load heavy tabs and pages. This is not a USB power management issue.

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

## Root cause: Compute workload affecting input event delivery

The stutter **definitively occurs under CPU/GPU compute load**, particularly when browsers (tested with both Firefox and Chromium) load heavy tabs and pages. This is not GPU-specific—it happens with any significant compute workload that saturates system resources.

The issue appears to be the system's inability to maintain consistent input event delivery timing when under heavy load. The Nvidia driver's frame timing or power state transitions may exacerbate this, but the core problem is compute saturation affecting event processing.

The G502 Lightspeed likely masked this because its receiver firmware optimizes for tighter latency tolerances than Bolt, which prioritizes battery life and multi-device pairing.

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

## Fixes to test

There's a known niri/Nvidia VRAM heap issue. Create `/etc/nvidia/nvidia-application-profiles-rc.d/50-niri.json`:

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
- Removed PowerMizer disable kernel parameter after confirming ineffective
