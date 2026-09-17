{ config, lib, pkgs, ... }:
let
  inherit (lib) 
    mkIf
    mkOption
    types;
  cfg = config.jovian.devices.steammachine;
in
{
  options = {
    jovian.devices.steammachine = {
      enableECLogging = mkOption {
        type = types.bool;
        default = cfg.enable;
        defaultText = lib.literalExpression "config.jovian.devices.steammachine.enable";
        description = ''
          Whether to forward the 'ec-log' to the systems log
        '';
      };
    };
  };

  config = mkIf cfg.enableECLogging {
    systemd.services.ec-log = {
      description = "Forward EC log to system log";
      wantedBy = [ "multi-user.target" ];
      requires = [ "sys-kernel-debug.mount" ];
      after = [ "sys-kernel-debug.mount" ];
      unitConfig.ConditionPathExists = "/sys/kernel/debug/cros_ec/console_log";
      serviceConfig = {
        LogNamespace = "ec-log";
        ExecStart = "${pkgs.util-linuxMinimal}/bin/logger --tag ec-log --file /sys/kernel/debug/cros_ec/console_log";
        Restart = "always";
        RestartSteps = 4;
        RestartMaxDelaySec = "10s";
      };
    };
  };
}
