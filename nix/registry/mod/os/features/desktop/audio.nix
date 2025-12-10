/**
  Audio feature for NixOS.

  PipeWire with ALSA, PulseAudio, and JACK support.
*/
let
  mod =
    { ... }:
    {
      services.pipewire = {
        enable = true;

        # probably not needed
        #alsa.enable = true;
        #alsa.support32Bit = true;
        #pulse.enable = true;
        #jack.enable = true;
      };
    };
in
{
  __exports."desktop.nixos".value = mod;
  __module = mod;
  __functor = _: mod;
}
