{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    mkIf
    mkOption
    types
    ;
  cfg = config.jovian.steamos;
in
{
  options = {
    jovian.steamos = {
      enableHdmiCecIntegration = mkOption {
        default = cfg.useSteamOSConfig;
        defaultText = lib.literalExpression "config.jovian.steamos.useSteamOSConfig";
        type = types.bool;
        description = ''
          Whether to enable SteamOS HDMI-CEC integration.
        '';
      };
    };
  };

  config = mkIf cfg.enableHdmiCecIntegration {
    environment.systemPackages = [ pkgs.jovianPackages.cecd ];
    services.dbus.packages = [ pkgs.jovianPackages.cecd ];
    services.udev.packages = [
      pkgs.jovianPackages.cecd
      pkgs.jovianPackages.inputattach-cec-units
    ];
    systemd.packages = [
      pkgs.jovianPackages.cecd
      pkgs.jovianPackages.inputattach-cec-units
      pkgs.cec-audio-control
   ];

    systemd.user.services.cecd = {
      overrideStrategy = "asDropin";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "steamos-manager-configure-cecd.service" ];
      after = [ "steamos-manager-configure-cecd.service" ];
    };

    systemd.user.sockets.cec-audio-control = {
      overrideStrategy = "asDropin";
      wantedBy = [ "sockets.target" ];
    };

    systemd.user.services.cec-audio-control = {
      overrideStrategy = "asDropin";
      wants = [ "cecd.service" ];
      after = [ "cecd.service" ];
    };
  };
}
