{ config, lib, pkgs, ... }:
let
  cfg = config.checkDnsBL;
  script = builtins.fetchurl cfg.scriptUrl;
  checkBlackList = addr: "${pkgs.python35}/bin/python3 ${script} ${addr}";

  mailingList = builtins.foldl' (x: y: "${x} ${y}") "" cfg.mailTo;

  htmlEmail = pkgs.writeScript "htmlmailgen" (import ./html-email.nix pkgs);
  sendmail = "${pkgs.postfix}/bin/sendmail";
  sendmailCommand = "${sendmail} -f ${cfg.mailFrom} -t ${mailingList}";

  command = addr: ''${htmlEmail} "$(${checkBlackList addr})" | ${sendmailCommand}'';
in
{
  environment = lib.mkIf cfg.enable {
    systemPackages = with pkgs; [ python35Packages.dns python35 ];
  };

  
  services = lib.mkIf cfg.enable {
    cron = {
      enable = true;
      systemCronJobs = builtins.map (addr: ''*/1 * * * *  root ${command addr}'') cfg.addresses;
    };
  };
}
