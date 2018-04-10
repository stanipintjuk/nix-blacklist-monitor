{ pkgs, config, lib, ...}:
with lib;
let
  mailTester = import ./mail-tester.nix;
in
{
  options.mailTester = {
    enable = mkEnableOption "nixos-mail-tester";

    sendReportsTo = mkOption {
      type = types.addCheck (types.listOf types.str) (l: l != []);
      example = [ "example.com" ];
      default = [];
      description = ''
        Email addresses to send reports to if mail tests fail.
        '';
    };

    emailUser = mkOption {
      type = types.str;
      description = ''The email address that will send the test emails to mail-tester.com'';
    };

    emailPassword = mkOption {
      type = types.str;
      description = ''The password to the email that will send the test email to mail-tester.com'';
    }; 

    minMark = mkOption {
      type = types.str;
      example = "-2.0";
      default = "-2.0";
      description = ''The minimal accepted mark on mail-tester.com'';
    };

    reporterEmail = mkOption {
      type = types.str;
      example = "mailtester@example.com";
      default = "mailtester@${config.networking.domain}";
      description = ''
        The email address from which the reports about failed mail tests would be sent.
        '';
    };
  };

  config.services = lib.mkIf config.mailTester.enable {
    cron = {
      enable = true;
      systemCronJobs = 
        let
          cfg = config.mailTester;
          cronMonitor = import ../cron-monitor/cron-monitor.nix { inherit pkgs; sendReportsTo = cfg.sendReportsTo; };
          exec = mailTester {
            inherit pkgs;
            fromEmail = cfg.emailUser;
            password = cfg.emailPassword;
            minMark = cfg.minMark;
            sendReportsTo = cfg.sendReportsTo;
            reporterEmail = cfg.reporterEmail;
          };
      in
        [''0 5 * * *  root ${cronMonitor exec}'' ];
    };
  };
}
