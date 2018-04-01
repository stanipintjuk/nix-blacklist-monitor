{ config, lib, pkgs, ... }:
let
  cfg = config.checkDnsBL;
  script = builtins.fetchurl cfg.scriptUrl;
  executable = ''PYTHONPATH="$PYTHONPATH:${pkgs.python35Packages.dns}/lib/python3.5/site-packages" ${pkgs.python35}/bin/python3 ${script}'';

  mailTemplate = pkgs.writeScript "htmlmailgen" (import ./html-email.nix 
    { 
      inherit pkgs; 
      subject = "I found $2 in a blacklisted";
      title = "$2 is blacklisted";
    });
  mailIfFail = import ./mail-if-fail.nix;

  checkAddress = addr: mailIfFail {
    inherit pkgs;
    exec = executable;
    args = addr;
    mailTemplate = mailTemplate;
    mailFrom = cfg.mailFrom;
    mailTo = cfg.mailTo;
  };
in
{
  services = lib.mkIf cfg.enable {
    cron = {
      enable = true;
      systemCronJobs = builtins.map 
        (addr: ''0 5 * * *  root ${checkAddress addr}'') 
        cfg.addresses;
    };
  };
}
