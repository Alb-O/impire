# Flake overlays output
# Collected from __overlays in registry modules
{ inputs, ... }:
{
  nur = inputs.nur.overlays.default;
}
