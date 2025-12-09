# Mouse Pointer Stutter - Failed Fixes Documentation

**Date**: Wed Dec 10 2025\
**Hardware**: Logitech MX Master 4 (Bolt Receiver) - USB ID `046d:c548`\
**System**: AMD CPU, Nvidia GPU, NixOS

## Problem Description

Wireless mouse pointer stuttering/lag issues despite various USB power management and kernel parameter adjustments.

______________________________________________________________________

## Timeline

### Initial Config (4 days ago - commit 57b00cd)

Started with basic USB autosuspend disabled:

**nix/registry/hosts/desktop/config/boot.nix**:

```nix
kernelParams = [
  "usbcore.autosuspend=-1"
  # ... other params
];

kernelModules = [
  "hid-logitech-dj"
  "hid-logitech-hidpp"
  # ... other modules
];

initrd.availableKernelModules = [
  "usbhid"
  "usb_storage"
  # ... other modules
];
```

**Status**: ❌ DID NOT WORK

______________________________________________________________________

### Latest Attempt (8 hours ago - commit 77ad401)

"fix allowUnfree, attempt wireless mouse fix, kms"

Added multiple layers of USB fixes:

#### Kernel Parameters Added

**File**: `nix/registry/hosts/desktop/config/boot.nix:5-7`

```nix
kernelParams = [
  "usbcore.autosuspend=-1"      # Already present - disables global USB autosuspend
  "usbhid.mousepoll=1"           # NEW - sets mouse polling rate to 1ms
  "usbcore.quirks=046d:c548:gki" # NEW - USB quirks for MX Master 4
  # ... other params
];
```

**Quirk flags**:

- `g` = NO_LPM (disable Link Power Management)
- `k` = NO_AUTOSUSPEND
- `i` = RESET_RESUME

#### Udev Rules Added

**File**: `nix/registry/hosts/desktop/config/services.nix:6-14`

```nix
udev.extraRules = ''
  # Logitech USB receivers - disable autosuspend (ALL Logitech devices)
  ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="046d", ATTR{power/control}="on"
  
  # Logitech Bolt Receiver (MX Master 4) - specific device targeting
  ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="046d", ATTR{idProduct}=="c548", ATTR{power/control}="on", ATTR{power/autosuspend}="-1"
'';
```

**Status**: ❌ DID NOT WORK

______________________________________________________________________

## Configuration Summary - What Was Tried

### ✅ Kernel Modules Loaded

**File**: `nix/registry/hosts/desktop/config/boot.nix:13-19`

```nix
kernelModules = [
  "hid-logitech-dj"      # Logitech DJ receiver support
  "hid-logitech-hidpp"   # Logitech HID++ protocol support
  # ... other modules
];

initrd.availableKernelModules = [
  "usbhid"
  "usb_storage"
  # ... other modules
];
```

### ✅ Kernel Parameters Tried

1. **`usbcore.autosuspend=-1`** - Global USB autosuspend disabled
1. **`usbhid.mousepoll=1`** - Force 1ms polling interval for USB HID mice
1. **`usbcore.quirks=046d:c548:gki`** - Device-specific USB quirks (no LPM, no autosuspend, reset resume)

### ✅ Udev Rules Tried

1. **Vendor-wide rule** - All Logitech devices (`046d:*`)

   - Set `power/control=on` (disable autosuspend at device level)

1. **Device-specific rule** - MX Master 4 Bolt Receiver (`046d:c548`)

   - Set `power/control=on`
   - Set `power/autosuspend=-1` (double-disable autosuspend)

### 🤔 Power Management Settings

**File**: `nix/registry/hosts/desktop/config/hardware.nix:9-10`

```nix
nvidia = {
  powerManagement.enable = true;        # Nvidia PM enabled
  powerManagement.finegrained = false;  # Coarse PM (not per-device)
  # ...
};
```

**Note**: Nvidia power management is ENABLED. Unknown if this interacts with USB power management.

______________________________________________________________________

## What Didn't Work

### Layer 1: Global Kernel Parameters ❌

- `usbcore.autosuspend=-1` alone was insufficient

### Layer 2: Device-Specific Kernel Quirks ❌

- `usbcore.quirks=046d:c548:gki` (no LPM, no autosuspend, reset resume) did not resolve stuttering

### Layer 3: Aggressive Polling ❌

- `usbhid.mousepoll=1` (1ms polling) did not improve responsiveness

### Layer 4: Udev Runtime Control ❌

- Setting `power/control=on` via udev rules did not prevent stuttering
- Redundant `power/autosuspend=-1` setting had no additional effect

### Layer 5: Vendor-Wide Disabling ❌

- Targeting all Logitech devices (`046d:*`) was no more effective than device-specific rules

______________________________________________________________________

## Potential Unexplored Issues

1. **Nvidia Power Management Interaction**

   - `hardware.nvidia.powerManagement.enable = true` might be causing system-wide power state changes affecting USB
   - Try disabling Nvidia PM?

1. **USB Controller Power State**

   - `xhci_pci` module loaded but no specific power config
   - May need `xhci_hcd` power management tweaks

1. **CPU Power States**

   - AMD P-state disabled (`initcall_blacklist=amd_pstate_init`)
   - But CPU C-states not explicitly configured

1. **Compositor/Wayland Issues**

   - Using Niri compositor (Wayland)
   - Stuttering might be rendering-related, not USB-related

1. **Interrupt Coalescing**

   - No explicit interrupt handling optimization
   - USB interrupts might be delayed/batched

1. **Bluetooth Interference**

   - Using Bolt receiver (not Bluetooth) but system has Bluetooth enabled
   - RF interference?

______________________________________________________________________

## Next Steps (Nuclear Option)

Planning to **remove ALL mouse/USB power management config** and test if stuttering:

- Persists → Problem is NOT USB power management
- Resolves → One of the configs is actually CAUSING the issue

Files to clean up:

- `nix/registry/hosts/desktop/config/boot.nix` - remove `usbhid.mousepoll`, `usbcore.quirks`, possibly `usbcore.autosuspend`
- `nix/registry/hosts/desktop/config/services.nix` - remove all `udev.extraRules`
- `nix/registry/hosts/desktop/config/hardware.nix` - consider toggling `nvidia.powerManagement.enable`

______________________________________________________________________

## Device Info

**Mouse**: Logitech MX Master 4\
**Receiver**: Logitech Bolt Receiver\
**USB Vendor ID**: `046d` (Logitech)\
**USB Product ID**: `c548` (Bolt Receiver)

**Verify with**:

```bash
lsusb | grep -i logitech
# Should show: Bus XXX Device XXX: ID 046d:c548 Logitech, Inc. Bolt Receiver
```

______________________________________________________________________

## References

**Git Commits**:

- `57b00cd` (4 days ago) - "init" - Initial config with basic `usbcore.autosuspend=-1`
- `77ad401` (8 hours ago) - "fix allowUnfree, attempt wireless mouse fix, kms" - Added polling, quirks, and udev rules

**Modified Files**:

- `nix/registry/hosts/desktop/config/boot.nix`
- `nix/registry/hosts/desktop/config/services.nix`
- `nix/registry/hosts/desktop/config/hardware.nix`
