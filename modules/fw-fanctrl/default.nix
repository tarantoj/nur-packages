# based on https://blog.stigok.com/2019/11/05/packing-python-script-binary-nicely-in-nixos.html
{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.services.fw-fanctrl;
  configFile = pkgs.writeText "config.json" (builtins.toJSON config.services.fw-fanctrl.config);
in {
  options.services.fw-fanctrl = with lib; {
    enable = mkEnableOption "fw-fanctrl";
    config = mkOption {
      defaultStrategy = mkOption {
        type = types.str;
      };
      strategyOnDischarging = lib.mkOption {
        type = types.str;
        default = null;
      };
      batteryChargingStatusPath = mkOption {
        type = types.str;
        default = "/sys/class/power_supply/BAT1/status";
      };
      strategies = mkOption {
        type = types.attrsOf (types.submodule (
          {name, ...}: {
            fanSpeedUpdateFrequency = mkOption {type = types.int;};
            movingAverageInterval = mkOption {type = types.int;};
            speedCurve = mkOption {
              type = types.listOf (types.submodule {
                temp = mkOption {type = types.int;};
                speed = {type = types.int;};
              });
            };
          }
        ));
        default = {};
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.fw-fanctrl = {
      description = "Framework fan controller.";
      environment = {
        PYTHONUNBUFFERED = "1";
      };

      after = ["multi-user.target"];
      wantedBy = ["multi-user.target"];

      serviceConfig = {
        ExecStart = "${pkgs.fw-fanctrl}/bin/fanctrl.py --config ${configFile}";
        Type = "simple";
      };
    };
  };
}
