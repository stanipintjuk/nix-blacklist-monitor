{ pkgs, lib, config, ... }:
with lib;
{
  options.uptimeReports = {
    enable = mkEnableOption "nixos-uptime-reports";

    sendReportsTo = mkOption {
      type = types.addCheck (types.listOf types.str) (l: l != []);
      example = [ "example.com" ];
      default = [];
      description = ''
        Email addresses to send the uptime reports to.
        '';
    };
  };

  config.services = lib.mkIf config.uptimeReports.enable {
    cron = {
        enable = true;
        systemCronJobs = 
          let
            cfg = config.uptimeReports;
            sendReportsTo = cfg.sendReportsTo;
            email = script: "${script} | ${pkgs.postfix}/bin/sendmail -t ${toString sendReportsTo}";
            cronMonitor = import ../cron-monitor/cron-monitor.nix { inherit pkgs sendReportsTo; };
            exec = email (import ./uptime-report.nix pkgs);
          in
            [''0 8 25 * *  root ${cronMonitor exec}'' ];
    };
  };
}
