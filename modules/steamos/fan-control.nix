{ config, lib, pkgs, ... }:

let
  inherit (lib)
    mkIf
    mkMerge
    mkOption
    types
  ;
<<<<<<<< HEAD:modules/steamos/fan-control.nix
  cfg = config.jovian.steamos;
in
{
  options = {
    jovian.steamos = {
========
  cfg = config.jovian.hardware.vendor.valve;
in
{
  options = {
    jovian.hardware.vendor.valve = {
>>>>>>>> bb9bbf2 (hardware/vendor/valve: Consolidated common modules into modules/hardware/vendor/valve):modules/hardware/vendor/valve/fan-control.nix
      enableOsFanControl = mkOption {
        description = ''
          Whether to enable the OS-controlled fan curve.

          This is enabled by default since SteamOS 3.2.
        '';
        type = types.bool;
<<<<<<<< HEAD:modules/steamos/fan-control.nix
        default = cfg.useSteamOSConfig;
        defaultText = lib.literalExpression "config.jovian.steamos.useSteamOSConfig";
========
        default = cfg.enable;
        defaultText = lib.literalExpression "config.jovian.hardware.vendor.valve.enable";
>>>>>>>> bb9bbf2 (hardware/vendor/valve: Consolidated common modules into modules/hardware/vendor/valve):modules/hardware/vendor/valve/fan-control.nix
      };
    };
  };

  config = mkIf (cfg.enableOsFanControl) {
    systemd.services.jupiter-fan-control = {
      wantedBy = [ "multi-user.target" ];
      path = [ pkgs.dmidecode ];
      serviceConfig = {
        ExecStart = "${pkgs.jupiter-fan-control}/share/jupiter-fan-control/fancontrol.py --run";
        ExecStopPost = "${pkgs.jupiter-fan-control}/share/jupiter-fan-control/fancontrol.py --stop";
        OOMScoreAdjust = -1000;
        Restart = "on-failure";

        # disable debug journal logging
        StandardOutput = "null";
      };
      environment = {
        PYTHONUNBUFFERED = "1";
      };
    };
  };
}
