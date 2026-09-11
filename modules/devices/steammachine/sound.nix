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

  config = let
    systemWide = config.services.pipewire.systemWide;

    extraEnv.ALSA_CONFIG_UCM2 = "${alsa-ucm-conf'}/share/alsa/ucm2";
  in lib.mkIf cfg.enableSoundSupport {
    services.pulseaudio.enable = false;

    services.pipewire = {
      enable = true;
      package = pkgs.pipewire-jupiter;
      pulse.enable = true;
      alsa.enable = true;
      configPackages = [ pkgs.steamdeck-dsp ];
      wireplumber.package = pkgs.wireplumber-jupiter;
      wireplumber.configPackages = [ pkgs.steamdeck-dsp ];
    };

    environment.variables = extraEnv;

    systemd.packages = [ pkgs.steamdeck-dsp ];

    systemd.services.pipewire.environment = lib.mkIf systemWide extraEnv;
    systemd.user.services.pipewire.environment = lib.mkIf (!systemWide) extraEnv;

    systemd.services.wireplumber.environment = lib.mkIf systemWide extraEnv;
    systemd.user.services.wireplumber.environment = lib.mkIf (!systemWide) extraEnv;

    systemd.services.pipewire-sysconf = {
      enable = true;
      wantedBy = ["multi-user.target"];
    };
    systemd.services.wireplumber-sysconf = {
      enable = true;
      wantedBy = ["multi-user.target"];
    };
    systemd.user.services.filter-chain = {
      enable = true;
      wantedBy = ["default.target"];
    };
  };
}
