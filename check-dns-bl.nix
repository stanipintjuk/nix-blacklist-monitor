{ config, lib, pkgs, ... }:
let
  cfg = config.checkDnsBL;
  script = builtins.fetchUrl cfg.scriptUrl;
  runScript = "${pkgs.python35} ${script}";
  
  mailTo = builtins.foldl' (x: y: "${x} ${y}") "" cfg.mailTo;
  
  reportHtml = pkgs.writeScript "htmlmailgen" (import ./reportmessage.sh pkgs);
  
  sendmail = "${pkgs.postfix}/bin/sendmail";
  sendmailCommand = "${sendmail} -f ${cfg.mailFrom} -t ${mailTo}";
  
  testmsg = "echo 'line1\nline2\nline3'";
  
  command = ''${reportHtml} "$(${testmsg})" | ${sendmailCommand}'';
in
{
  environment = lib.mkIf cfg.enable {
    systemPackages = with pkgs; [ python35Packages.dns ];
  };

  
  services = lib.mkIf cfg.enable {
    cron = {
      enable = true;
      systemCronJobs = [
        (builtins.trace "**${command}**" ''*/1 * * * *  root ${command}'')
      ];
    };
  };
}
