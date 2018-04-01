{ pkgs, config, lib, ...}:
with lib;
let
  mail-tester = import ./mail-tester.nix;
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

    mailTesterFromEmail = mkOption {
      type = types.str;
      description = ''The email address that will send the test emails to mail-tester.com'';
    };
    mailTesterUsername = mkOption {
      type = types.str;
      description = ''Your API username on mail-tester.com'';
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
      exec = mail-tester {
        inherit pkgs;
        fromEmail = cfg.mailTesterFromEmail;
        mailTesterUsername = cfg.mailTesterUsername;
        minMark = cfg.minMark;
        sendReportsTo = cfg.sendReportsTo;
        reporterEmail = cfg.reporterEmail;
      };
      in
        [''0 5 * * *  root ${exec}'' ];
    };
  };
}
