{ config, lib, pkgs, ... }:
let
  cfg = config.checkDnsBL;
  script = builtins.fetchurl cfg.scriptUrl;
  checkScript = ''PYTHONPATH="$PYTHONPATH:${pkgs.python35Packages.dns}/lib/python3.5/site-packages" ${pkgs.python35}/bin/python3 ${script}'';

  mailingList = builtins.foldl' (x: y: "${x} ${y}") "" cfg.mailTo;

  htmlEmail = pkgs.writeScript "htmlmailgen" (import ./html-email.nix pkgs);
  sendmail = "${pkgs.postfix}/bin/sendmail";
  sendmailCommand = "${sendmail} -f ${cfg.mailFrom} -t ${mailingList}";

  blackListChecker = import ./check-dns-bl.nix;
in
{
  environment = lib.mkIf cfg.enable {
    systemPackages = with pkgs; [ python35Packages.dns python35 ];
  };

  
  services = lib.mkIf cfg.enable {
    cron = {
      enable = true;
      systemCronJobs = builtins.map 
        (addr: 
          let 
            checkAddress = blackListChecker { 
              inherit pkgs htmlEmail sendmailCommand; 
              #checkScript = "echo 'row1\nrow2\row3'";
              checkScript = checkScript;
              address = addr; 
            };
          in
        ''0 6 * * *  root ${checkAddress}''
        ) 
        cfg.addresses;
    };
  };
}
