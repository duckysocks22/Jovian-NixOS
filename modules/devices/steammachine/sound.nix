{ config, lib, pkgs, ... }:

let
  cfg = config.jovian.devices.steammachine;
in
{
  options = {
    jovian.devices.steammachine = {
      enableSoundSupport = lib.mkOption {
        default = cfg.enable;
        defaultText = lib.literalExpression "config.jovian.devices.steammachine.enable";
        type = lib.types.bool;
        description = ''
          Whether to enable sound support.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enableSoundSupport {
    services.pulseaudio.enable = false;

    # Same audio stack Valve ships on SteamOS across devices; confirmed
    # working on the Steam Machine. No device DSP config exists upstream
    # for it yet (the Deck's steamdeck-dsp is Van Gogh-specific).
    services.pipewire = {
      enable = true;
      package = pkgs.pipewire-jupiter;
      pulse.enable = true;
      alsa.enable = true;
      wireplumber.package = pkgs.wireplumber-jupiter;
    };
  };
}
